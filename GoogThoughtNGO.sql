WITH total_donations AS(
	SELECT ds.assignment_id,
		   d.donor_type,
		   ROUND(SUM(ds.amount), 2) AS total_amount
	FROM donations AS ds
	JOIN donors AS d
	ON ds.donor_id = d.donor_id
	GROUP BY assignment_id, donor_type
)
SELECT a.assignment_name,
	   a.region,
	   td.total_amount AS rounded_total_donation_amount,
	   donor_type
FROM total_donations AS td
JOIN assignments AS a
ON td.assignment_id = a.assignment_id
ORDER BY rounded_total_donation_amount DESC
LIMIT 5;

WITH total_donations AS(
	SELECT assignment_id,
		   COUNT(donation_id) AS total_amount
	FROM donations
	GROUP BY assignment_id
),
assign_rank AS(
	SELECT a.assignment_name,
		   a.region,
		   a.impact_score,
		   td.total_amount,
		   ROW_NUMBER() OVER(PARTITION BY a.region ORDER BY a.impact_score DESC) AS ranking
	FROM assignments AS a
	JOIN total_donations as td ON a.assignment_id = td.assignment_id
	WHERE td.total_amount > 0
)
SELECT assignment_name,
	   region,
	   impact_score,
	   total_amount AS num_total_donations
FROM assign_rank
WHERE ranking = 1
ORDER BY region ASC;