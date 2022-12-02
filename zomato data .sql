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

select distinct Restaurant_ID from #zomato1                          --- unique IDs 9551 
select distinct restaurant_name from #zomato1                        --- 7433 unique restaurant names

--- lets check how many outlets of the restaurants are associated with zomato
select Restaurant_Name, count(Restaurant_Name) as Total_Count
from #zomato1                                                        --- It looks like CCD,Dominos & Subway has more outlets on zomato
group by Restaurant_Name
order by Total_Count desc

select distinct Country_Code from #zomato1                            --- 15 contries 


--- Zomatos presence in how many contries & Total Restaurants 
select Country_Code, Country, count(Country_Code) as Total_Count,                      ---Zomato present in 15 countries
       round(count(country_code)*100.00/(select count(*)from #zomato1),2) as percentge
from #zomato1                                                                           ---Most of the restaurants are from 
group by Country_Code, Country                                                             -- India - 8652
order by Total_Count desc                                                                  -- US    - 434 


--- What type of the Cuisine are there
select distinct Cuisines                                                       --- There are over 1826 types of Cuisines available
from #zomato1

---Top 10 Cuisines are                                                         --- These are top 10 and are from India because most of the restaurants are from India
select Top 10 Cuisines
from #zomato1

--- Currencies accepted by zomato
select distinct currency from #zomato1b                                        ---- There are 12 currencies used on zomato

select Country, Currency                                                       ---- Singapore, Australia, US & Canada are using Dollar
from #zomato1                                                                        -- rest are using their own currency
group by country, Currency

--- How many Restaurants have online delivery services 
select Has_Online_delivery, count(Has_Online_delivery) as Total_count              --- Yes - 2451
from #zomato1                                                                      --- No - 7100
group by Has_Online_delivery


--- Which country has online delivery services
select Country, Has_Online_delivery , 
		COUNT(Has_Online_delivery) as Total_count
from #zomato1
group by Country, Has_Online_delivery
order by Country

--- Dristribution of the price range
select country, 
		Price_range, 
		MIN(Average_Cost_for_two) as Mini_avg_c_for_2, 
		max(Average_Cost_for_two) as Maxi_avg_c_for_2, 
		Currency
from #zomato1
group by Price_range, Country, Currency
order by Country , Price_range

--- Aggregate rating distribution
select round(Aggregate_rating,2) as rating, COUNT(Aggregate_rating) as Total_count       -- looks like most of the restaurant does not have ratings 
from #zomato1
group by Aggregate_rating 
order by rating


-- Zero rating restaurants
select Country, count(Aggregate_rating) as count_of_zero_rating                    --- most of the restaurants who has zero ratings are from india
from #zomato1
group by Country, Aggregate_rating
having Aggregate_rating = 0
order by count_of_zero_rating desc

--- Distribution of rating color, rating text
select Rating_color, 
		Rating_text,
		COUNT(Rating_text) as count_of_rating,
		round(min(Aggregate_rating),2) as min_rating,
		round(max(Aggregate_rating),2) as max_rating
from #zomato1
group by Rating_color, Rating_text
order by min_rating