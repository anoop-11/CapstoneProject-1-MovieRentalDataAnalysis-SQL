-- Capstone Project I - SQL

use sakila;
show tables;


-- Task1 : Display the fullnames of actors available in the database

select * from actor;
select concat(first_name, ' ' ,last_name) as "Fullname of Actors" from actor;


-- Task2.i : Display the number of times each first name appears in the database

select first_name as "FirstName" , count(first_name) as "Count of Firstname" from actor 
group by first_name order by count(first_name) desc;


-- Task2.ii : what is the count of actors that have unique firstnames in the database? Display the first name of all these actors

select first_name as "FirstName" , count(first_name) as "Count of Firstname" from actor 
group by first_name having count(first_name) = 1;


-- Task3.i : Display the number of times each last name appears in the database

select last_name as Last_Name , count(last_name) as "Count of Last_name" from actor
group by last_name order by count(last_name) desc; 


-- Task3.ii : Display the unique last names in the database.

select last_name as Last_Name, count(last_name) as "Count of Last_name" from actor 
group by last_name having count(last_name) = 1;


/* Task4.i : Display the list of records for the movie with the rating "R".
(the movies with the rating "R" are not suitable for audience under 17 years of age) */

select * from film where rating = 'R';


-- Task4.ii : Display the list of records for the movies that are not rated "R".

select * from film where rating != 'R';


-- Task4.iii : Display the list of records for the movies that are suitable for audience below 13 years of age.

select * from film where rating = 'G';


-- Task5.i : Display the list of records for the movies where the replacement cost is upto $11.

select * from film where replacement_cost < 11; 


-- Task5.ii : Display the list of records for the movies where the replacement cost is between $11 and $20.

select * from film where replacement_cost between 11 and 20; 


-- Task5.iii : Display the list of records for the all movies in descending order of their replacement costs.

select * from film order by replacement_cost desc; 



-- Task6 : Display the names of the top 3 movies with the greatest number of actors

-- Method (using dense_rank)

select title, count(first_name) as Count_of_Actor, dense_rank() over(order by count(first_name) desc) as 'Rank' 
from film as f join film_actor as fa on f.film_id = fa.film_id 
join actor as a on a.actor_id = fa.actor_id group by title
order by count(first_name) desc;

-- Another Method (using dense_rank and View)

create view Top_Movie as
select title, count(first_name) as Count_of_Actor, dense_rank() over(order by count(first_name) desc) as Rank_of_Movies
from film as f join film_actor as fa on f.film_id = fa.film_id 
join actor as a on a.actor_id = fa.actor_id group by title
order by count(first_name) desc;

select * from Top_Movie where Rank_of_Movies <= 3;

-- Simple method (by using Limit clause)

select title, count(first_name) as Count_of_Actor 
from film as f join film_actor as fa on f.film_id = fa.film_id 
join actor as a on a.actor_id = fa.actor_id group by title
order by count(first_name) desc LIMIT 3;

-- Another method (condition - 'G' Rating)

select title, count(first_name) as Count_of_Actor 
from film as f join film_actor as fa on f.film_id = fa.film_id 
join actor as a on a.actor_id = fa.actor_id where rating = 'G' group by title
order by count(first_name) desc;
  
select title, count(first_name) as Count_of_Actor 
from film as f join film_actor as fa on f.film_id = fa.film_id 
join actor as a on a.actor_id = fa.actor_id where rating = 'G' group by title
order by count(first_name) desc Limit 3;


-- Task7 : Display the titles of the movies starting with the letters 'K' and 'Q'

select title as "Movie Title" from film where title like 'K%' or title like 'Q%';  


-- Task8 : The film 'Agent Truman' has been great success.Display the names of all actors who appeared in th film.

select * from film_actor;
select * from film;
select * from actor;
show tables;

select concat(first_name, ' ' ,last_name) as "Actor Name" , title as "Movie Title" from actor as a join
film_actor as fa on a.actor_id = fa.actor_id join 
film as f on f.film_id = fa.film_id where title = 'AGENT TRUMAN';


-- Task9 : Identify all the movies categorized as family films.


select * from category;
select * from film_category;
select * from film;

select title as "Movie Title" , c.name as Film_Category from film as f join 
film_category as fc on f.film_id = fc.film_id join
category as c on c.category_id = fc.category_id
where name = 'Family';


/* Task10.i : Display maximum , minimum and average rental rates of movies based on their ratings. 
The output must be sorted in descending of the average rental rates. */

select rating , max(rental_rate) as Maximum_Rental , min(rental_rate) as Minimum_Rental , avg(rental_rate) as Average_Rental 
from film group by rating order by avg(rental_rate) desc;


-- Task10.ii : Display the movies in descending order of their rental frequencies,so the management can maintain more copies of those movies.

select f.title as Movie_Title , count(r.rental_id) as rental_frequency 
from film as f join inventory as i on f.film_id = i.film_id join 
rental as r on r.inventory_id = i.inventory_id
group by f.title order by rental_frequency desc;


/* Task11.i : In how many film categories, the difference between the average 
film replacement cost and the average film rental  rate is greater than $15 */

select c.name as Category_Name from category as c join film_category as fc 
on c.category_id = fc.category_id join film as f on f.film_id = fc.film_id
group by c.name having avg(replacement_cost) - avg(rental_rate) > 15;


/* Task11.ii : Display the list of film categories identified above,
along with the corresponding average film replacement cost and average film rental rate */

select c.name as Category_Name, avg(replacement_cost) as "Average Replacement Cost", avg(rental_rate) as "Average Rental Cost"
from category as c join film_category as fc 
on c.category_id = fc.category_id join film as f on f.film_id = fc.film_id
group by c.name having avg(replacement_cost) - avg(rental_rate) > 15;


-- Task12 : Display the film categories in which the number of movies is greater than 70

select c.name as Category_Name , count(title) as Number_of_Movies from category as c join film_category as fc 
on c.category_id = fc.category_id join film as f on f.film_id = fc.film_id
group by c.name having count(title) > 70;


-- extra 
select * from film;
select * from film_category;
select * from category;
show tables;
select f.title , f.rating , c.name from film as f join film_category as fc
on f.film_id = fc.film_id join category as c
on fc.category_id = c.category_id where title IN ("BUCKET BROTHERHOOD" , "ROCKETEER MOTHER");
