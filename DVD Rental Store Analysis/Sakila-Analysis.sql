-- Data Analysis with SQL for the Sakila Database

-- Q1. Countries where the services are provided
select
	distinct country
from
	country;
-- Ans: The DVD rental service is provided in 109 countries
	
-- Q2. Countries having the highest cities.
select
	ctry.country,
	count(cty.city) as number_of_cities
from
	country ctry
join city cty on ctry.country_id = cty.country_id
group by
	ctry.country
order by
	number_of_cities desc 
limit 10;
-- Ans: India is the country where the rental service is provided and has the highest number of cities i.e., 60

-- Q3. Countries with having the highest customers.
select
	ctr.country,
	count(c.customer_id) as number_of_customers
from country ctr
join city ct on ctr.country_id = ct.country_id
join address adr on ct.city_id = adr.city_id 
join customer c on c.address_id = adr.address_id 
group by ctr.country
order by number_of_customers desc;
-- Ans: India is the country that has the highest number of customers

-- Q4. Cities having the highest number of customers.
select
	ct.city,
	count(c.customer_id) as no_of_customers
from city ct
join address adr on ct.city_id = adr.city_id
join customer c on c.address_id = adr.address_id
group by ct.city
order by no_of_customers desc;
-- Ans: Aurora is the city that has the highest number of customers

-- Q5. Countries having the highest rental.
select
	ctr.country,
	count(r.rental_id) as no_of_rentals
from country ctr
join city ct on ctr.country_id = ct.country_id 
join address adr on ct.city_id = adr.city_id
join customer c on c.address_id = adr.address_id
join rental r on r.customer_id = c.customer_id
group by 1
order by 2 desc;
-- Ans: India has the highest number of rentals 1572

-- Q6. Country generating the highest revenue.
select
	ctr.country,
	round(sum(p.amount),2) as revenue,
	sum(round(sum(p.amount),2)) over (order by round(sum(p.amount),2) desc, ctr.country) as running_total
from country ctr
join city ct on ctr.country_id = ct.country_id 
join address adr on ct.city_id = adr.city_id
join customer c on c.address_id = adr.address_id
join payment p on p.customer_id  = c.customer_id  
group by 1
order by 2 desc;
-- Ans: The highest received payment is from India with 6630.27 and total revenue is 67,416.51

-- Q7. Cities having the highest rental.
select
	ct.city,
	count(r.rental_id) as no_of_rental,
	sum(count(r.rental_id)) over (order by count(r.rental_id) desc, ct.city) running_total_rentals
from city ct
join address a on ct.city_id = a.city_id 
join customer c on c.address_id = a.address_id 
join rental r on c.customer_id = r.customer_id 
group by 1
order by 2 desc;
-- Ans: Aurora is the city in the USA has the highest amount of rentals, 50

-- Q8. Cities having the highest revenue.
select
	ct.city,
	sum(p.amount) as revenue,
	sum(sum(p.amount)) over (order by sum(p.amount) desc, ct.city) as running_total_revenue
from city ct
join address a on ct.city_id = a.city_id 
join customer c on a.address_id = c.address_id 
join payment p on c.customer_id = p.customer_id 
group by 1
order by 2 desc;
-- Ans: Highest amount of payment has been received from Cape Coral with 221.55

-- Q9. Customers having the highest rental.
select
	c.customer_id,
	c.first_name,
	c.last_name,
	count(r.rental_id) as no_of_rentals
from customer c
join rental r on c.customer_id = r.customer_id 
group by 1,2,3
order by 4 desc;
-- Ans: ELEANOR HUNT has the highest number of rentals with 46

-- Q10. Customer who produced the highest revenue(entire with address)
select 
	c.customer_id ,
	concat(c.first_name , ' ', c.last_name) as full_name ,
	a.address ,
	sum(p.amount) as cust_revenue
from customer c
join payment p on c.customer_id = p.customer_id 
join address a on c.address_id = a.address_id 
group by 1,2,3
order by 4 desc;
-- Ans: KARL SEAL has the highest amount paid 221.55

-- Q11. Store has the highest rental.
select 
	s.store_id ,
	count(r.rental_id) as no_of_rentals
from store s
join inventory i on s.store_id = i.store_id 
join rental r on i.inventory_id = r.inventory_id 
group by 1
order by 2 desc;
-- Ans: 2nd store has rented out the highest number of DVDs

-- Q12. Staff offering the highest rental.
select 
	s.staff_id ,
	concat(s.first_name, " ", s.last_name) as staff_fullname,
	count(r.rental_id) as no_of_rentals
