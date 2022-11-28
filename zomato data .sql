use PortfolioDB

--- Inspecting the data tables of Zomato
select * from zomato
select * from countrycode

--- Join the two tables and save as temp table
select z.*,c.Country
into #zomato1
from zomato z left join
CountryCode c on 
z.Country_Code = c.Country_Code

select * from #zomato1    --- this temp table we are going to use now for analysis

select distinct Restaurant_ID from #zomato1              --- unique IDs 9551 
select distinct restaurant_name from #zomato1            --- 7433 unique restaurant names

--- lets check how many outlets of the restaurants are associated with zomato
select Restaurant_Name, count(Restaurant_Name) as Total_Count
from #zomato1                                            --- It looks like CCD,Dominos & Subway has more outlets on zomato
group by Restaurant_Name
order by Total_Count desc

select distinct Country_Code from #zomato1               --- 15 contries 


--- Zomatos presence in how many contries & Total Restaurants 
select Country_Code, Country, count(Country_Code) as Total_Count
from #zomato1
group by Country_Code, Country
order by Total_Count desc
