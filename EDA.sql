-- Membuat Database
CREATE DATABASE "MILESTONE PO";

--- Membuat tabel staging
CREATE TABLE staging (
product_id VARCHAR (20),
brand VARCHAR (50),
product_name VARCHAR (200),
diskon INT,
price INT
);

--Insert data ke tabel staging
COPY staging (product_id,brand,product_name,diskon,price)
FROM 'C:\tmp\coda_P0M1_zafirah_aida.csv'
DELIMITER ','
CSV HEADER;

-- Menampilkan tabel staging
SELECT * FROM staging;


---------------- Pembuatan tabel hasil normalisasi

-- 1. Tabel brands
--- A. Pembuatan tabel brands
CREATE TABLE brands (
brand_id SERIAL PRIMARY KEY,
brand VARCHAR (50) UNIQUE
);
--- B. Insert data ke tabel hasil normalisasi
INSERT INTO brands (brand)
SELECT DISTINCT brand      
FROM staging;
--- C. Menampilkan isi tabel
SELECT * FROM brands;


-- 2. Tabel produk
--- A. Pembuatan tabel product
CREATE TABLE product(
product_id VARCHAR (20) PRIMARY KEY,
brand_id INT REFERENCES brands (brand_id),
product_name VARCHAR (200)
);
--- B. Insert data ke tabel hasil normalisasi
INSERT INTO product(product_id,brand_id,product_name)
SELECT s.product_id,
b.brand_id,
s.product_name
FROM staging s JOIN brands b
ON s.brand = b.brand;
--- C. Menampilkan isi tabel
SELECT * FROM product;


-- 3. Tabel Diskon
--- A. Pembuatan tabel discounts
CREATE TABLE discounts(
product_id VARCHAR (20) REFERENCES product(product_id),
discount_percentage INT,
final_price INT,
PRIMARY KEY (product_id)
);
--- B. Insert data ke tabel hasil normalisasi
INSERT INTO discounts (product_id,discount_percentage,final_price)
SELECT DISTINCT ON (p.product_id) 
p.product_id,
s.diskon,
s.price
FROM staging s JOIN product p
ON s.product_name = p.product_name;
--- C. Menampilkan isi tabel
SELECT * FROM discounts;

----------- ANALISIS DATA ----------------------------------------------------------------------
-- Mengecek apakah ada produk yang tidak masuk ke tabel diskon
SELECT p.product_name, d.discount_percentage
FROM product p
LEFT JOIN discounts d ON p.product_id = d.product_id
WHERE d.product_id IS NULL;

--Aggregated KPI Summary
SELECT 
    COUNT(DISTINCT brand_id) as total_brands,
    COUNT(product_id) as total_products,
    ROUND(AVG(discount_percentage), 1) as overall_avg_discount,
    SUM (final_price) AS total_revenue
FROM brands
JOIN product USING (brand_id)
JOIN discounts USING (product_id);

-- Jumlah produk per Brand & Sebaran Diskon
SELECT brand, 
	ROUND(AVG(discount_percentage), 2) as avg_discount,
	COUNT (product_id) AS total_product
FROM brands 
JOIN product USING (brand_id)
JOIN discounts USING (product_id)
GROUP BY brand
ORDER BY avg_discount DESC;

--- Brand Performance & Inventory Mix
SELECT 
    b.brand,
    CASE 
        WHEN d.final_price > 120000 THEN 'Premium'
        WHEN d.final_price > 75000 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS price_segment,
    COUNT(p.product_id) AS total_products,
    ROUND(AVG(d.final_price), 0) AS avg_price
FROM brands b
JOIN product p ON b.brand_id = p.brand_id
JOIN discounts d ON p.product_id = d.product_id
GROUP BY 1, 2
ORDER BY 1;

-- Perbandingan rata-rata revenue per kategori diskon
SELECT 
    CASE 
        WHEN d.discount_percentage BETWEEN 10 AND 20 THEN 'Reguler Promo'
        WHEN d.discount_percentage BETWEEN 21 AND 30 THEN 'Special Offer'
       	ELSE 'High Value Offer'
    END AS disc_category,
    COUNT(d.product_id) AS total_product,
    ROUND (AVG (d.final_price)) AS avg_revenue
FROM discounts d
GROUP BY 1
ORDER BY avg_revenue DESC;

-- Discount Efficiency (Analisis Produk "Over-Discounted")
SELECT 
    b.brand,
    COUNT(CASE WHEN d.discount_percentage > 30 THEN 1 END) AS high_discount_products,
    ROUND(COUNT(CASE WHEN d.discount_percentage > 30 THEN 1 END)::numeric / COUNT(p.product_id) * 100, 2) AS reliance_on_high_discounts_pct
FROM brands b
JOIN product p ON b.brand_id = p.brand_id
JOIN discounts d ON p.product_id = d.product_id
GROUP BY b.brand
ORDER BY reliance_on_high_discounts_pct DESC;

-- Brand Pricing Integrity (Integritas Harga Brand)
SELECT 
    b.brand,
    MAX(d.final_price) AS priciest_product,
    MIN(d.final_price) AS cheapest_product,
    MAX(d.final_price) - MIN(d.final_price) AS price_gap,
    ROUND(AVG(d.final_price), 0) AS average_brand_price
FROM brands b
JOIN product p ON b.brand_id = p.brand_id
JOIN discounts d ON p.product_id = d.product_id
GROUP BY b.brand
HAVING COUNT(p.product_id) > 1
ORDER BY price_gap DESC;

-- Analisis Dominasi Pasar (Product Variety per Brand)
WITH total_catalog AS (
    SELECT COUNT(*) AS grand_total FROM product
)
SELECT 
    b.brand,
    COUNT(p.product_id) AS product_count,
    ROUND((COUNT(p.product_id)::numeric / (SELECT grand_total FROM total_catalog)) * 100, 2) AS market_share_percentage
FROM brands b
JOIN product p ON b.brand_id = p.brand_id
GROUP BY b.brand
ORDER BY product_count DESC;