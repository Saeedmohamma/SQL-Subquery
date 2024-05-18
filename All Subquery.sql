
select * from sales
select * from collectors
select * from artist
select * from master.dbo. painting


-------------------- Scalar SUBQUERY--------------------
/*
Question 1. We’ll start with a simple example: We want to list paintings that are priced higher than the average. 
           Basically, we want to get painting names along with the listed prices, but only for the ones that cost more 
          than average. That means that we first need to find this average price; here’s where the scalar subquery comes into play:
		  */


select name, listed_price 
from master.dbo.painting 
where listed_price > (select avg(listed_price) from master.dbo.painting)




--------------------Multi Row subquery ----------------------
/*
Suppose we want to list all collectors who purchased paintings from our gallery. 
We can get the necessary output using a multirow subquery. Specifically, we can use an inner query to list 
all collectors’ IDs present in the sales table – these would be IDs corresponding to collectors 
who made at least one purchase with our gallery. Then, in the outer query, 
we request the first name and last name of all collectors whose ID is in the output of the inner query.
*/



select first_name, last_name from collectors
where id in (select distinct collector_id from sales)



------------------------Multirow subquery with multi colmuns------------------

/*
Let’s say that we want to see the total amount of sales for each artist who has sold at least one painting in our gallery. 
We may start with a subquery that draws on the sales table and calculates the total amount of sales for each artist ID. Then, 
in the outer query, we combine this information with the artists’ first names and last names to get the required output:
*/


select top 1 first_name, last_name, artist_sales.sum_sales
from artist

join (select artist_id, sum(sales_price) as sum_sales 
from sales
group by artist_id) as artist_sales
on artist_sales.artist_id = artist.id
order by sum_sales desc



------------------------Correlated Subquery-----------------

/*
The following example will demonstrate how subqueries:

Can be used in the SELECT clause, and
Can be correlated (i.e. the main or outer query relies on information obtained from the inner query).
For each collector, we want to calculate the number of paintings purchased through our gallery. To answer this question, 
we can use a subquery that counts the number of paintings purchased by each collector. Here’s the entire query:
*/



select first_name, 
       last_name,
(
select count(*) as painting_pur
from sales
where collectors.id = sales.collector_id
) as painting_count
from collectors



