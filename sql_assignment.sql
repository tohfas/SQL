create table date_date
   (
    date DATE,
   year INT,
   Quarter varchar(20),
   Month varchar(20)
   );
   
create table city_region
   (
    city_id varchar(36),
   city varchar(20),
   state varchar(20)
   );
   
   create table student_student
   (
    student_id varchar(36),
    teacher_id varchar(36),
    student_name varchar(20),
    grade varchar(20),
    class_start_date DATE,
   city_id varchar(36)
  
);

 create table topic_topic
   (
    grade varchar(20),
    topic_id varchar(36),
    topic_name varchar(20)
  
);

 create table student_topic
   (
    student_id varchar(36),
    topic_id varchar(36),
    test_cleared BOOLEAN,
    percentage_mark BIGINT,
   test_date DATE
  
);

INSERT INTO 
	date_date(date, year, quarter, month)
VALUES
	('2019-08-01','2019','Two','August'),
	('2019-05-01','2019','Two','May'),
    ('2019-03-01','2019','One','March'),
    ('2019-06-01','2019','Two','June'),
    ('2019-09-01','2019','Three','September'),
    ('2019-12-01','2019','Four','December'),
    ('2019-02-01','2019','One','February'),
    ('2019-07-01','2019','Two','July'),
    ('2019-07-01','2019','Two','April'),
    ('2019-01-01','2019','One','January');
    
INSERT INTO 
	student_student(student_id, teacher_id, student_name, grade, class_start_date, city_id)
VALUES
	('t','l','Tarandeep','A','2019-01-01','t'),
	('m','p','Manisha','C','2019-01-01','b'),
    ('s','l','Sarthak','E','2019-01-01','t'),
    ('a','l','Atika','A','2019-01-01','t'),
    ('n','p','Naveen','A','2019-01-01','b'),
    ('ta','p','Taran','A','2019-01-01','t'),
    ('ma','l','Manish','E','2019-01-01','b'),
    ('sa','p','Sarthak','E','2019-01-01','t'),
    ('at','p','Atikata','A','2019-01-01','t'),
    ('na','l','Naveena','A','2019-01-01','b');


INSERT INTO 
	city_region(city_id, city, state)
VALUES
	('a','Agra','Uttar Pradesh'),
	('b','Bengaluru','Karnataka'),
    ('c','Coimbatore','Tamil Nadu'),
    ('c','Coimbatore','Tamil Nadu'),
    ('b','Bikaner','Rajasthan'),
    ('f','Faridabad','Haryana'),
    ('t','Thane', 'Maharashtra'),
    ('t','Thane', 'Maharashtra'),
    ('a','Agra','Uttar Pradesh'),
    ('a','Agra','Uttar Pradesh');
    
INSERT INTO 
	student_topic(student_id, topic_id,test_cleared, percentage_mark,test_date)
VALUES
	('t','Maths',1, '95','2019-08-01'),
	('m','Maths',1, '55','2019-05-01'),
    ('s','Science',0, '32','2019-03-01'),
    ('t','Science',1, '92','2019-06-01'),
    ('m','Science',0, '32','2019-09-01'),
    ('a','Science',1, '92','2019-12-01'),
    ('n','Maths',1, '93','2019-02-01'),
    ('a','Maths',1, '90','2019-07-01'),
    ('n','Science',1, '97','2019-04-01'),
    ('s','Maths',0, '30','2019-01-01');
    
INSERT INTO 
	topic_topic(grade, topic_id, topic_name)
VALUES
	('A','Ma','Maths'),
	('A','Sc','Science'),
    ('C','Ma','Maths'),
    ('E','Sc','Science'),
    ('C','Sc','Science'),
    ('E','Sc','Science');


/*1. List the top 5 cities in terms of number of students. Display the names of cities, states
and number of students in each city.*/
select cr.city, cr.city_id, cr.state, count(distinct(ss.student_id)) as number_of_students from city_region as cr left join student_student as ss on cr.city_id=ss.city_id group by city order by number_of_students desc limit 5;
/*
2. Show the distribution of students across grades. Display the grade and number of
students in each grade, % students in each grade.
*/
select grade, count(distinct(student_id)) as number_of_students from student_student group by grade;

/*
3. List our most successful quarter in terms of new students added in the year 2019.
Display all quarters, count and % students who started class in eachquarter.
*/
select quarter, count(quarter) as quarters, ((count(quarter)*100)/sum(quarter) ) as percentage from date_date group by quarter  ;

/*
4. How many topics are available in each grade? Display grade, number of topics in each
grade.
*/
select grade, count(topic_name) as topic_name from topic_topic group by grade  ;

/*
5. What percentage of students completed all topics in the grade? Display grade, number
of topics(incl topics that have never been completed), number of students who have
completed all the topics in the grade. A topic is completed when the ‘test cleared’ flag is
TRUE
*/
select tt.grade, tt.topic_id , st.test_cleared from topic_topic as tt left join student_topic as st on tt.topic_id=st.topic_id;

/*
6. Identify topics that have least scores. Display all topic names, mean, median, 25th and
75th percentile marks for each.
*/
select topic_id, percentage_mark from student_topic order by percentage_mark asc limit 1;

/*
Display all topic names, mean, median, 25th and
75th percentile marks for each.
*/
select topic_id, avg(percentage_mark) from student_topic group by topic_id ;
set @rowindex=-1;
select avg(stpm) from (select @rowindex:=@rowindex +1 as rowindex, student_topic.percentage_mark as stpm from student_topic order by student_topic.percentage_mark) as d where d.rowindex in (floor(@rowindex/2), ceil(@rowindex/2));


select percentile_cont(0.25) within group(order by percentage_mark) over () as percentile_cont_25 from student_topic;
select percentile_cont(0.75) within group(order by percentage_mark) over () as percentile_cont_25 from student_topic;