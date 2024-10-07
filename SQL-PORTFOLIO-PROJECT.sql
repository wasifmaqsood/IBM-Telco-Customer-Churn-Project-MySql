ALTER TABLE telco_customer_churn_demographics RENAME TO telco_demographics;
ALTER TABLE telco_customer_churn_location RENAME TO telco_location;
ALTER TABLE telco_customer_churn_population RENAME TO telco_population;
ALTER TABLE telco_customer_churn_services RENAME TO telco_services;
ALTER TABLE telco_customer_churn_status RENAME TO telco_status;

select * from telco_demographics;
select * from telco_location;
select * from telco_population;
select * from telco_services;
select * from telco_status;

# Total Customer Count:
SELECT COUNT(DISTINCT `Customer ID`) AS Total_Customers
FROM Telco_demographics;


# Total Churned Customers:
SELECT COUNT(`Customer ID`) AS Total_Churned
FROM Telco_status
WHERE `Churn Label` = 'Yes';

# Query 1: Considering the top 5 groups with the highest average monthly charges among churned customers,
# how can personalized offers be tailored based on age, gender, and contract type to potentially improve customer retention rates?

SELECT d.Age, d.Gender, s.Contract, AVG(s.`Monthly Charge`) AS Avg_Monthly_Charge
FROM Telco_demographics AS d
JOIN Telco_services AS s 
ON d.`Customer ID` = s.`Customer ID`
JOIN Telco_status AS st 
ON d.`Customer ID` = st.`Customer ID`
WHERE st.`Churn Label` = 'Yes'
GROUP BY d.Age, d.Gender, s.Contract
ORDER BY Avg_Monthly_Charge DESC
LIMIT 5;


# Query 2: What are the feedback or complaints from churned customers?

SELECT st.`Churn Reason`, COUNT(st.`Customer ID`) AS Number_of_Churns
FROM Telco_status AS st
WHERE st.`Churn Label` = 'Yes'
GROUP BY st.`Churn Reason`
ORDER BY Number_of_Churns DESC;


# Query 3: How does the payment method influence churn behavior?

SELECT s.`Payment Method`, COUNT(st.`Customer ID`) AS Total_Customers,
    SUM(CASE WHEN st.`Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS `Churned Customers`,
    (SUM(CASE WHEN st.`Churn Label` = 'Yes' THEN 1 ELSE 0 END) / COUNT(st.`Customer ID`)) * 100 AS `Churn Rate`
FROM Telco_services AS s
JOIN Telco_status AS st ON s.`Customer ID` = st.`Customer ID`
GROUP BY s.`Payment Method`
ORDER BY `Churn Rate` DESC;

