create database Population;
select *
from world_population;

# changing the columns name 
alter table world_population
rename column `Country name` to country_name;
alter table world_population
rename column `Year` to population_year;
alter table world_population
rename column `Population` to population;
alter table world_population
rename column `Population of children under the age of 1` to population_children_under_1;
alter table world_population
rename column `Population aged 1 to 4 years` to population_1_to_4;
alter table world_population
rename column `Population aged 10 to 14 years` to population_10_to_14;
alter table world_population
rename column `Population of children under the age of 15` to population_children_under_15;
alter table world_population
rename column `Population at age 1` to population_age_1;
alter table world_population
rename column `Population under the age of 25` to population_under_25;
alter table world_population
rename column `Population aged 15 to 19 years` to population_15_to_19;
alter table world_population
rename column `Population aged 15 to 64 years` to population_15_to_64;
alter table world_population
rename column `Population aged 20 to 29 years` to population_20_to_29;
alter table world_population
rename column `Population aged 30 to 39 years` to population_30_to_39;
alter table world_population
rename column `Population aged 40 to 49 years` to population_40_to_49;
alter table world_population
rename column `Population aged 5 to 9 years` to population_5_to_9;
alter table world_population
rename column `Population aged 50 to 59 years` to population_50_to_59;
alter table world_population
rename column `Population aged 60 to 69 years` to population_60_to_69;
alter table world_population
rename column `Population older than 18 years` to population_older_18;
alter table world_population
rename column `Population older than 15 years` to population_older_15;
alter table world_population
rename column `Population older than 100 years` to population_older_100;
alter table world_population
rename column `Population of children under the age of 5` to population_children_under_5;
alter table world_population
rename column `Population aged 90 to 99 years` to population_90_to_99;
alter table world_population
rename column `Population aged 80 to 89 years` to population_80_to_89;
alter table world_population
rename column `Population aged 70 to 79 years` to population_70_to_79;

#writing query to get the total count of each country
select 
country_name,
count(*)
from world_population
group by country_name
order by country_name asc;

#getting the distinct country_name that contains (UN).
select distinct country_name
from world_population
where country_name like '%(UN)%';

#Adding a new column
Alter table world_population
add column record_type varchar(100);

#adding data into the new column created by using update function and 
#setting record_type to "continent" where country_name contains (UN)
update world_population
set record_type = 'Continent'
where country_name like '%(UN)%';

#Getting the distint country_name where record_type is null
select distinct country_name
from world_population
where record_type is null;

#adding data into the new column created by using update function and 
#setting record_type to "category" for some particular country_name using "IN"
update world_population
set record_type = "Category"
where country_name in (
'High-income countries',
'Land-locked developing countries (LLDC)',
'Least developed countries',
'Less developed regions',
'Less developed regions, excluding China',
'Less developed regions, excluding least developed countries',
'Low-income countries',
'Lower-middle-income countries',
'More developed regions',
'Small island developing states (SIDS)',
'Upper-middle-income countries',
'World'
);

#adding another data into the new column created by using update function and 
#setting record_type to "Country" where country_name is null.
update world_population
set record_type = 'Country'
where record_type is null;

#To get the distinct data in the record_type column
select distinct record_type from world_population;


#What is the population of people aged 90 and above for each country in the latest year?
select country_name, population_year, (population_90_to_99)+ (population_older_100) As Population_90_Above
from world_population
where population_year =2021
And record_type = 'Country'
order by country_name asc;

#Which countries have the highest population growth in the last year?
select country_name, max(population) as highest_pop, population_year
from world_population
where population_year = 2020 and
record_type = 'Country'
group by country_name
order by country_name;

#Which countries have the highest population growth in the last year?(using subqueries)
select p.country_name,
(
	select p1.population 
    from world_population p1
    where p1.country_name = p.country_name
    And p1.population_year = 2020
)As Population_2020,
(
	select p1.population 
    from world_population p1
    where p1.country_name = p.country_name
    And p1.population_year = 2021
) as Population_2021

from world_population p
where p.record_type = 'Country'
And p.population_year =2021;

#Or
select country_name,
population_2020,
population_2021,
population_2021 - population_2020 as pop_growth_num,
round((population_2021 - population_2020) / population_2020 *100, 2 )as pop_growth_pct
from
 (
	select 
	p.country_name,
	(
		select p1.population
		from world_population p1
		where p1.country_name = p.country_name
		And p1.population_year = 2020
	)As population_2020,
	(
		select p1.population
		from world_population p1
		where p1.country_name = p.country_name
		And p1.population_year = 2021
	) As population_2021
	from world_population p
	where p.record_type ='Country'
	And p.population_year =2021
) s
order by pop_growth_num desc;

# Which single country has the highest population decline in the last?
select 
country_name,
population_2020,
population_2021,
population_2021 - population_2020 as pop_growth_num,
round((population_2021 - population_2020)/ population_2020 * 100,2) as pop_growth_pct
from
(
select p.country_name,
	(
		select p1.population
		from world_population p1
		where p1.country_name = p.country_name
		And p1.population_year = 2020
	) as population_2020,

	(
		select p1.population
		from world_population p1
		where p1.country_name = p.country_name
		And p1.population_year = 2021
	) as population_2021

	from world_population p
	where p.record_type = 'Country'
	And p.population_year = 2021
)w
order by pop_growth_num ASc
limit 1;  

#What are the top 10 countries with the highest population growth in the last  10 years?

select
country_name,
population_2011,
population_2021,
population_2021 - population_2011 as pop_growth_num
from
(
select p.country_name,
	(
		select p1.population
        from world_population p1
        where p1.country_name = p.country_name
        And p1.population_year =2011
	) as population_2011,

	(
		select p1.population
        from world_population p1
        where p1.country_name = p.country_name
        And p1.population_year =2021
	) as population_2021
    
	from world_population p
	where p.record_type = 'Country'
	And p.population_year = 2021
)s
order by pop_growth_num desc
limit 10;

#Which country has the highest percentage growth since the first year recorded?

create view population_by_year as
select
country_name,
population_1950,
population_2011,
population_2021 
from
(
select p.country_name,
	(
		select p1.population
        from world_population p1
        where p1.country_name = p.country_name
        And p1.population_year = 1950
	) as population_1950,
	(
		select p1.population
        from world_population p1
        where p1.country_name = p.country_name
        And p1.population_year =2011
	) as population_2011,
    
    (
		select p1.population
        from world_population p1
        where p1.country_name = p.country_name
        And p1.population_year =2021
	) as population_2021
	from world_population p
	where p.record_type = 'Country'
	And p.population_year = 2021
)s;

select
country_name,
population_1950,
population_2021,
round((population_2021 - population_1950)/population_1950 *100,2) as pop_growth_pct
from population_by_year
order by pop_growth_pct desc;

#Which country has the highest population aged 1 as a percentage of their overall population?
select
country_name,
population,
population_age_1,
round((population_age_1)/population *100,2) as pop_ratio
from world_population
where record_type = 'Country' and
population_year = 2021
order by pop_ratio desc;

# what is the population of each continent in each year, and how much has it changed in each year?
select country_name,
population_year,
population,
lag(population, 1) over(
	partition by country_name
    order by population_year asc 
) as population_change
from world_population
where record_type = 'Continent'
order by country_name asc, population_year asc;

