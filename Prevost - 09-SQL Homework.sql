# Question 1a
Use sakila; 
Select first_name, last_name FROM actor

# Question 1b
Use sakila;
select CONCAT(first_Name , ' ' ,last_name) as Actor_Name from actor

#Question 2a
Use sakila;
select actor_id, first_name, last_name from actor
where first_name = "Joe"

#Question 2b
Use sakila;
select * from actor
where last_name like "%gen%"

#Question 2c
Use sakila;
select * from actor
where last_name like "%li%"
order by last_name, first_name asc

#Question 2d Using `IN`, display the `country_id` and `country`  Afghanistan, Bangladesh, and China
use sakila;
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China')

#Question 3a
use sakila
alter table actor ADD COLUMN description blob;

#Question 3b
use sakila
alter table actor DROP COlumn description;

#Question 4a
use sakila
Select last_name, count(last_name) from actor 
Group by last_name

#Question 4b
use sakila
Select last_name, count(*) from actor 
Group by last_name
Having count(*)>2

#Question 4c (Note that 
UPDATE actor
SET first_name='HARPO'
WHERE actor_id=172;

#Question 4d
UPDATE actor
SET first_name='GROUCHO'
WHERE actor_id=172;

#Question 5a
use sakila;
CREATE table address1 (
address_id int primary key Not Null, 
address varchar(250),
address2 varchar(250),
district varchar(250),
city_id int,
postal_code int(5),
phone int(12),
location blob, 
last_update datetime 
);

#Question 6a: * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
use sakila;
SELECT first_name, last_name, staff.address_id, address 
From staff
inner join address on address.address_id = staff.address_id

#Question 6b: Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
Select staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
from staff
inner join payment on payment.staff_id = staff.staff_id
Where payment.payment_date BETWEEN CAST('2005-08-01' as date) AND CAST('2005-08-31' as date)
Group by staff.staff_id, staff.first_name, staff.last_name

#Question 6c: List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
use sakila;
SELECT film.film_id, title, fa.actor_id
From film, (
	Select film_id, actor_id
    from film_actor
    Group by film_id) as fa
Where film.film_id = fa.film_id;

Select film.film_id, title, Count(film_actor.actor_id) as Number_Actors
from film
inner join film_actor on film.film_id = film_actor.film_id
Group by film.film_id, film.title

#Question 6d: How many copies of the film `Hunchback Impossible` exist in the inventory system?
use sakila;
Select film.film_id, title, Number_Inventory 
from film Inner Join (
	Select film_id, Count(inventory_id) as Number_Inventory
    From inventory
	Group by film_id) as f_inv
on f_inv.film_id = film.film_id
Where title = 'Hunchback Impossible'

Select film.film_id, film.title, Count(inventory_id) as Number_Inventory
from film
inner join inventory on inventory.film_id = film.film_id
where title = 'Hunchback Impossible'

#Question 6e: Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
##List the customers alphabetically by last name
use sakila;
SELECT first_name, last_name, SUM(amount) as Total_Payments
from customer
Inner Join payment on payment.customer_id = customer.customer_id
Group by payment.customer_id 
Order by last_name asc

#Question 7a: The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
##films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles 
###of movies starting with the letters `K` and `Q` whose language is English.
use sakila;
Select E.title
from language Inner Join (
	Select film.title, film.language_id
    from film
    Where film.title like "K%" or film.title like "Q%") as E
on language.language_id = E.language_id 
Where language.name = "English"

#Question 7b: Use subqueries to display all actors who appear in the film `Alone Trip`.
Select first_name, last_name
from actor inner join film_actor on film_actor.actor_id = actor.actor_id 
 where film_actor.film_id in (
	select film_id
    from film
    where title = 'Alone Trip') 
    
#Question 7c: You want to run an email marketing campaign in Canada, for which you will need the names and email 
##addresses of all Canadian customers. Use joins to retrieve this information

Select customer.first_name, customer.last_name, customer.email
from customer inner join address on address.address_id = customer.address_id inner join city on city.city_id = address.city_id 
where country_id  in (
	Select country_id
	from country
	where country = "Canada")
    
#Question 7d: Sales have been lagging among young families, and you wish to target all family 
##movies for a promotion. Identify all movies categorized as _family_ films.

Select film.title
from film inner join film_category on film.film_id = film_category.film_id and film_category.category_id
where category_id in (
	select category_id
    from category
    where category.name = "Family");

#Question 7e: Display the most frequently rented movies in descending order.
Select film.title as Film, Count(rental.rental_Id) as No_Rentals
from rental left join inventory on rental.inventory_id = inventory.inventory_id left join film on inventory.film_id = film.film_id
Group by Film
Order by No_Rentals desc

#Question 7f: Write a query to display how much business, in dollars, each store brought in
Select store.store_id, Total_Dollars
from store left join staff on store.store_id = staff.store_id inner join (
select payment.staff_id, SUM(payment.amount) as Total_Dollars
from payment
Group by payment.staff_id) as P
on P.staff_id = staff.staff_id

#Question 7g: Write a query to display for each store its store ID, city, and country.
Select store.store_id, city.city, country.country
from store left join address on address.address_id = store.address_id left join city on city.city_id = address.city_id left join country on city.country_id = country.country_id

#Question 7h: List the top five genres in gross revenue in descending order. 
##(**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

Select category.name as Genre, SUM(payment.amount) as Gross_Revenue
from rental 
	left join payment on rental.rental_id = payment.rental_id 
	left join inventory on inventory.inventory_id = rental.inventory_id
    left join film_category on inventory.film_id = film_category.film_id
    left join category on film_category.category_id = category.category_id
Group by Genre
Order by Gross_revenue desc limit 5

#Question 8a:  In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
##If you haven't solved 7h, you can substitute another query to create a view.

Create view Prevost_8aView as 
Select category.name as Genre, SUM(payment.amount) as Gross_Revenue
from rental 
	left join payment on rental.rental_id = payment.rental_id 
	left join inventory on inventory.inventory_id = rental.inventory_id
    left join film_category on inventory.film_id = film_category.film_id
    left join category on film_category.category_id = category.category_id
Group by Genre

#Question 8b:  To see my view, I would select "Views" under the database (in this case, the Sakila database) and click on the "Table" icon. A new tab opens with the view.

#Question 8c: 
Drop view Prevost_8aview