from staff s 
join rental r on s.staff_id = r.staff_id 
group by 1,2
order by 3 desc;
-- Ans: Mike Hillyer has rented out the highest number of DVDs

-- Q13. Store collecting the highest revenue.
select 
	s.store_id ,
	round(sum(p.amount),2) as total_revenue
from store s
join inventory i on s.store_id = i.store_id  
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id 
group by 1
order by 2 desc;
-- Ans: The 2nd store has collected the highest revenue for DVD rentals

-- Q14. Staff collecting the highest payment.
select 
	s.staff_id ,
	concat(s.first_name, ' ', s.last_name) as staff_fullname ,
	sum(p.amount) as total_revenue
from staff s
join payment p on s.staff_id = p.staff_id 
group by 1,2
order by 3 desc;
-- Ans: Jon Stephens has the highest received payment for DVD rent outs.

-- Q15. Actor with the highest number of movies.
select 
	concat(a.first_name, ' ', a.last_name) as actor_fullname ,
	count(fa.film_id) as no_of_movies
from actor a
join film_actor fa on a.actor_id = fa.actor_id 
group by 1
order by 2 desc;
-- Ans: Susan Davis has the highest number of movies

-- Q16. Movies with the highest rental.
select 
	f.title ,
	count(r.rental_id) as no_of_rentals
from film f 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
group by 1
order by 2 desc;
-- Ans: BUCKET BROTHERHOOD has the highest rentals, 34

-- Q17. Movies with the highest payment.
select 
	f.title ,
	round(sum(p.amount),2) as revenue
from film f
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id 
group by 1
order by 2 desc;
-- Ans: TELEGRAPH VOYAGE has produced the highest revenue, 231.73

-- Q18. Which actors movie is the highest grossing.
with highest_revenue as (
	select
		f.title ,
		round(sum(p.amount),2) as revenue
	from film f
	join inventory i on f.film_id = i.film_id
	join rental r on i.inventory_id = r.inventory_id
	join payment p on r.rental_id = p.rental_id
	group by 1
	order by 2 desc
	limit 1)
select
	title,
	group_concat(full_name order by full_name asc separator ', ') as list_actors
from
	(select
		f.title ,
		concat(a.first_name, ' ', a.last_name) as full_name 
	from actor a
	join film_actor fa on a.actor_id = fa.actor_id 
	join film f on fa.film_id = f.film_id 
	where
		f.title = (select title from highest_revenue)) as sub
group by 1;
-- Ans: CARMEN HUNT, GINA DEGENERES, LUCILLE DEE, MICHAEL BENING, THORA TEMPLE, VIVIEN BASINGER, WOODY HOFFMAN is the list of actors/actresses of the movie with highest revenue

-- Q19. Write a query to find the full names of customers who have rented sci-fi, comedy, action and drama movies highest times.
select
	c.customer_id ,
	concat(c.first_name, ' ', c.last_name) as cust_fullname,
	count(r.rental_id) as no_of_rentals
from category cat
join film_category fcat on cat.category_id = fcat.category_id 
join film f on fcat.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join customer c on r.customer_id = c.customer_id 
where
	cat.name in ('sci-fi', 'comedy', 'action', 'drama')
group by 1,2
order by 3 desc;
-- Ans: CURTIS IRBY is the customer who have rented sci-fi, comedy, action, and drama movies highest times.

-- Q20. Film Category by Language
select 
	f.title ,
	cat.name as cat_name ,
	l.name as language_name
from category cat
join film_category fcat on cat.category_id =fcat.category_id 
join film f on fcat.film_id = f.film_id 
join `language` l on f.language_id = l.language_id 
;

-- Q21. Rentals each month
#1
select 
	date_format(rental.rental_date, '%Y-%m') as yearMonth,
	count(rental_id) as no_of_rentals
from rental
group by 1
order by 2 desc;

#2
select 
	concat(extract(year from rental_date), '-', lpad(extract(month from rental_date), 2, 0)) as yearMonth,
	count(rental_id) as no_of_rental
from rental 
group by 1
order by 2 desc;
-- Ans: July 2005 has the largest number of rentals

-- Q22. Revenue per month
select 
	date_format(payment_date, '%Y-%m') as yearMonth,
	sum(amount) as revenue
from payment
group by 1
order by 2 desc;
-- Ans: July 2005 has the highest revenue with 28,373.89

-- Q23. Highest grossing year
select 
	date_format(payment.payment_date, '%Y') as year_payment ,
	sum(payment.amount) as revenue
