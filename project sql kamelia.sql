-- SQL Sales retail analysis
CREATE DATABASE SQL_project_kamelia;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
    transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME, 
	customer_id	INT,
	gender	VARCHAR(15),
	age	INT,
	category VARCHAR(15),	
	quantiy	INT,
	price_per_unit FLOAT,	
	cogs	FLOAT,
	total_sale FLOAT
	);

SELECT*FROM retail_sales
LIMIT 10 

SELECT
	COUNT(*)
FROM retail_sales

--memeriksa apakah ada data yang kosong
SELECT*FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	cogs  IS NULL
	OR
	total_sale IS NULL;

--menghapus data yang kosong
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	cogs  IS NULL
	OR
	total_sale IS NULL;


--Data Exploration

-- Berapa penjualan
SELECT COUNT(*) AS total_sale FROM retail_sales

-- Berapa banyak kode unique customer
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales

--jumlah kategori
SELECT DISTINCT category FROM retail_sales

-- DATA ANALYSIS DAN BUSINESS PROBLEM
--Tulis query SQL untuk mengambil semua kolom dari data penjualan pada tanggal '2022-11-05'
SELECT*
FROM retail_sales
WHERE sale_date='2022-11-05'

-- Tulis query SQL untuk mengambil semua transaksi di mana kategorinya adalah 'Clothing' dan jumlah yang terjual lebih dari 4 pada bulan Nov-2022

SELECT*
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantiy >= 4

-- Tulis query SQL untuk menghitung total penjualan (total_sale) untuk setiap kategori.
SELECT
	category,
	SUM (total_sale) as net_sale,
	COUNT(*) as total_order
FROM retail_sales
GROUP BY 1

-- Tulis query SQL untuk mencari rata-rata umur pelanggan yang membeli barang dari kategori 'Beauty'.
SELECT
	ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category ='Beauty'

-- Tulis query SQL untuk mencari semua transaksi di mana total_sale lebih besar dari 1000.
SELECT*FROM retail_sales
WHERE total_sale >1000

-- Tulis query SQL untuk mencari total jumlah transaksi (transaction_id) yang dilakukan oleh setiap gender di masing-masing kategori.
SELECT 
	category,
	gender,
	COUNT(*) as total_transaksi
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY 1

-- Tulis query SQL untuk menghitung rata-rata penjualan untuk setiap bulan. Temukan bulan dengan penjualan terbaik (tertinggi) di setiap tahun.
SELECT
	year,
	month,
	avg_sale
FROM
(
SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK ()OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC)
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1

-- Tulis query SQL untuk mencari 5 pelanggan teratas berdasarkan total penjualan tertinggi.
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Tulis query SQL untuk mencari jumlah pelanggan unik yang membeli barang dari setiap kategori.
SELECT 
	category,
	COUNT (DISTINCT customer_id) as hitung_uniq_customer
FROM retail_sales
GROUP BY category

-- Q.10 Tulis query SQL untuk membuat pembagian shift dan jumlah pesanan (Contoh: Pagi <=12, Siang Antara 12 & 17, Malam >17)

WITH jam_penjualan
AS (
	SELECT *,
	CASE 
		WHEN EXTRACT (HOUR FROM sale_time)<12 THEN 'pagi'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'siang'
		ELSE 'malam'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orderan
FROM jam_penjualan
GROUP BY shift



-- hitung customer yang belanja berulang kali
SELECT
    customer_id,
    COUNT(*) as jumlah_transaksi
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- total Penjualan per hari dalam seminggu
SELECT
    TO_CHAR(sale_date, 'Day') as hari,
    COUNT(*) as total_transaksi,
    SUM(total_sale) as total_penjualan
FROM retail_sales
GROUP BY 1
ORDER BY total_penjualan DESC;


