#1. Out of all the customers who were sent the offers, what % of them convert and open a term deposit ? (2)
#Ans - 11.27%
select success_flag,flag_count,(flag_count/cust_cnt) as pct
from 
(select success_flag,count(*) as flag_count
from great_lakes.term_deposit_campaign
group by success_flag) BASE
cross join (select count(*) as cust_cnt from great_lakes.term_deposit_campaign) cnt;
#----------------------------------------------------------------------------------------------------------------------------------
#2. If we look at the aggregated data, is there any influence of job/occupation on the telemarketing campaign and thereby successful conversion of customers who take up the term deposit? (3)
#Ans - Yes, there is influence of Job/Occupation on the outcome of the campaign. Here are the top 3 job categories where the highest number of conversion can be seen.
#Student - 31.4%
#Retired - 25.2%
#Unemployed - 14.2%
select SRC1.job,(SRC1.success_cnt/SRC2.tot_cnt) as success_pct
from
(select job,count(*) as success_cnt
from great_lakes.term_deposit_campaign 
where success_flag = 'yes'
group by job) SRC1
inner join 
(select job,count(*) as tot_cnt
from great_lakes.term_deposit_campaign 
group by job) SRC2
on SRC1.job = SRC2.job
order by (SRC1.success_cnt/SRC2.tot_cnt) desc
#----------------------------------------------------------------------------------------------------------------------------------
#3. In continuation of Q2, if we just look at the distribution of customers by the job categories who opened the term deposit, which job category has the highest %? (1)
#Ans - Admin with 29% 
select SRC1.job,(SRC1.success_cnt/SRC2.cust_cnt) as success_pct
from
(select job,count(*) as success_cnt
from great_lakes.term_deposit_campaign 
where success_flag = 'yes'
group by job) SRC1
cross join (select count(*) as cust_cnt from great_lakes.term_deposit_campaign where success_flag = 'yes') SRC2
order by success_pct desc
#----------------------------------------------------------------------------------------------------------------------------------
#4. What is the count of customers who took the term deposit also having a house loan but no personal loan? What % is it from the total customer base who opened a term deposit? (3)
#Ans - 2098, (2098/4640) = 45.2%
select count(*)
from great_lakes.term_deposit_campaign
where house_loan = 'yes' and pers_loan = 'no' and success_flag = 'yes';
select count(*)
from great_lakes.term_deposit_campaign
where success_flag = 'yes';
#----------------------------------------------------------------------------------------------------------------------------------
#5. What is the average duration of the last contact(in the campaign) by success flag? What do you infer from the same?(3)
#yes - 553 secs, no - 220 secs. 
#We can see that those who opened a term deposit had the last call duration much higher(more than double) than those who didn't take the product.
select success_flag,avg(last_contact_duration)
from great_lakes.term_deposit_campaign
group by success_flag;
#----------------------------------------------------------------------------------------------------------------------------------
#6. Does day of week, when the last call was made have any influence on success flag? What do you infer? (3)
#Ans - As can be seen from the data, all the days have more or less similar percentage of acceptance of the product. 
#Therefore we conclude that there is no significant impact of the last contact day on success flag.
select SRC1.last_contact_day, day_cnt, tot_day_cnt, (day_cnt/tot_day_cnt) as pct
from
(select last_contact_day,count(*) as day_cnt
from great_lakes.term_deposit_campaign
where success_flag = 'yes'
group by success_flag,last_contact_day) SRC1
inner join 
(select last_contact_day,count(*) as tot_day_cnt
from great_lakes.term_deposit_campaign
group by last_contact_day) SRC2
on SRC1.last_contact_day = SRC2.last_contact_day;
#----------------------------------------------------------------------------------------------------------------------------------
#7. If we create different age buckets as less than 20, 21-30, 31-40, 41-50, 51-60 and greater than 60, how does the conversion rate varies with age? How can we interprete the results and any recommendations? (5)
#Ans - As can be seen from the distribution below, the conversion percentage is highest for senior citizens (GT60) followed by less than 20 years. 
#However, these two together comprise only a handful of customers who were contacted. 
#Therefore we should try to see if we can reach out to more GT60 customers because they have a superior conversion rate.
#Also, for the 21-30 agre group, a 15% conversion rate could be seen which is better than the overall rate which is 11%. There should be a push to increase the target base as well for this age group.
select SRC1.age_grp, total_cnt, (success_cnt/total_cnt) as conversion_pct
from 
(select 
	case 
		when age <= 20 then 'LT20' 
        when age between 21 and 30 then '21-30' 
        when age between 31 and 40 then '31-40' 
        when age between 41 and 50 then '41-50' 
        when age between 51 and 60 then '51-60' 
        when age > 60 then 'GT60' 
	end as age_grp
	,count(*) as success_cnt
from great_lakes.term_deposit_campaign
where success_flag = 'yes'
group by case 
		when age <= 20 then 'LT20' 
        when age between 21 and 30 then '21-30' 
        when age between 31 and 40 then '31-40' 
        when age between 41 and 50 then '41-50' 
        when age between 51 and 60 then '51-60' 
        when age > 60 then 'GT60' 
	end) SRC1
inner join 
(select 
	case 
		when age <= 20 then 'LT20' 
        when age between 21 and 30 then '21-30' 
        when age between 31 and 40 then '31-40' 
        when age between 41 and 50 then '41-50' 
        when age between 51 and 60 then '51-60' 
        when age > 60 then 'GT60' 
	end as age_grp
	,count(*) as total_cnt
from great_lakes.term_deposit_campaign
group by case 
		when age <= 20 then 'LT20' 
        when age between 21 and 30 then '21-30' 
        when age between 31 and 40 then '31-40' 
        when age between 41 and 50 then '41-50' 
        when age between 51 and 60 then '51-60' 
        when age > 60 then 'GT60' 
	end) SRC2
