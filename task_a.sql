-- А) какую сумму в среднем в месяц тратит:
--    - пользователи в возрастном диапазоне от 18 до 25 лет включительно
--    - пользователи в возрастном диапазоне от 26 до 35 лет включительно

-- aggregate AVG per group
SELECT  age_group, 
		AVG(total_price) AS average_month_purchase
FROM
	-- aggregate by price SUM per 'month' and 'age_group'
	(SELECT  purchase_month,
			age_group,
        	SUM(price) AS total_price
	FROM 
		-- select purchases with months
		(SELECT *, DATE_TRUNC('month', purchase_date) as purchase_month
	 	FROM purchases) as purchases_wmth
	 	JOIN items 
     	ON items.itemid = purchases_wmth.itemid
	 
     	JOIN
		 -- select userr age groups
		(SELECT  userid, 
		  	 	cASE WHEN age < 26 THEN '[18 - 25]'
				 	  ELSE '[26 - 35]'
				END as age_group
	 	FROM users
	 	WHERE age < 36) AS user_groups 
     	ON user_groups.userid = purchases_wmth.userid
	 GROUP BY purchase_month, age_group) AS total_mth_gr
GROUP BY age_group;
