#1. Write a query to calculate what % of the customers have made a claim in the
#current exposure period[i.e. in the given dataset]? (2)
#Hint: There are customers who have claimed more than once and they should be
#regarded only once in the % calculation.

#Ans: 5.02%
 SELECT count(*),(SELECT count(claim_flag) from   Auto_Insurance_risk WHERE claim_flag="1"),((SELECT count(claim_flag) from   Auto_Insurance_risk WHERE claim_flag="1")/Count(*))  as pct from   Auto_Insurance_risk
#OR
 SELECT count(*),(SELECT count(claim_flag) from   Auto_Insurance_risk WHERE claim_flag="1"),((SELECT count(claim_flag) from   (34060/678013)  as pct from   Auto_Insurance_risk


#Q2.1. Create a new column as 'claim_flag' in the table 'auto_insurance_risk' as
#integer datatype. (1.5)

#Ans:
#Adding a new column claim_flag to the table Auto_Insurance_risk
ALTER TABLE Auto_Insurance_risk ADD COLUMN claim_flag int(3);

#Q2.2. Set the value to 1 when ClaimNb is greater than 0 and set the value to 0
#otherwise. (1.5)

#Ans:
#Inserting values to the claim_flag with conditions
UPDATE Auto_Insurance_risk SET claim_flag="1" WHERE ClaimNb>"0"
UPDATE Auto_Insurance_risk SET claim_flag="0" WHERE ClaimNb<="0"


#Q3.1. What is the average exposure period for those who have claimed? (1)

#Ans:0.642495175948072
#Calculating Average Exposure for claimed IDs
SELECT AVG(Exposure) FROM Auto_Insurance_risk WHERE claim_flag="1"


#Q3.2. What do you infer from the result? (1)
#Hint: Use claim_flag variable to group the data.

#Ans:Protection of the covered claims will be provided if claimed within exposure period. Therefore we can infer that #on an average exposure period of 0.64, the insurance are claimed due to accidency or loss or risk of exposure.


#4.1. If we create an exposure bucket where buckets are like below, what is the %
#of total claims by these buckets? (2)

#Ans: Percentage: E1=19.67, E2=17.95, E3=16.53, E4=45.28
SELECT CASE 
WHEN exposure< 0 THEN 0 
WHEN exposure between 0 and 0.25 THEN 1 
WHEN exposure between 0.26 and 0.50 THEN  2  
WHEN exposure between 0.51 and 0.75 THEN 3 
WHEN exposure>0.75 THEN  (3 + 1) END 
from   Auto_Insurance_risk 

# Calculating total claims
SELECT sum(ClaimNb) FROM Auto_Insurance_risk  #36102
# Calculating total claims for E1
SELECT sum(ClaimNb) FROM Auto_Insurance_risk WHERE Exposure between 0 and 0.25  #7131
SELECT 7131/36102 as pct FROM Auto_Insurance_risk WHERE Exposure between 0 and 0.25 

# Calculating total claims
SELECT sum(ClaimNb) FROM Auto_Insurance_risk  #36102
# Calculating total claims for E2
SELECT sum(ClaimNb) FROM Auto_Insurance_risk WHERE Exposure between 0.26 and 0.5   #6481
SELECT 6481/36102 as pct FROM Auto_Insurance_risk WHERE Exposure between 0 and 0.25


# Calculating total claims
SELECT sum(ClaimNb) FROM Auto_Insurance_risk  #36102
# Calculating total claims for E3
SELECT sum(ClaimNb) FROM Auto_Insurance_risk WHERE Exposure between 0.51 and 0.75  #5968
SELECT 5968/36102 as pct FROM Auto_Insurance_risk WHERE Exposure between 0 and 0.25


# Calculating total claims
SELECT sum(ClaimNb) FROM Auto_Insurance_risk  #36102
# Calculating total claims for E4
SELECT count(ClaimNb) FROM Auto_Insurance_risk WHERE Exposure>0.76   #16347
SELECT 16347/36102 as pct FROM Auto_Insurance_risk WHERE Exposure between 0 and 0.25

#4.2. What do you infer from the summary? (1)
#Hint: Buckets are => E1 = 0 to 0.25, E2 = 0.26 to 0.5, E3 = 0.51 to 0.75, E4 > 0.75, You
#need to consider ClaimNb field to get the total claim count.

#Ans: It can be summarised that as percentage of claim rate for E1>E2>E3 but E4 has the highest claim rate percentage.

#5. Which area has the higest number of average claims? Show the data in percentage
#w.r.t. the number of policies in corresponding Area. (2)
#Hint: Use ClaimNb field for this question.

#Ans:area D
SELECT area ,AVG(ClaimNb) FROM Auto_Insurance_risk

#6. If we use these exposure bucket along with Area i.e. group Area and Exposure
#Buckets together and look at the claim rate, an interesting pattern could be seen in
#the data. What is that? (3)
#Note: 2 Marks for SQL and 1 for inference.

#Ans:                                      Claim Rate
Area    Exposure between 0 and 0.25  Exposure between 0.26 and 0.5  Exposure between 0.51 and 0.75  Exposure>0.76         
A	28028                        17983                          13732                           43881
B	21905                        13677                          10346                           29268
C	61111                        35464                          25806                           68885
D	52369                        30342                          20814                           47587
E	52751                        29649                          18789                           35596
F	6648                         4187                           3007                            4064

SELECT Area, count(ClaimNb) FROM Auto_Insurance_risk WHERE Exposure between 0 and 0.25 
GROUP BY Area;
SELECT Area, count(ClaimNb) FROM Auto_Insurance_risk WHERE Exposure between 0.26 and 0.5
GROUP BY Area 
SELECT Area, count(ClaimNb) FROM Auto_Insurance_risk WHERE Exposure between 0.51 and 0.75
GROUP BY Area;
SELECT Area, count(ClaimNb) FROM Auto_Insurance_risk WHERE Exposure>0.76
GROUP BY Area 

#we can see the pattern that for Exposure E1>E2>E3, after that claim rate is increasing for E4 for the areas


#Q7.1. If we look at average Vehicle Age for those who claimed vs those who didn't
#claim, what do you see in the summary? (1.5+1 = 2.5)

#Ans: When Claimed, Average vehicle age = 6.50252495596007
      When not Claimed, Average vehicle age = 7.07291836516019
#We can infer that the Average vehicle age when claimed is less than the average vehicle age when not claimed.


#Calulating Average vehicle age when claimed and not claimed
SELECT AVG(VehAge) FROM Auto_Insurance_risk WHERE claim_flag="1"
SELECT AVG(VehAge) FROM Auto_Insurance_risk WHERE claim_flag="0"


#Q7.2. Now if we calculate the average Vehicle Age for those who claimed and group
#them by Area, what do you see in the summary? Any particular pattern you see in the
#data? (1.5+1=2.5)

#Ans: Area   AVG(VehAge)
         A	7.43407162078245
         B	6.97988980716253
         C	6.44025224454895
         D	6.49011657374557
         E	6.09772478070175
         F	4.03886255924171
#Yes, from the data we can infer that the average vehicle age for Area A greatest followed by Area B then Area D, Then Area #C( which is almost equal to Area D) , then Area E, then Area F. We can infer from the above data that Area A may be the #least busy and chances of risk is less there followed by by Area B then Area D, Then Area C, then Area E, then Area F.

SELECT area,AVG(VehAge) FROM Auto_Insurance_risk WHERE claim_flag="1" GROUP BY Area

#8. If we calculate the average vehicle age by exposure bucket(as mentioned above),
#we see an interesting trend between those who claimed vs those who didn't. What is
#that? (3)

#Ans:
E1_CLaimed_AVG_VehAGe     E2_CLaimed_AVG_VehAGe     E3_CLaimed_AVG_VehAGe      E4_CLaimed_AVG_VehAGe
4.89699570815451          6.22187448525778          6.18439842913245           7.41882109617373

E1_NOT_CLaimed_AVG_VehAGe E2_NOT_CLaimed_AVG_VehAGe E3_NOT_CLaimed_AVG_VehAGe  E4_NOT_CLaimed_AVG_VehAGe
6.36713799726921          6.72025297250681          6.27048520001841           8.31651146584101

#Calculating average vehicle age when claimed
SELECT AVG(VehAge) as E1_CLaimed_AVG_VehAGe FROM Auto_Insurance_risk WHERE Exposure between 0 and 0.25 and Claim_Flag="1"
SELECT AVG(VehAge) as E2_CLaimed_AVG_VehAGe FROM Auto_Insurance_risk WHERE Exposure between 0.26 and 0.5 and Claim_Flag="1"
SELECT AVG(VehAge) as E3_CLaimed_AVG_VehAGe FROM Auto_Insurance_risk WHERE Exposure between 0.51 and 0.75 and Claim_Flag="1"
SELECT AVG(VehAge) as E4_CLaimed_AVG_VehAGe FROM Auto_Insurance_risk WHERE Exposure>0.76 and Claim_Flag="1"

#Calculating average vehicle age when not claimed
SELECT AVG(VehAge) as E1_NOT_CLaimed_AVG_VehAGe FROM Auto_Insurance_risk WHERE Exposure between 0 and 0.25 and Claim_Flag="0"
SELECT AVG(VehAge) as E2_NOT_CLaimed_AVG_VehAGe FROM Auto_Insurance_risk WHERE Exposure between 0.26 and 0.5 and Claim_Flag="0"
SELECT AVG(VehAge) as E3_NOT_CLaimed_AVG_VehAGe FROM Auto_Insurance_risk WHERE Exposure between 0.51 and 0.75 and Claim_Flag="0"
SELECT AVG(VehAge) as E4_NOT_CLaimed_AVG_VehAGe FROM Auto_Insurance_risk WHERE Exposure>0.76 and Claim_Flag="0"

#It can be seen that the Average Vehicle Age for claimed is less than the Average Vehicle Age for not claimed ones for every exposure periods.


#Q9.1) Create a Claim_Ct flag on the ClaimNb field as below, and take average of the
#BonusMalus by Claim_Ct. (2)

#Ans:
claim_Ct        AVG(BonusMalus)
1 Claim	        62.8371558207471
MT 1 Claims	67.5531349628055
No Claims	59.5850411443071


#Creating a new flag claim_Ct
ALTER TABLE Auto_Insurance_risk ADD COLUMN claim_Ct varchar(40);
#Setting values to the claim_Ct as per conditions
UPDATE Auto_Insurance_risk SET claim_Ct="1 Claim" WHERE ClaimNb ="1"
UPDATE Auto_Insurance_risk SET claim_Ct="MT 1 Claims" WHERE ClaimNb>"1"
UPDATE Auto_Insurance_risk SET claim_Ct="No Claims" WHERE ClaimNb="0"
#Calculating the AVG(BonusMalus) by claim_Ct
SELECT claim_Ct,AVG(BonusMalus) FROM Auto_Insurance_risk GROUP BY claim_Ct


#Q9.2)What is the inference from the summary? (1)

#Ans: We can infer that the average BonusMalus is less for those without any claims, higher for those with 1 claim  and #highest for those whose made claims more than once. 

#Q10) Using the same Claim_Ct logic created above, if we aggregate the Density column
#(take average) by Claim_Ct, what inference can we make from the summary data?(4)
#Note: 2.5 Marks for SQL and 1.5 for inference.

#Ans:
claim_Ct        AVG(Density)
1 Claim	        1947.32404127043
MT 1 Claims	2297.45483528162
No Claims	1783.20605541088

#Calculating aggregate of Density by claim_Ct and Inference
SELECT claim_Ct,AVG(Density) FROM Auto_Insurance_risk GROUP BY claim_Ct

# From the above data, we can infer that as the density increases, claim rate increases as the are becomes more busy, maybe #with more traffic and with higher chances of risk.
#The claims more than one is having the highest density followed by 1 claim and least deny for no claims.


#Q11) Which Vehicle Brand & Vehicle Gas combination have the highest number of
#Average Claims (use ClaimNb field for aggregation)? (2)

#Ans:  VehBrand   VehGas    Claims 

           B1	      Regular	16

SELECT VehBrand, VehGas ,MAX(ClaimNb) FROM Auto_Insurance_risk

#12. List the Top 5 Regions & Exposure[use the buckets created above] Combination
#from Claim Rate's perspective. Use claim_flag to calculate the claim rate. (3)

#Ans: Top 5 Regions: D, B, C, E, F

SELECT Area,
CASE WHEN exposure< 0 THEN 0 WHEN exposure between 0 and 0.25 THEN 1 WHEN exposure between 0.26 and 0.50 THEN  2  WHEN exposure between 0.51 and 0.75 THEN 3 WHEN exposure>0.75 THEN  (3 + 1) END 
from   Auto_Insurance_risk 
ORDER BY Area

SELECT Area, MAX(ClaimNb) from   Auto_Insurance_risk 
# Remove this minimum area from maximum.
SELECT Area, MIN(ClaimNb) from   Auto_Insurance_risk 


#Q 13.1) Are there any cases of illegal driving i.e. underaged folks driving and
#committing accidents? (1)

#Ans: No
SELECT IDpol FROM Auto_Insurance_risk WHERE DrivAge<"18" and ClaimNb>="1"

--OR METHOD2
SELECT Count(IDpol) FROM Auto_Insurance_risk WHERE DrivAge<"18" and ClaimNb>="1"


#Q13.2)Create a bucket on DrivAge and then take average of BonusMalus by this Age
#Group Category. WHat do you infer from the summary? (2.5+1.5 = 4)
#Note: DrivAge=18 then 1-Beginner, DrivAge<=30 then 2-Junior, DrivAge<=45 then 3-
#Middle Age, DrivAge<=60 then 4-Mid-Senior, DrivAge>60 then 5-Senior

#Ans: Average BonusMalus according to drivAge is a s follows.
DrivAge=18          DrivAge<=30         DrivAge<=45         DrivAge<=60         DrivAge>60
93.0093582887701    79.5302567734403    65.2725943698909    61.0113485912124    52.8022145154416

# Creating buckets for DrivAge
SELECT 
CASE WHEN DrivAge=18 THEN 1 WHEN DrivAge<=30 THEN 2 WHEN DrivAge<=45 THEN  3  WHEN DrivAge<=60 THEN 4 WHEN DrivAge>60 THEN  (4 + 1) END 
from   Auto_Insurance_risk 
ORDER BY Area
#Getting Average BonusMalus according to drivAge
SELECT AVG(BonusMalus) from   Auto_Insurance_risk WHERE DrivAge=18
SELECT AVG(BonusMalus) from   Auto_Insurance_risk WHERE DrivAge<=30
SELECT AVG(BonusMalus) from   Auto_Insurance_risk WHERE DrivAge<=45
SELECT AVG(BonusMalus) from   Auto_Insurance_risk WHERE DrivAge<=60
SELECT AVG(BonusMalus) from   Auto_Insurance_risk WHERE DrivAge>60

#Summary
#We can infer that as the age is increasing, the BonuMalus is decreasing. That means with increasing age, risk factor is decreasing as if the DriAge=18, they have more chances of risk than increasing age.


#Conceptual

#14. Mention one major difference between unique constraint and primary key? (2)

#Ans:The major difference between unique constraint and primary key are as follows:
#The column with Unique constraint can have NULL values whereas the column havng Primary key cannot contain NULL value #inside it.

#15. If there are 5 records in table A and 10 records in table B and we cross-join these
#two tables, how many records will be there in the result set? (2)

#Ans: 10 records will be in the result set (cartesian product of no. of records in Table A and Table B)
# Lets suppose we have Table A containing values Biryani, Kabab, Pasta, Pizza, Desserts  and Table B 1,2,3,4,5
#Result set will have values Biryani-1, Kabab-1, Pasta-1, Pizza-1, Desserts-1; Biryani-2, Kabab-2, Pasta-2, Pizza-2, #Desserts-2, Biryani-3, Kabab-3, Pasta-3, Pizza-3, Desserts-3; Biryani-4, Kabab-4, Pasta-4, Pizza-4, Desserts-4; Biryani-5, #Kabab-5, Pasta-5, Pizza-5, Desserts-5. 

#16. What is the difference between inner join and left outer join? (2)

#Ans:In inner join, the common records from both of the datasets are selected based on the joining columns. 
#In left outer join, it returns all the values from the left table and also the matched records from the right table #or NULL in case of no matching join predicate based on the joining columns.

#17. Consider a scenario where Table A has 5 records and Table B has 5 records. Now
#while inner joining Table A and Table B, there is one duplicate on the joining column in
#Table B (i.e. Table A has 5 unique records, but Table B has 4 unique values and one
#redundant value). What will be record count of the output? (2)

#Ans: The inner join will also consider the duplicate value(redundant value) of the Table B in the output record and give #the output considering match in both tables. If all 5 are match in both tables, then record count will be 5. If 4 are #match in both tables, then record count will be 5( as it consider duplicate value also. If 3 are match in both tables, #record count can be 3(if the match values inclues the duplicate value) or 4(if the match values inclues the duplicate #value) like this for others.

#18. What is the difference between WHERE clause and HAVING clause? (2)

#Ans: The difference between WHERE clause and HAVING Clause are as follows:
#1. WHERE Clause cannot be used before aggregates whereas HAVING Clause can.
#2. WHERE Clause filters rows before the calculation of aggregates are performed whereas HAVING Clause filters rows after #the aggregate calculations are performed.