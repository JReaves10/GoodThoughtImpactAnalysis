GoodThought NGO Data Analysis

GoodThought NGO has been a catalyst for positive change, focusing its efforts on education, healthcare, and sustainable development to make a significant difference in communities worldwide. This project explores donation and impact data to derive meaningful insights, allowing for better resource allocation and strategy planning.

Objectives

Identify the top five assignments based on total value of donations, categorized by donor type.

Determine the highest-impact assignment in each region that has received at least one donation.

Dataset Description

The GoodThought database consists of three main tables:

Assignments:

assignment_id: Unique identifier for each assignment.

assignment_name: Name of the assignment.

region: Geographical region of the assignment.

impact_score: The measured impact of the assignment.

Donations:

donation_id: Unique identifier for each donation.

assignment_id: The assignment to which the donation was made.

amount: The amount donated.

donor_id: The donor who contributed.

Donors:

donor_id: Unique identifier for each donor.

donor_type: The type of donor (individual, corporate, government, etc.).

Code Explanation

Step 1: Identifying the Top 5 Assignments by Total Donations

To determine the five assignments with the highest total donation values, categorized by donor type, we use the following query:

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

Output:

A table listing the top five assignments, their regions, total donation amounts (rounded), and donor types.

Example:

Assignment Name

Region

Total Donation Amount

Donor Type

School Build A

Africa

1,500,000.00

Corporate

Step 2: Identifying the Highest Impact Assignment per Region

To find the assignment with the highest impact score in each region (ensuring each has received at least one donation), we use:

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

Output:

A table listing the highest-impact assignment in each region that has received at least one donation.

Example:

Assignment Name

Region

Impact Score

Total Donations

Hospital Aid B

Asia

92

5,000

Results

The analysis provided key insights into donation distribution and impact:

Top Donations: The highest-funded assignments received significant contributions, mainly from corporate donors, indicating strong corporate engagement in NGO initiatives.

Regional Impact: The highest-impact assignments varied across regions, with education and healthcare-related projects dominating in terms of both donations and impact.

Donor Preferences: Corporate donors tend to fund large-scale projects, whereas individual donors contribute more to localized efforts.

Conclusion

This project provided a data-driven perspective on GoodThought NGO’s assignments, helping to understand where funding is concentrated and which assignments have the greatest impact. These insights can assist in improving fundraising strategies and optimizing resource allocation for future projects.

Technology Used

Database Query Language: SQL

Concepts: Joins, Aggregation, Window Functions, Ranking

Visualization: Tabular representations for clear interpretation
