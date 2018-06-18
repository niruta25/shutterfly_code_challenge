-- LTV calculation
SELECT b.customer_id, AVG(a.site_visit_per_week * b.expense_per_cust/a.total_visit) as LTV
FROM
	(SELECT customer_id, AVG(visits) as site_visit_per_week, sum(visits) as total_visit -- get customer avg visit per week and total visits
		FROM(
			SELECT  customer_id, 
					COUNT(*) AS visits,
					DATEDIFF(week, (SELECT MIN(event_time) FROM [dbo].[site_visit]) , (SELECT MAX(event_time) FROM [dbo].[site_visit])) AS WeekNumber
			FROM [dbo].[site_visit]
			GROUP BY customer_id
			) tbl1
	GROUP BY customer_id
	) a
JOIN
	(SELECT customer_id, 
			SUM(total_amount) as expense_per_cust
	FROM [dbo].[order_tbl]
	GROUP BY customer_id
	) b
ON a.customer_id = b.customer_id
GROUP BY b.customer_id

