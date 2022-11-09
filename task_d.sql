-- топ-3 товаров по выручке и их доля в общей выручке за любой год 

-- select top 3 via rank limitation
SELECT *
FROM 
-- create window function to make ranking by year_sum_percent
(SELECT itemid,
	   EXTRACT(YEAR FROM purchase_year) As purchase_year,
       total_item_sum_year,
       year_sum_percent,
       RANK() OVER (PARTITION BY purchase_year
                    ORDER BY year_sum_percent DESC) as rank_percent
FROM
    (SELECT total_item_sum.*, 
           total_item_sum.total_item_sum_year / total_sum.total_sum_year * 100 as year_sum_percent
    FROM
        -- select sum(price) per item per year
        (SELECT items.itemid, 
               date_trunc('year', purchase_date) AS purchase_year,
               SUM(price) total_item_sum_year
        FROM items
        JOIN purchases
        ON items.itemid = purchases.itemid
        GROUP BY items.itemid, purchase_year
        ORDER BY total_item_sum_year DESC) AS total_item_sum
    JOIN
        -- select total sum(price) per year
        (SELECT  date_trunc('year', purchase_date) AS purchase_year,
               SUM(price) total_sum_year
        FROM items
        JOIN purchases
        ON items.itemid = purchases.itemid
        GROUP BY purchase_year
        ORDER BY total_sum_year DESC) As total_sum
    ON total_item_sum.purchase_year = total_sum.purchase_year
    ORDER BY total_item_sum.purchase_year, total_item_sum.total_item_sum_year DESC) AS item_sum_stat) AS item_sum_stat_rank
WHERE rank_percent <= 3
  
