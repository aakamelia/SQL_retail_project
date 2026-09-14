# Analisis Data Penjualan Retail Menggunakan SQL (DUMMY PROJECT)
Project ini dibuat untuk menunjukkan kemampuan SQL yang biasa digunakan oleh data analyst dalam melakukan eksplorasi, pembersihan, dan analisis data penjualan retail. Project ini mencakup pembuatan database penjualan retail, pembersihan data, exploratory data analysis (EDA), hingga menjawab pertanyaan-pertanyaan bisnis menggunakan query SQL.
Catatan: Ini merupakan dummy project (data latihan/simulasi) yang dibuat untuk keperluan belajar dan portofolio, bukan data penjualan dari perusahaan atau bisnis nyata.
## Objectives
Set up database penjualan retail: Membuat dan mengisi database penjualan retail dengan data yang tersedia.
Data Cleaning: Mengidentifikasi dan menghapus data yang kosong (null).
Exploratory Data Analysis (EDA): Melakukan eksplorasi dasar untuk memahami dataset.
Business Analysis: Menggunakan SQL untuk menjawab pertanyaan bisnis spesifik dan mengambil insight dari data penjualan.
## Project Structure
**1. Database Setup**
- **Database Creation**:Project ini dimulai dengan membuat database bernama SQL_project_kamelia.
- **Table Creation**: Tabel retail_sales dibuat untuk menyimpan data penjualan, dengan kolom-kolom berikut: transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantiy, price_per_unit, cogs, dan total_sale.

```sql
CREATE DATABASE SQL_project_kamelia;

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
```
## 2. Data Exploration & Cleaning
- **Record Count**: Menghitung total jumlah baris data pada tabel.
- **Null Check**: Memeriksa apakah ada data yang kosong pada kolom-kolom penting.
- **Data Cleaning**: Menghapus baris data yang memiliki nilai kosong (null).
- **Customer Count**: Menghitung jumlah pelanggan unik dalam dataset.
- **Category Count**: Melihat kategori produk yang tersedia dalam dataset.
```sql
SELECT * FROM retail_sales LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

-- memeriksa apakah ada data yang kosong
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	gender IS NULL OR
	category IS NULL OR
	quantiy IS NULL OR 
	cogs IS NULL OR
	total_sale IS NULL;

-- menghapus data yang kosong
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	gender IS NULL OR
	category IS NULL OR
	quantiy IS NULL OR 
	cogs IS NULL OR
	total_sale IS NULL;

-- berapa banyak kode unik customer
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales;

-- jumlah kategori
SELECT DISTINCT category FROM retail_sales;
```
## 3. Data Analysis & Business Questions
Berikut adalah pertanyaan bisnis yang dijawab menggunakan query SQL pada project ini:
1. Mengambil transaksi kategori 'Clothing' dengan jumlah terjual lebih dari 4 pada bulan November 2022
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantiy >= 4;
```
2. Mengambil semua data penjualan pada tanggal '2022-11-05'
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```
3. Menghitung total penjualan (total_sale) untuk setiap kategori
```sql
SELECT
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_order
FROM retail_sales
GROUP BY 1;
```
4. Mencari semua transaksi dengan total_sale lebih besar dari 1000
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```
5. Mencari rata-rata umur pelanggan yang membeli barang dari kategori 'Beauty'
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```
6. Menghitung total transaksi berdasarkan gender di setiap kategori
```sql
SELECT 
	category,
	gender,
	COUNT(*) AS total_transaksi
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;
```
7. Mencari 5 pelanggan teratas berdasarkan total penjualan tertinggi
```sql
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
8. Menghitung rata-rata penjualan per bulan dan menemukan bulan dengan penjualan tertinggi di setiap tahun
```sql
SELECT
	year,
	month,
	avg_sale
FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	FROM retail_sales
	GROUP BY 1, 2
) AS t1
WHERE rank = 1;
```
9. Mencari pelanggan yang melakukan transaksi berulang kali (lebih dari 1 kali)
```sql
SELECT
    customer_id,
    COUNT(*) AS jumlah_transaksi
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 1;
```
10. Menghitung total penjualan per hari dalam seminggu
```sql
SELECT
    TO_CHAR(sale_date, 'Day') AS hari,
    COUNT(*) AS total_transaksi,
    SUM(total_sale) AS total_penjualan
FROM retail_sales
GROUP BY 1
ORDER BY total_penjualan DESC;
```
11. Membagi transaksi ke dalam shift waktu (Pagi <=12, Siang 12-17, Malam >17) dan menghitung jumlah pesanan per shift
```sql
WITH jam_penjualan AS (
	SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'pagi'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'siang'
		ELSE 'malam'
	END AS shift
	FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orderan
FROM jam_penjualan
GROUP BY shift;
```
12. Mencari jumlah pelanggan unik pada setiap kategori
```sql
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS hitung_uniq_customer
FROM retail_sales
GROUP BY category;
```
## Findings
- **Kategori Produk**: Penjualan tersebar di beberapa kategori seperti Clothing dan Beauty, dengan pola pembelian yang berbeda-beda per kategori.
- **Transaksi Bernilai Tinggi**: Terdapat sejumlah transaksi dengan total_sale di atas 1000, menunjukkan adanya pembelian bernilai besar.
- **Tren Bulanan**: Rata-rata penjualan bervariasi tiap bulan, sehingga bisa diketahui bulan dengan performa penjualan terbaik di setiap tahun.
- **Pelanggan Setia**: Ada pelanggan yang melakukan transaksi berulang kali, yang berpotensi menjadi target program loyalitas.
- **Pola Waktu Belanja**: Pembagian shift (pagi, siang, malam) menunjukkan waktu-waktu tersibuk terjadinya transaksi.
- **Pola Mingguan**: Total penjualan per hari dalam seminggu membantu melihat hari dengan traffic penjualan tertinggi.

## Reports
- **Sales Summary**: Ringkasan total penjualan, jumlah transaksi, dan performa tiap kategori produk.
- **Trend Analysis**: Insight mengenai tren penjualan bulanan dan berdasarkan shift waktu.
- **Customer Insights**: Informasi mengenai pelanggan unik, pelanggan teratas, dan pelanggan yang bertransaksi berulang.
