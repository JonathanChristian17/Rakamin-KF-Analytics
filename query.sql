CREATE TABLE Kimia_Farma.kf_analisa_penjualan AS
SELECT 
    ft.transaction_id,
    ft.date AS tanggal_transaksi,
    ft.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    ft.customer_name,
    ft.product_id,
    pro.product_name,
    pro.price AS harga_asli,
    ft.discount_percentage,
    CASE 
        WHEN ft.price < 50000 THEN 0.2
        WHEN ft.price >= 50000 AND ft.price < 100000 THEN 0.25
        WHEN ft.price >= 100000 AND ft.price <= 300000 THEN 0.3
        WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.35
        WHEN ft.price > 500000 THEN 0.4
        ELSE 0
    END AS persentase_gross_laba,
    ft.price * (1 - ft.discount_percentage) AS penjualan_bersih,
    (
        SELECT 
            SUM(pro.price) - SUM(ft.price * (1 - ft.discount_percentage))
        FROM 
            Kimia_Farma.kf_final_transaction AS ft
            JOIN Kimia_Farma.kf_product AS pro ON ft.product_id = pro.product_id
    ) AS laba_bersih
FROM 
    Kimia_Farma.kf_final_transaction AS ft
    LEFT JOIN Kimia_Farma.kf_kantor_cabang AS kc ON ft.branch_id = kc.branch_id
    LEFT JOIN Kimia_Farma.kf_product AS pro ON ft.product_id = pro.product_id;