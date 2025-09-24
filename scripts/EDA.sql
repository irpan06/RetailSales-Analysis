SELECT * FROM retail_sales;

-- menghitung total customer 
SELECT
	COUNT(DISTINCT(customer_id)) AS total_customer
FROM retail_sales;

-- melihat jumlah kategori
SELECT
	DISTINCT(category)
FROM retail_sales;

-- menghitung jumlah penjualan keseluruhan
SELECT
	SUM(total_sale) AS total_penjualan
FROM retail_sales;

-- menghitung total penjualan dari setiap customer
SELECT 
	customer_id,
	SUM(total_sale) AS total_penjualan
FROM retail_sales
GROUP BY customer_id
ORDER BY customer_id;

-- menghitung total penjualan berdasarkan kategori
SELECT
	category,
	SUM(total_sale) AS total_penjualan
FROM retail_sales
GROUP BY category
ORDER BY category;

-- menghitung total penjualan dan distribusi gender untuk masing masng kategori
-- total (seluruh kategori)
SELECT
	gender,
	COUNT(gender) AS jumlah,
	SUM(total_sale) AS total_penjualan
FROM retail_sales
GROUP BY gender;

-- Beauty
SELECT
	gender,
	COUNT(gender) AS jumlah,
	SUM(total_sale) AS total_penjualan
FROM retail_sales
WHERE category = "Beauty"
GROUP BY gender;

-- Clothing
SELECT
	gender,
	COUNT(gender) AS jumlah,
	SUM(total_sale) AS total_penjualan
FROM retail_sales
WHERE category = "Clothing"
GROUP BY gender;

-- Electronics
SELECT
	gender,
	COUNT(gender) AS jumlah,
	SUM(total_sale) AS total_penjualan
FROM retail_sales
WHERE category = "Electronics"
GROUP BY gender;


-- menghitung umur rata-rata pada tiap gender untuk masing-masing kategori
-- total (seluruh kategori)
SELECT
	gender,
	ROUND(AVG(age)) AS umur
FROM retail_sales
GROUP BY gender;

-- beauty
SELECT
	gender,
	ROUND(AVG(age)) AS umur
FROM retail_sales
WHERE category = "Beauty"
GROUP BY gender;

-- clothing
SELECT
	gender,
	ROUND(AVG(age)) AS umur
FROM retail_sales
WHERE category = "Clothing"
GROUP BY gender;

-- electronics
SELECT
	gender,
	ROUND(AVG(age)) AS umur
FROM retail_sales
WHERE category = "Electronics"
GROUP BY gender;

-- customer yang melakukan pembelian berulang (semua kategori) dalam sehari/seminggu/sebulan/setahun lengkap dengan tanggal nya
-- dalam sehari (pembelian > 2)
SELECT 
	customer_id, 
	sale_date AS hari 
FROM retail_sales 
GROUP BY customer_id, hari 
HAVING COUNT(*) > 2 
ORDER BY customer_id, hari ;

-- dalam seminggu (pembelian > 3)
SELECT
	customer_id,
	CONCAT("Minggu ke-",WEEK(sale_date), " Tahun ", YEAR(sale_date)) AS waktu
FROM retail_sales
GROUP BY customer_id, waktu
HAVING COUNT(*) > 3
ORDER BY customer_id;

-- dalam sebulan (pembelian > 7) 
SELECT
	customer_id,
	DATE_FORMAT(sale_date,"%Y-%m") AS waktu
FROM retail_sales
GROUP BY customer_id, waktu
HAVING COUNT(customer_id) > 7
ORDER BY customer_id, waktu;

-- dalam setahun (pembelian > 70)
SELECT
	customer_id,
	DATE_FORMAT(sale_date, "%Y") AS waktu
FROM retail_sales
GROUP BY customer_id, waktu
HAVING COUNT(customer_id) > 70
ORDER BY customer_id, waktu;


-- total pembelian seorang customer (contoh customer 20) untuk tiap kategori
SELECT 
	category,
	SUM(total_sale) AS total_pembelian
FROM retail_sales
WHERE customer_id = 20
GROUP BY category   