from payment 
group by 1
order by 2 desc;
-- Ans: 2005 has the highest revenue with 66,902.33

-- Q24. Revenue between July, 2005 and January, 2006
select
	sum(amount) as revenue
from payment 
where payment_date between '2005-07-01' and '2006-01-31';
-- Ans: Revenue between July, 2005 and January, 2006 is 52,446.02

-- Q25. Distinct renters per month.
select 
	date_format(rental_date, '%Y-%m') as yearMonth ,
	count(distinct customer_id) as distinct_renters
from rental 
group by 1
order by 2 desc;
-- Ans: July and August has the highest distinct renters.

-- Q26. Rentals which encountered no gain.
select 
	r.rental_id ,
	r.customer_id ,
	p.amount as revenue
from rental r
join payment p on r.rental_id = p.rental_id 
where p.amount = 0;

-- Q27. Active and Inactive Customers.
select 
	active ,
	count(customer_id) as no_of_cust
from customer 
group by 1
order by 2 desc;
-- Ans: There are 584 active customers and 15 inactive customers.

-- Q28. Customers who bought DVDs instead of renting.
select 
	concat(c.first_name, ' ', c.last_name) as full_name
from rental r
join customer c on r.customer_id = c.customer_id 
where return_date is null;
-- Ans: There are 183 customers who bought DVDs instead of renting.

-- Q29. In which quater was the highest revenue reported.
#1
select
	case 
		when payment_date between concat(extract(year from payment_date),'-','01','-','01') and concat(extract(year from payment_date),'-','03','-','31') then 'Quarter 1'
		when payment_date between concat(extract(year from payment_date),'-','04','-','01') and concat(extract(year from payment_date),'-','06','-','30') then 'Quarter 2'
		when payment_date between concat(extract(year from payment_date),'-','07','-','01') and concat(extract(year from payment_date),'-','09','-','30') then 'Quarter 3'
		when payment_date between concat(extract(year from payment_date),'-','10','-','01') and concat(extract(year from payment_date),'-','12','-','31') then 'Quarter 4'
	end as quarter_year ,
	sum(amount) as revenue
from payment
group by 1
order by 2 desc;
#2
select 
	quarter(payment_date) as quarter_year,
	sum(amount) as revenue
from payment 
group by 1
order by 2 desc;
-- Ans: 3rd quarter reported the maximum revenue of 52,446.02

-- Q30. In which quater was the highest rentals reported
select 
	quarter(rental_date) as quarter_year ,
	count(rental_id) as no_of_rentals
from rental 
group by 1
order by 2 desc;
-- Ans: 3rd quarter has been reported to have highest rentals with 12,395 count

-- Q31. Which movie was rented more than 9 days.
select
	distinct title
from
	(select 
		f.film_id ,
		f.title ,
		r.rental_id ,
		r.rental_date ,
		r.return_date ,
		datediff(r.return_date, r.rental_date) as rented_days 
	from film f
	join inventory i on f.film_id = i.film_id 
	join rental r on i.inventory_id = r.inventory_id 
	where datediff(r.return_date, r.rental_date) > 9) as sub
-- Ans: There are 94 films were rented more than 9 days.

-- Q32. Which customer rented more than 9 days.
select 
	full_name,
	count(full_name) as no_of_morethan9days
from 
	(select 
		f.film_id ,
		f.title ,
		r.rental_id ,
		r.customer_id ,
		r.rental_date ,
		r.return_date ,
		datediff(r.return_date, r.rental_date) as rented_days,
		concat(c.first_name, ' ', c.last_name) as full_name
	from customer c
	join rental r on c.customer_id = r.customer_id 
	join inventory i on r.inventory_id = i.inventory_id 
	join film f on i.film_id = f.film_id 
	where datediff(r.return_date, r.rental_date) > 9) as sub
group by 1
order by 2 desc;
-- Ans: 99 customers have rented for more than 9 days and some of them have had 2 rentals for more than 9 days.

-- Q33. Which is the most popular genres.
select 
	cat.name as genrse ,
	count(r.rental_id) as no_of_rentals
from category cat 
join film_category fcat on cat.category_id = fcat.category_id 
join film f on fcat.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
group by 1
order by 2 desc;
-- Ans: Sports is the most popular genre with 1,179 rentals

-- Q34. Which is the highest grossing genre.
select 
	cat.name ,
	round(sum(p.amount),2) as revenue
