-- в каком месяце года выручка от пользователей в возрастном диапазоне 35+ самая большая

--create CTE for repeatative query
WITH total_per_month AS
	-- aggregate by price SUM per 'month', order by 'sum' desc and limit 1
   (SELECT  purchase_month,
     		EXTRACT(YEAR FROM purchase_month) AS purchase_year,
        	SUM(items.price) AS total_price_month
	FROM 
    	(SELECT *, DATE_TRUNC('month', purchase_date) as purchase_month
	 	FROM purchases) as purchases_wmth
	 	JOIN items 
     	ON items.itemid = purchases_wmth.itemid
	 
     	JOIN
	 	-- select users with age > 35
	   (SELECT userid
	 	FROM users
	 	WHERE age > 35 ) AS user_35g
     	ON user_35g.userid = purchases_wmth.userid
	GROUP BY purchase_month
    ORDER BY total_price_month DESC) 

-- select months with max total_price_month via JOIN max_total_price_year
SELECT total_per_month.purchase_year,
	   EXTRACT(MONTH FROM purchase_month) AS purchase_month,
       max_total_price_month
FROM total_per_month
JOIN
-- select max total_price per year via CTE
(SELECT purchase_year,
	   MAX(total_price_month) AS max_total_price_month
FROM total_per_month
GROUP BY purchase_year
ORDER BY purchase_year) AS max_total_price_year
ON max_total_price_year.purchase_year = total_per_month.purchase_year AND
   ABS(max_total_price_year.max_total_price_month - total_per_month.total_price_month) < 0.001