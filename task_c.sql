 -- какой товар обеспечивает дает наибольший вклад в выручку за последний год

-- select sum pupurchases from last yaer with SUM(price) desc limit 1
SELECT items.itemid,
       SUM(price) as total_price_last_year
FROM items
JOIN 
(SELECT itemid
 FROM purchases
 WHERE purchase_date >=
    -- select max from date_trunc('year', purchase_date) 
    (SELECT max(date_trunc('year', purchase_date)) as current_year
     FROM purchases) ) AS last_year_items
ON last_year_items.itemid = items.itemid
GROUP BY items.itemid
ORDER BY total_price_last_year DESC
LIMIT 1