from category cat
join film_category fcat on cat.category_id = fcat.category_id 
join film f on fcat.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id 
group by 1
order by 2 desc;
-- Ans: Sports is the highest grossing genre with 5,314.21

-- Q35.
/*
We want to understand more about the movies that families are watching.
The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.
Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.*/
select 
	f.film_id ,
	f.title ,
	cat.name as film_categories ,
	count(r.rental_id) as no_of_rentals
from category cat
join film_category fcat on cat.category_id = fcat.category_id 
join film f on fcat.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
where cat.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
group by 1,2,3
order by 4 desc;

-- Q36.
/*
 * Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for.
 * Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter)
 * based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories?
 * Make sure to also indicate the category that these family-friendly movies fall into.
 */
select 
	category_name ,
	standard_quartile ,
	count(title) as no_of_films
from 
	(select 
		f.film_id ,
		f.title ,
		cat.name as category_name,
		f.rental_duration ,
		ntile(4) over(order by f.rental_duration asc) as standard_quartile
	from category cat
	join film_category fcat on cat.category_id = fcat.category_id 
	join film f on fcat.film_id = f.film_id 
	where cat.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	order by 4 asc) as sub 
group by 1,2
order by 1,2;

-- Q37.
/*
 * We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for.
 * Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month.
 * Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.
 * The count of rental orders is sorted in descending order.
 */
with cte as
(select 
	date_format(r.rental_date, '%Y') as year_rental ,
	date_format(r.rental_date, '%m') as month_rental ,
	s.store_id ,
	count(r.rental_id) as no_of_rentals
from store s
join inventory i on s.store_id = i.store_id  
join rental r on i.inventory_id = r.inventory_id 
group by 1,2,3),

s1 as(
select * from cte where store_id = 1),

s2 as(
select * from cte where store_id = 2)

select 
	s1.year_rental ,
	s1.month_rental ,
	s1.store_id , 
	s1.no_of_rentals as no_of_rentals_s1 ,
	s2.store_id ,
	s2.no_of_rentals as no_of_rentals_s2
from s1
join s2 on s1.year_rental = s2.year_rental and s1.month_rental = s2.month_rental
;

/*
select 
	date_format(r.rental_date, '%Y') as year_rental ,
	date_format(r.rental_date, '%m') as month_rental ,
	r.rental_id ,
	s.store_id ,
	i.store_id ,
	r.staff_id 
from store s
join inventory i on s.store_id = i.store_id  
join rental r on i.inventory_id = r.inventory_id 
order by 3 asc
*/

-- A. Genre-Based Analysis
-- Q38. Which movie genre is most popular with customers?
with categories_by_each_cust as(
select 
	c.customer_id ,
	concat(c.first_name, ' ', c.last_name) as cust_fullname ,
	cat.name as categories_name ,
	count(r.rental_id) as no_of_categories_rented
from customer c
join rental r on c.customer_id = r.customer_id 
join inventory i on r.inventory_id = i.inventory_id 
join film f on i.film_id = f.film_id 
join film_category fcat on f.film_id = fcat.film_id 
join category cat on fcat.category_id = cat.category_id 
group by 1,2,3
order by 1, 4),
top_cat_by_each_cust as(
select
	*,
	dense_rank() over (partition by customer_id order by no_of_categories_rented desc) as cats_rank
from categories_by_each_cust)
select
	categories_name ,
	count(categories_name) as no_of_fav_cats
from top_cat_by_each_cust
where cats_rank = 1
group by 1
order by 2 desc;
-- Ans: The animation genre is most loved by customers.

-- Q39. The top 5 genres in terms of revenue and frequency
# based on frequency
select 
	cat.name as name_categories ,
	count(r.rental_id) as cat_frequencies
from category cat
join film_category fcat on cat.category_id = fcat.category_id 
join film f on fcat.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
group by 1
order by 2 desc 
limit 5;

# based on revenue
select 
	cat.name as name_categories ,
	sum(p.amount) as cats_revenue
from category cat
join film_category fcat on cat.category_id = fcat.category_id 
join film f on fcat.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id
group by 1
order by 2 desc 
limit 5;
-- Ans: The sports genre has the highest number of rentals and rental sales.

-- Q40. The most popular genre in each store in terms of revenue and frequency
# based on frequency
select 
	s.store_id ,
	cat.name as name_categories ,
	count(cat.name) as no_of_gernes
from category cat
join film_category fcat on cat.category_id = fcat.category_id 
join film f on fcat.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join store s on i.store_id = s.store_id 
join rental r on i.inventory_id = r.inventory_id 
group by 1,2
order by 1,3 desc;