on SRC1.age_grp = SRC2.age_grp;
order by conversion_pct desc;
#----------------------------------------------------------------------------------------------------------------------------------
#8. From a data profiling perspective, if we try to look at the customers who have a personal loan, which education category has the highest number of personal loans? (2)
#Ans - university.degree - 1930
select education,count(*) 
from great_lakes.term_deposit_campaign
where pers_loan = 'yes'
group by education
order by count(*) desc
limit 1;
#----------------------------------------------------------------------------------------------------------------------------------
#9. Group the data by prev_campaign_outcome and success_flag and take the count of customers. What do you see in the results? Provide an inference. (4) 
#Ans - Approx 65%(894 out of 1373) of the previous successful responders have also responded in the current campaign and opened a term deposit. 
#While the other two i.e. nonexistent and failures have relatively lower response rate, the focus is also to increase the overall customer base of responders, hence nonexistent has the highest number customers who were contacted in the campaign. 
select prev_campaign_outcome,success_flag,count(*) 
from great_lakes.term_deposit_campaign
group by prev_campaign_outcome,success_flag
order by count(*) desc;
#----------------------------------------------------------------------------------------------------------------------------------
#10. For those clients who were not previosuly contacted(i.e. not contacted before the current campaign), what is the average #of contacts made to the responders and non-responders? Briefly summmarize your observation. (3)
#Ans - If we filter only on those clients who were not contacted before the current campaign(filter on days_from_last_contact = 999) and 
#then take average on curr_campaign_ct, we can see that responders have typically lower average contact count(2.14) than non-responders(2.64).
select success_flag,avg(curr_campaign_ct) #, avg(prev_campaign_ct)
from great_lakes.term_deposit_campaign
where days_from_last_contact = 999
group by success_flag;
#----------------------------------------------------------------------------------------------------------------------------------
#11. Which contact type is more frequent and effective in order to drive a successful campaign? (3)
#Ans - Cellular contact type is more frequent. Also it has a much higher conversion rate (3853/26144) = ~14.73% than telephone (787/15044) = ~5.2%
select success_flag,contact_type,count(*)
from great_lakes.term_deposit_campaign
group by success_flag,contact_type
#----------------------------------------------------------------------------------------------------------------------------------
#12. Missing value imputation is a very important aspect to fix the data quality issues. In the dataset, the missing values are denoted as 'unknwon'. If we look at education column, how many missing values are there? 
#Which value should we pick to impute these records? Write a DML query to update the dataset and impute the missing values of education column. (5) 
#Ans - 
	#1. 1731 missing values are there. 
    #2. We should impute the missing values with university.degree as it has the highest number of occurances.
select education,count(*)
from great_lakes.term_deposit_campaign
group by education

update great_lakes.term_deposit_campaign 
set education = 'university.degree'
where education = 'unkown';
#----------------------------------------------------------------------------------------------------------------------------------
#13. How many customers have a high school degree but does a blue collar job? (1)
#Ans - 878
select count(*)
from great_lakes.term_deposit_campaign
where education = 'high.school' and job = 'blue-collar';
#----------------------------------------------------------------------------------------------------------------------------------
#14. Aggregate the data by job category and filter on success_flag = 'yes'. How many customers have opened a term deposit with average age greater than 40? How many management professionals are there in that? (3)
#Ans - 1029 Customers with average age greater than 40. 328 management professionals are there.
select job,count(*)
from great_lakes.term_deposit_campaign
where success_flag = 'yes'
group by job
having avg(age) > 40
#----------------------------------------------------------------------------------------------------------------------------------
#15. How many customers in the dataset has either a housing loan or a personal loan? What is the average age of such customers? (2)
#Ans - 24133 Customers with average age as 39.9 or ~40.
select count(*), avg(age)
from great_lakes.term_deposit_campaign
where house_loan = 'yes' OR pers_loan = 'yes'
#----------------------------------------------------------------------------------------------------------------------------------
#16. What are fundamental differences between a Data Definition Language(DDL) and Data Manipulation Language(DML)? (1)
#Ans - A DDL statement is used to create database/schema/tables etc while DML statements are used to insert/update or delete records.
#----------------------------------------------------------------------------------------------------------------------------------
#17. What is the functionality of UNION operator? (1)
#Ans - UNION is a set operator which is used to combine two or more datasets having same number of columns with identical data types.
#----------------------------------------------------------------------------------------------------------------------------------
#18. What is the difference between inner join and left outer join? (2)
#Ans - In inner join, the common records from both of the datasets are selected based on the joining columns. 
#In left outer join, all the records from the left table are selected while only the matching records are selected from the right table based on the joining columns.
#----------------------------------------------------------------------------------------------------------------------------------
#19. Mention one major difference between unique constraint and primary key? (1)
#Ans - The column having Unique constraint can have NULL values but the Primary Key column cannot have NULL value in it.
#----------------------------------------------------------------------------------------------------------------------------------
#20. Why do we need to do Normalization in RDBMS? 
#Ans - The main goal of data normalization in RDBMS is to reduce or eliminate data redundancy. It is an important aspect to remove the possibility of inconsistent data.
#----------------------------------------------------------------------------------------------------------------------------------



