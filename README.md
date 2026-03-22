# Loan Portfolio Analysis with Behavioral Risk Segmentation

SQL-based analysis of a fintech loan portfolio focused on repayment behavior, credit risk, and borrower segmentation.

---

## Project Overview

This project analyzes a lending dataset to understand portfolio performance, default behavior, and repayment patterns.  

The goal is to identify risky borrower segments and provide actionable recommendations for the risk team.

---

## Business Questions

- What is the overall health of the loan portfolio?
- Which segments appear to be riskier?
- How does borrower behavior relate to default risk?
- How long does it take borrowers to make their first payment?

---

## Dataset

The analysis uses three main tables:

- `users`
- `loans`
- `transactions`

---

## Key Analyses

- Loan status distribution
- Default rate by age
- Default rate by acquisition channel
- Default rate by country
- Time between disbursement and first payment
- Repeat borrowers and default behavior
- Average loan amount by status

---

## Advanced Segmentation (Segmentation 2.0)

To improve risk understanding, a combined segmentation approach was implemented using:

- Age ranges  
- Days to first payment  
- Acquisition channel  

This allowed identifying risk patterns that are not visible when analyzing each variable independently.

---

## Key Insights

- Most loans are in **paid** status, indicating overall healthy portfolio performance.

- Default rates are relatively consistent across demographic and acquisition segments when analyzed independently.

- Behavioral patterns, especially **delayed first payment**, are significantly more predictive of default risk than demographic variables.

- Users who delay their first payment (**30+ days**) show a clear increase in default probability.

- Segmentation 2.0 revealed that combining behavioral signals with acquisition channels amplifies risk detection.

- Loan amount does not vary significantly across statuses, suggesting that repayment behavior is a stronger risk driver than loan size.

---

## Business Recommendations

- Prioritize behavioral indicators such as **time to first payment** as early risk signals.

- Implement early warning systems for users who delay their first payment beyond **7–30 days**.

- Monitor acquisition channels with higher default rates and refine targeting strategies.

- Incorporate behavioral variables into credit scoring models.

- Use combined segmentation (behavior + acquisition + demographics) to improve risk profiling.

- Move from static segmentation to **behavior-driven risk assessment**.

---

## Business Impact

This analysis demonstrates that behavioral data provides stronger predictive power than traditional demographic segmentation.

By focusing on early repayment behavior, the risk team can:

- Detect high-risk users earlier in the loan lifecycle  
- Reduce default rates through proactive interventions  
- Improve credit decisioning models  
- Optimize acquisition strategies based on user quality  

---

## Visualizations

### Loan Status Distribution
![Loan Status Distribution](images/loan_status_distribution.png)

### Default Rate by Age
![Default Rate by Age](images/default_rate_by_age.png)

### Default Rate by Acquisition Channel
![Default Rate by Acquisition Channel](images/default_rate_by_channel.png)

### Default Rate by Country
![Default Rate by Country](images/default_rate_by_country.png)

### Days to First Payment
![Days to First Payment](images/days_to_first_payment_distribution.png)

---

## SQL Techniques Used

- CTEs  
- CASE statements  
- Conditional aggregation  
- Window functions  
- Joins  
- DATEDIFF  
- GROUP BY / HAVING  

---

## Repository Structure

```text
loan-portfolio-analysis
│
├── notebook
│   └── loan_portfolio_analysis.html
│
├── queries
│   └── analysis_queries.sql
│
├── images
│   ├── default_rate_by_age.png
│   ├── default_rate_by_channel.png
│   ├── default_rate_by_country.png
│   ├── loan_status_distribution.png
│   └── days_to_first_payment_distribution.png
│
└── README.md