# based on revenue
select 
	s.store_id ,
	cat.name as name_categories ,
	sum(p.amount) as genre_revenue
from category cat
join film_category fcat on cat.category_id = fcat.category_id 
join film f on fcat.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join store s on i.store_id = s.store_id 
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id 
group by 1,2
order by 1,3 desc;
-- Ans: In store 1, 'action' gerne has highest number of rentals but the highest rental sales in store 1 belong to the 'drama' genre.
-- In store 2, 'sport' genre has highest number of both rentals and sales.

-- B. Film-Based Analysis
-- Q41. The top 5 films in each category in terms of frequency and revenue
# based on frequency
with
film_rentals_each_category as(
	select 
		cat.name as name_categories ,
		f.film_id ,
		f.title as name_film ,
		count(r.rental_id) as no_of_time_rentals
	from category cat
	join film_category fcat on cat.category_id = fcat.category_id 
	join film f on fcat.film_id = f.film_id 
	join inventory i on f.film_id = i.film_id 
	join rental r on i.inventory_id = r.inventory_id 
	group by 1,2
	order by 1,4 desc) ,
	
row_num as(
	select
		* ,
		row_number () over(partition by name_categories order by name_categories, no_of_time_rentals desc) as row_no
	from film_rentals_each_category)
	
select
	*
from row_num
where row_no between 1 and 5;

# based on revenue
with 
	film_revenue_each_cat as(
		select 
			cat.name as name_categories ,
			f.film_id ,
			f.title as name_film ,
			count(r.rental_id) as no_of_time_rentals ,
			round(sum(p.amount),2) as revenue
		from category cat 
		join film_category fcat on cat.category_id = fcat.category_id 
		join film f on fcat.film_id = f.film_id 
		join inventory i on f.film_id = i.film_id 
		join rental r on i.inventory_id = r.inventory_id 
		join payment p on r.rental_id = p.rental_id 
		group by 1,2,3
		order by 1, 5 desc) ,
		
	sorted_revenue as(
		select
			* ,
			row_number() over (partition by name_categories order by name_categories, revenue desc) as rank_revenue
		from 
			film_revenue_each_cat)

select
	*
from 
	sorted_revenue
where
	rank_revenue <= 5;

-- Q42. The top 5 films for each rating (rating: PG, PG14 etc)
with 
	film_by_each_rating as (
		select 
			f.rating as rating ,
			f.title as film_name ,
			count(r.rental_id) as no_of_rentals ,
			round(sum(p.amount),2) as revenue
		from film f
		join inventory i on f.film_id = i.film_id 
		join rental r on i.inventory_id = r.inventory_id 
		join payment p on r.rental_id = p.rental_id 
		group by 1,2
		order by 1,4 desc) ,
		
	sorted_revenue as(
		select
			* ,
			row_number() over (partition by rating order by rating, revenue desc) as rank_revenue
		from
			film_by_each_rating)

select
	*
from 
	sorted_revenue
where
	rank_revenue <= 5;

-- Q43. The top 5 movies in terms of language
select 
	l.language_id ,
	l.name as language_name ,
	f.title as film_name ,
	count(r.rental_id) as no_of_rentals ,
	round(sum(p.amount),2) as revenue
from `language` l
join film f on l.language_id = f.language_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id 
group by 1,2,3
order by 1,5 desc
limit 5;
-- Ans: All films in warehouse are in English. TELEGRAPH VOYAGE has the highest revenue.

-- Q44. For each actor calculate the count of the number of movies he was cast in.
select 
	a.actor_id ,
	concat(a.first_name, ' ', a.last_name) as act_fullname ,
	group_concat(f.title order by f.title separator ', ') as acted_film ,
	count(fa.film_id) as no_of_film_cast_in
from actor a
join film_actor fa on a.actor_id = fa.actor_id 
join film f on fa.film_id = f.film_id 
group by 1,2
order by 1;

-- C. Store-Based Analysis
-- Q45. How many rented films were returned on time, late, or early? (DVD Return Rate)
with 
	check_return_status as (
		select 
		r.rental_id ,
		r.rental_date ,
		r.return_date ,
		datediff(r.return_date, r.rental_date) as time_rentals ,
		f.rental_duration ,
		r.customer_id ,
		case 
			when datediff(r.return_date, r.rental_date) > f.rental_duration then 'Returned Late'
			when datediff(r.return_date, r.rental_date) = f.rental_duration then 'Returned On Time'
			else 'Returned Early'
		end as return_status
		from film f
		join inventory i on f.film_id = i.film_id 
		join rental r on i.inventory_id = r.inventory_id 
		order by 1) ,
	
	count_rentals_status as (
		select 
			return_status ,
			count(rental_id) as no_of_rentals
		from 
			check_return_status
		group by 1)

