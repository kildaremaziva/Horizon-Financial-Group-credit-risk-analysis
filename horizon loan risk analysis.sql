-- Horizon Finacial Group Credit Risk Analysis 
--Data Exploration 

select *
from [portfolio project 2]..borrower_profiles

select *
from [portfolio project 2]..loan_applications

-- Count check

select count(*) as total_borrowers 
from [portfolio project 2]..borrower_profiles 

select count(*) as total_loans
from [portfolio project 2]..loan_applications

select loan_status, count(*)as Default_count
from [portfolio project 2]..loan_applications
group by loan_status

-- join the table 


create view Loan_data 
as
select l.loan_id, l.borrower_id, l.application_date,l.loan_purpose,l.loan_amount,l.term_months,l.interest_rate,
l.monthly_payment,l.dti_ratio,l.loan_status,l.defaulted,
b.employment_status,b.years_employed,b.annual_income,b.credit_score,b.home_ownership,b.existing_monthly_debt
from [portfolio project 2]..loan_applications as l
join [portfolio project 2]..borrower_profiles as b
	on l.borrower_id = b.borrower_id
go


select *
from Loan_data
;
go

-- overall default rate 

select count(*) as total_loans, sum(defaulted) as defualts,
round(100.0 *sum(defaulted)/count(*),1) as default_rate_percentage 
from Loan_data
;
Go

-- create credit score buckets 

select
case
when credit_score < 600 then '520-599'
when credit_score < 650 then '600-649'
when credit_score < 700 then '650-699'
when credit_score < 750 then '700-749'
else '750+'
end as credit_score_bucket,
count(*) as total_loans, sum(defaulted) as defualts,
round(100.0 *sum(defaulted)/count(*),1) as default_rate_percentage 
from Loan_data
group by
case 
when credit_score < 600 then '520-599'
when credit_score < 650 then '600-649'
when credit_score < 700 then '650-699'
when credit_score < 750 then '700-749'
else '750+'
end
order by default_rate_percentage desc;

-- DTI buckets 

select 
case 
when dti_ratio < 20 then '1.under 20'
when dti_ratio < 30 then '2.20-29'
when dti_ratio < 40 then '3.30-39'
when dti_ratio < 50 then '4.40-49'
when dti_ratio < 60 then '5.50-59'
when dti_ratio < 70 then '6.60-69'
when dti_ratio < 80 then '7.70-79'
else '8.80+'
end as dti_bucket, 
count(*) as total_loans, sum(defaulted) as defualts,
round(100.0 *sum(defaulted)/count(*),1) as default_rate_percentage 
from Loan_data
group by
case 
when dti_ratio < 20 then '1.under 20'
when dti_ratio < 30 then '2.20-29'
when dti_ratio < 40 then '3.30-39'
when dti_ratio < 50 then '4.40-49'
when dti_ratio < 60 then '5.50-59'
when dti_ratio < 70 then '6.60-69'
when dti_ratio < 80 then '7.70-79'
else '8.80+'
end 
order by dti_bucket;

-- Employment_Status 

select employment_status,
count(*) as total_loans, sum(defaulted) as defualts,
round(100.0 *sum(defaulted)/count(*),1) as default_rate_percentage 
from Loan_data
group by employment_status
order by default_rate_percentage desc 
;

-- loan_purpose 

select loan_purpose,
count(*) as total_loans, sum(defaulted) as defualts,
round(100.0 *sum(defaulted)/count(*),1) as default_rate_percentage 
from Loan_data
group by loan_purpose
order by default_rate_percentage desc 


-- under 2 years vs 2 + years employed 
select 
case when years_employed < 2 then 'under 2 years' else ' 2+ years' end as tenure_group,
count(*) as total_loans, sum(defaulted) as defualts,
round(100.0 *sum(defaulted)/count(*),1) as default_rate_percentage 
from Loan_data
group by case when years_employed < 2 then 'under 2 years' else ' 2+ years' end ;

-- Average loan amount: defaulted vs non-defaulted 

select defaulted, count(*) as total_loans,
round(avg(loan_amount),0) as avg_loan_amount
from Loan_data
group by defaulted;

select *
from Loan_data
;































