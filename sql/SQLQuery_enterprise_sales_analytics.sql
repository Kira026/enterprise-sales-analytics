SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM fact_sales;


SELECT
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM fact_sales;


SELECT
    d.year,
    d.month,
    SUM(f.sales) AS monthly_revenue
FROM fact_sales f
JOIN dim_dates d
    ON f.order_date = d.date
GROUP BY d.year, d.month
ORDER BY d.year, d.month;


WITH monthly_sales AS (
    SELECT
        d.year,
        d.month,
        SUM(f.sales) AS revenue
    FROM fact_sales f
    JOIN dim_dates d
        ON f.order_date = d.date
    GROUP BY d.year, d.month
)
SELECT
    year,
    month,
    revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year, month))
        / LAG(revenue) OVER (ORDER BY year, month) * 100,
        2
    ) AS mom_growth_pct
FROM monthly_sales;

SELECT
    market,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM fact_sales
GROUP BY market
ORDER BY revenue DESC;

SELECT
    region,
    SUM(sales) AS revenue
FROM fact_sales
GROUP BY region
ORDER BY revenue DESC;

SELECT
    p.category,
    SUM(f.sales) AS revenue,
    SUM(f.profit) AS profit
FROM fact_sales f
JOIN dim_products p
    ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

SELECT TOP 10
    p.product_name,
    SUM(f.sales) AS revenue
FROM fact_sales f
JOIN dim_products p
    ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

SELECT
    p.product_name,
    SUM(f.profit) AS total_loss
FROM fact_sales f
JOIN dim_products p
    ON f.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(f.profit) < 0
ORDER BY total_loss;

SELECT
    discount,
    ROUND(AVG(profit), 2) AS avg_profit
FROM fact_sales
GROUP BY discount
ORDER BY discount;

SELECT
    c.segment,
    SUM(f.sales) AS revenue,
    SUM(f.profit) AS profit
FROM fact_sales f
JOIN dim_customers c
    ON f.customer_id = c.customer_id
GROUP BY c.segment;

SELECT TOP 10
    c.customer_name,
    SUM(f.sales) AS total_revenue
FROM fact_sales f
JOIN dim_customers c
    ON f.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_revenue DESC;

SELECT
    ship_mode,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days,
    ROUND(AVG(profit), 2) AS avg_profit
FROM fact_sales
GROUP BY ship_mode;