select 
	* ,
	round((no_of_rentals / (select sum(no_of_rentals) from count_rentals_status))*100,2) as return_status_rate
from count_rentals_status;

-- Q46. Revenue is generated by each store.
# store monthly sales
##1.
with 
	store_monthly_sales as(
		select 
			date_format(p.payment_date, '%Y') as time_year ,
			date_format(p.payment_date, '%m') as time_month ,
			s.store_id ,
			round(sum(p.amount),2) as revenue
		from store s
		join inventory i on s.store_id = i.store_id 
		join rental r on i.inventory_id = r.inventory_id 
		join payment p on r.rental_id = p.rental_id 
		group by 1,2,3
		order by 3,1,2) ,
	
	total_revenue_each_store as(
		select
			store_id ,
			sum(revenue) as revenue_by_store
		from 
			store_monthly_sales
		group by 1)
select 
	sms.* ,
	round((sms.revenue / tres.revenue_by_store)*100,2) as sales_per_store_monthly_pct
from 
	store_monthly_sales sms
join total_revenue_each_store tres on sms.store_id = tres.store_id;

##2.
with
	store_monthly_sales as(
		select
			convert(year(p.payment_date), char) as time_year ,
			convert(month(p.payment_date), char) as time_month ,
			s.store_id ,
			round(sum(p.amount),2) as revenue
		from
			store s
		join inventory i on s.store_id = i.store_id
		join rental r on i.inventory_id = r.inventory_id
		join payment p on r.rental_id = p.rental_id
		group by 1,2,3
		order by 3,1,2)
select 
	* ,
	round((revenue / (select sum(revenue) from store_monthly_sales where store_id = sms.store_id))*100,2) as revenue_pct -- correlated subquery
from store_monthly_sales sms;

# revenue generated by each store
with 
	total_revenue_by_store as (
		select 
			s.store_id ,
			sum(p.amount) as revenue
		from store s
		join inventory i on s.store_id = i.store_id 
	join rental r on i.inventory_id = r.inventory_id 
	join payment p on r.rental_id = p.rental_id 
	group by 1)

select 
	* ,
	round((revenue / (select sum(revenue) from total_revenue_by_store))*100,2) as revenue_pct
from total_revenue_by_store;

-- D. Film Recommendation
-- Q47. Recommend movies for each customer to rent on the basis of his/her favourite genre excluding movies he/she has already rented.
-- (Note: Movies suggested to customers must be available in inventory)
set @userid := '2';
with 
	revenue_category_cust as (
		select 
			c.customer_id ,
			concat(c.first_name, ' ',c.last_name) as fullname ,
			cat.name as name_category ,
			count(r.rental_id) as frequencies ,
			sum(p.amount) as revenue
		from category cat
		join film_category fcat on cat.category_id = fcat.category_id 
		join film f on fcat.film_id = f.film_id 
		join inventory i on f.film_id = i.film_id 
		join rental r on i.inventory_id = r.inventory_id 
		join payment p on r.rental_id = p.rental_id 
		join customer c on r.customer_id = c.customer_id 
		where c.customer_id = @userid
		group by 1,2,3
		order by 1, 5 desc) ,
		
	top_gerne_customer as (
			select 
				* ,
				dense_rank () over (partition by customer_id order by customer_id, frequencies desc) as rank_genre
			from revenue_category_cust) -- top gerne of customer

select 
	fcat.category_id ,
	cat.name ,
	f.film_id ,
	f.title ,
	count(r.rental_id) as no_of_rentals ,
	round(sum(p.amount),2) as revenue
from category cat
join film_category fcat on cat.category_id = fcat.category_id 
join film f on fcat.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id 
where 
	cat.name = (select name_category from top_gerne_customer where rank_genre = 1 limit 1)
	and 
	f.film_id not in
				(select 
					distinct f.film_id 
				 from rental r
				 join inventory i on r.inventory_id = i.inventory_id
				 join film f on i.film_id = f.film_id
				 join film_category fcat on f.film_id = fcat.film_id 
				 join category cat on fcat.category_id = cat.category_id 
				 where r.customer_id = @userid)
group by 1,2,3,4
order by 5 desc;
