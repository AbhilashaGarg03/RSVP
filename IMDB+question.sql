USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
    COUNT(*) as count_of_rows
FROM
    director_mapping;

/*
# count_of_rows
3867
*/


SELECT 
    COUNT(*) as count_of_rows
FROM
    genre;

/*
# count_of_rows
14662
*/

SELECT 
    COUNT(*) as count_of_rows
FROM
    movie;

/*
# count_of_rows 
7997
*/

SELECT 
    COUNT(*) as count_of_rows
FROM
    names;

/*
# count_of_rows
25735
*/

SELECT 
    COUNT(*) as count_of_rows
FROM
    ratings;

/*
# count_of_rows
7997
*/

SELECT 
    COUNT(*) as count_of_rows
FROM
    role_mapping;

/*
# count_of_rows
15615
*/



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    COUNT(*) AS Null_values
FROM
    movie
WHERE
    id IS NULL;
-- 0 null values

SELECT 
    COUNT(*) AS Null_values
FROM
    movie
WHERE
    duration IS NULL;
-- 0 null values

SELECT 
    COUNT(*) AS Null_values
FROM
    movie
WHERE
    title IS NULL;
-- 0 null values

SELECT 
    COUNT(*) AS Null_values
FROM
    movie
WHERE
    date_published IS NULL;
-- 0 null values

SELECT 
    COUNT(*) AS Null_values
FROM
    movie
WHERE
    year IS NULL;
-- 0 null values

SELECT 
    COUNT(*) AS Null_values
FROM
    movie
WHERE
    country IS NULL;
-- 20 null values

SELECT 
    COUNT(*) AS Null_values
FROM
    movie
WHERE
    worlwide_gross_income IS NULL;
-- 3724 null values

SELECT 
    COUNT(*) AS Null_values
FROM
    movie
WHERE
    languages IS NULL;
-- 194 null values

SELECT 
    COUNT(*) AS Null_values
FROM
    movie
WHERE
    production_company IS NULL;
-- 528 null values

/* country, worlwide_gross_income, languages & production_company have null values. */



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)


/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
/* --- Part 1 */
SELECT 
    Year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY YEAR
ORDER BY COUNT(id) DESC;

/*
# Year	number_of_movies
2017	3052
2018	2944
2019	2001
*/

/* Part 2 */
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);

/*
# month_num	number_of_movies
1	804
2	640
3	824 --- highest number of movies in the month of March
4	680
5	625
6	580
7	493
8	678
9	809
10	801
11	625
12	438
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/


  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

WITH count_movie
     AS (SELECT *
         FROM   movie
         WHERE  year = 2019)
SELECT Count(*) AS movie_count
FROM   count_movie
WHERE  country LIKE '%USA%'
        OR country LIKE '%India%'; 

/*
# movie_count
1059
*/

/* OUTPUT - 1059 movies were produced */

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/



-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    (genre)
FROM
    genre;


/*
# genre
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */



-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    COUNT(m.id) AS movie_count, g.genre
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC
LIMIT 1;

/*
# movie_count	genre
4285	Drama
*/

/* OUTPUT - Drama has highest number of movies i.e. 4285 */

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/



-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH genre_count
     AS (SELECT movie_id,
                Count(genre) AS no_of_genre
         FROM   genre
         GROUP  BY movie_id)
SELECT Count(movie_id) as count_movie
FROM   genre_count
WHERE  no_of_genre = 1; 

/*
# count_movie
3289
*/

/* OUTPUT - 3289  movies belong to only one genre */



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/



-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT DISTINCT
    (g.genre), ROUND(AVG(m.duration), 2) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY g.genre;

/*
# genre	avg_duration
Drama	106.77
Fantasy	105.14
Thriller	101.58
Comedy	102.62
Horror	92.72
Family	100.97
Romance	109.53
Adventure	101.87
Action	112.88
Sci-Fi	97.94
Crime	107.05
Mystery	101.80
Others	100.16

Drama genre has average duration of 106.77 minutes
*/



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/



-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank
     AS (SELECT DISTINCT genre,
                         Count(movie_id)                    AS movie_count,
                         Rank()
                           OVER(
                             ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_rank
WHERE  genre = 'Thriller'; 

/*
# genre	movie_count	genre_rank
Thriller	1484	3
8/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT 
    ROUND(MIN(avg_rating)) AS min_avg_rating,
    ROUND(MAX(avg_rating)) AS max_avg_rating,
    ROUND(MIN(total_votes)) AS min_total_votes,
    ROUND(MAX(total_votes)) AS max_total_votes,
    ROUND(MIN(median_rating)) AS min_median_rating,
    ROUND(MAX(median_rating)) AS max_median_rating
FROM
    ratings;


/*
# min_avg_rating	max_avg_rating	min_total_votes	max_total_votes	min_median_rating	max_median_rating
	1				10				100					725138			1					10
*/
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/



-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH top_movie
     AS (SELECT title,
                avg_rating,
                RANK()
                  OVER(
                    ORDER BY avg_rating DESC) AS movie_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id)
SELECT *
FROM   top_movie
LIMIT 10; 

/*
# title						avg_rating	movie_rank
Kirket							10.0	1
Love in Kilnerry				10.0	1
Gini Helida Kathe				9.8		3
Runam							9.7		4
Fan								9.6		5
Android Kunjappan Version 5.25	9.6		5
Yeh Suhaagraat Impossible		9.5		7
Safe							9.5		7
The Brighton Miracle			9.5		7
Shibu							9.4		10

--- FAN is in the top 10 movies with avg rating of 9.6
*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/



-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;

/*
# median_rating	movie_count
	1			94
	2			119
	3			283
	4			479
	5			985
	6			1975
	7			2257
	8			1030
	9			429
	10			346
*/
/* median_rating 7 has highest number of movie counts as 2257 */



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/



-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_rank
     AS (SELECT DISTINCT production_company,
                         Count(m.id)                    AS movie_count,
                         RANK()
                           OVER(
                             ORDER BY Count(m.id) DESC) AS prod_company_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  r.avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   prod_rank
WHERE  prod_company_rank = 1; 


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

/*
# production_company	movie_count	prod_company_rank
Dream Warrior Pictures	3	1
National Theatre Live	3	1
*/

/* OUTPUT -- Dream Warrior Pictures & National Theatre Live production companies have rank 1 */

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT DISTINCT genre,
                Count(g.movie_id) AS movie_count
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.country LIKE '%USA%'
       AND r.total_votes > 1000
       AND m.year = 2017
       AND Month(date_published) = 3
GROUP  BY genre
ORDER  BY movie_count DESC; 


/*
# genre	movie_count
Drama		24
Comedy		9
Action		8
Thriller	8
Sci-Fi		7
Crime		6
Horror		6
Mystery		4
Romance		4
Fantasy		3
Adventure	3
Family		1

*/

/* OUTPUT - Drama genre in USA has highest movie counts i.e. 24 in number */



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    title, avg_rating, genre
FROM
    ratings r
        INNER JOIN
    movie m ON r.movie_id = m.id
        INNER JOIN
    genre g ON m.id = g.movie_id
WHERE
    avg_rating > 8 AND title LIKE 'The%'
GROUP BY title
ORDER BY avg_rating DESC;

/*
# title	avg_rating	genre
The Brighton Miracle	9.5	Drama
The Colour of Darkness	9.1	Drama
The Blue Elephant 2	8.8	Drama
The Irishman	8.7	Crime
The Mystery of Godliness: The Sequel	8.5	Drama
The Gambinos	8.4	Crime
Theeran Adhigaaram Ondru	8.3	Action
The King and I	8.2	Drama
*/

/* OUTPUT The Brighton Miracle which is in genre 'Drama' has highest average rating i.e. 9.5*/




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
    median_rating, COUNT(id) AS movie_count
FROM
    ratings r
        INNER JOIN
    movie m ON r.movie_id = m.id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

/* 
# median_rating		movie_count
		8			361
*/

/* OUTPUT - 361 number of movies were given median rating as 8 */



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


-- by language
SELECT 
    languages, SUM(total_votes) AS total_votes_germany
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    languages LIKE '%german%';

/*
# languages	total_votes_germany
	German		4421525
*/

SELECT 
    languages, SUM(total_votes) AS total_votes_italy
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    languages LIKE '%italian%';

/* 
# languages	total_votes_italy
	Italian		2559540
*/


/* Output --- yes German language got more votes than Italian language */

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT 
    SUM(CASE
        WHEN NAME IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;

/*
# name_nulls	height_nulls	date_of_birth_nulls	known_for_movies_nulls
		0			17335			13431				15226
*/
/* OUTPUT --- There are no nulls in the column 'name' */





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/




-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_3_genre AS
(
           SELECT     g.genre,
                      Count(m.id)                                  AS movie_count,
                      ROW_NUMBER() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       genre g
           INNER JOIN ratings r
           ON         g.movie_id=r.movie_id
           INNER JOIN movie m
           ON         r.movie_id=m.id
           WHERE      avg_rating > 8
           GROUP BY   genre
           ORDER BY   Count(m.id) DESC limit 3 )
SELECT     n.NAME             AS director_name ,
           Count(dm.movie_id) AS movie_count
FROM       names n
INNER JOIN director_mapping dm
ON         n.id=dm.name_id
INNER JOIN movie m
ON         dm.movie_id=m.id
INNER JOIN ratings r
ON         m.id=r.movie_id
INNER JOIN genre g
ON         r.movie_id=g.movie_id
INNER JOIN top_3_genre
using     (genre)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

/*
# director_name	movie_count
	James Mangold	4
	Anthony Russo	3
	Soubin Shahir	3
*/

/* OUTPUT - James Mangold has 4 movie counts*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name      AS actor_name,
       COUNT(m.id) AS movie_count
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN movie m
               ON rm.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  median_rating >= 8
       AND rm.category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 

/*

# actor_name	movie_count
	Mammootty	8
	Mohanlal	5
*/


/* OUTPUT - Mammootty tops the list with 8 movie counts & after that is Mohanlal with 5 movie counts */




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/




-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT DISTINCT production_company,
                Sum(total_votes)                              AS vote_count ,
                RANK() OVER( ORDER BY Sum(total_votes) DESC ) AS prod_comp_rank
FROM            movie m
INNER JOIN      ratings r
ON              m.id=r.movie_id
GROUP BY        production_company
ORDER BY        Sum(total_votes) DESC limit 3;


/*
# production_company	vote_count	prod_comp_rank
	Marvel Studios			2656967		1
	Twentieth Century Fox	2411163		2
	Warner Bros.			2396057		3
*/

/* OUTPUT - Marvel studios have highest number of vote counts as 26,56,967, Twentieth Century Fox, Warner Bros. are the next two */




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/




-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT     n.NAME  												 AS actor_name,
           total_votes,
           Count(m.id)                                           AS movie_count,
           Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actor_avg_rating,
           RANK() OVER(ORDER BY avg_rating DESC)                 AS actor_rank
FROM       names n
INNER JOIN role_mapping rm
ON         n.id=rm.name_id
INNER JOIN movie m
ON         rm.movie_id=m.id
INNER JOIN ratings r
ON         m.id=r.movie_id
WHERE      category='actor'
AND        country = 'India'
GROUP BY   n.NAME
HAVING     movie_count >=5 limit 1;


/*
# name					total_votes	movie_count	actor_avg_rating	actor_rank
	Vijay Sethupathi	20364			5			8.42				1
*/


/* OUTPUT - top actor is Vijay Sethupathi with total votes of 20364 & avg rating as 8.4 */

-- Top actor is Vijay Sethupathi



-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT     n.NAME AS actress_name,
           total_votes,
           Count(m.id)                                           AS movie_count,
           Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating,
           RANK() OVER(ORDER BY avg_rating DESC)                 AS actress_rank
FROM       names n
INNER JOIN role_mapping rm
ON         n.id=rm.name_id
INNER JOIN movie m
ON         rm.movie_id=m.id
INNER JOIN ratings r
ON         m.id=r.movie_id
WHERE      category='actress'
AND        country ='India'
AND        languages='Hindi'
GROUP BY   n.NAME
HAVING     movie_count >=3 limit 1;

/*
# actress_name		total_votes	movie_count	actress_avg_rating	actress_rank
	Taapsee Pannu	2269			3			7.74				1
*/


/* OUTPUT - Taapsee Pannu tops the list with 2269 votes & avg rating as 7.734 */

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/






/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    title AS movie_name,
    CASE
        WHEN avg_rating > 8 THEN 'SuperHit Movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit Movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-Time-Watch Movies'
        ELSE 'Flop Movies'
    END AS 'Movie Classification'
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r ON g.movie_id = r.movie_id
WHERE
    genre = 'thriller';




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH avg_summary AS
(
           SELECT     g.genre,
                      Round(AVG(m.duration)) AS avg_duration
           FROM       movie m
           INNER JOIN genre g
           ON         m.id=g.movie_id
           GROUP BY   g.genre 
          )
SELECT   * ,
         SUM(avg_duration) OVER w1 AS running_total_duration,
         AVG(avg_duration) OVER w2 AS moving_avg_duration
FROM     avg_summary window w1     AS (ORDER BY genre rows UNBOUNDED PRECEDING),
         w2                        AS (ORDER BY genre rows UNBOUNDED PRECEDING);
 

/*
		# genre			avg_duration	running_total_duration	moving_avg_duration
		Action			113					113					113.0000
		Adventure		102					215					107.5000
		Comedy			103					318					106.0000
		Crime			107					425					106.2500
		Drama			107					532					106.4000
		Family			101				    633					105.5000
		Fantasy			105					738					105.4286
		Horror			93					831					103.8750
		Mystery			102					933					103.6667
		Others			100					1033				103.3000
		Romance			110					1143				103.9091
		Sci-Fi			98					1241				103.4167
		Thriller		102					1343				103.3077

*/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_genre AS
(
SELECT g.genre AS genre
FROM
genre AS g
LEFT JOIN
movie AS m
ON m.id=g.movie_id
GROUP BY g.genre
ORDER BY count(m.id) DESC
LIMIT 3
),
top_movies AS
(
SELECT g.genre AS genre,
m.year AS year,
m.title AS movie_name,
m.worlwide_gross_income AS worldwide_gross_income,
row_number() OVER(
PARTITION BY m.year
ORDER BY 
CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""),UNSIGNED INT) DESC
) AS movie_rank
FROM
movie AS m
INNER JOIN
genre AS g
ON m.id=g.movie_id
WHERE genre IN
( SELECT DISTINCT(genre)
FROM
top_genre)
 )
SELECT *
FROM
top_movies
WHERE movie_rank<=5;

/*
# genre	year	movie_name	worldwide_gross_income	movie_rank
Thriller	2017	The Fate of the Furious	$ 1236005118	1
Comedy	2017	Despicable Me 3	$ 1034799409	2
Comedy	2017	Jumanji: Welcome to the Jungle	$ 962102237	3
Drama	2017	Zhan lang II	$ 870325439	4
Thriller	2017	Zhan lang II	$ 870325439	5
Drama	2018	Bohemian Rhapsody	$ 903655259	1
Thriller	2018	Venom	$ 856085151	2
Thriller	2018	Mission: Impossible - Fallout	$ 791115104	3
Comedy	2018	Deadpool 2	$ 785046920	4
Comedy	2018	Ant-Man and the Wasp	$ 622674139	5
Drama	2019	Avengers: Endgame	$ 2797800564	1
Drama	2019	The Lion King	$ 1655156910	2
Comedy	2019	Toy Story 4	$ 1073168585	3
Drama	2019	Joker	$ 995064593	4
Thriller	2019	Joker	$ 995064593	5

*/


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           Count(m.id)                             AS movie_count,
           RANK() OVER (ORDER BY Count(m.id) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id=r.movie_id
WHERE      median_rating >= 8
AND        production_company IS NOT NULL
AND        languages LIKE '%,%'
GROUP BY   production_company
ORDER BY   Count(m.id) DESC limit 2;


/*
# production_company	movie_count	prod_comp_rank
	Star Cinema				7		1
	Twentieth Century Fox	4		2
*/

/* OUTPUT - Star Cinema & Twentieth Century Fox are the 2 top production comapnies with movie counts 7 & 4 respectively */

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT     n.NAME                                                AS actress_name,
           Sum(total_votes)                                      AS total_votes,
           Count(m.id)                                           AS movie_count,
           Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating,
           RANK() OVER(ORDER BY avg_rating DESC)                AS actress_rank
FROM       names n
INNER JOIN role_mapping rm
ON         n.id=rm.name_id
INNER JOIN movie m
ON         rm.movie_id=m.id
INNER JOIN ratings r
ON         m.id=r.movie_id
INNER JOIN genre g
ON         r.movie_id=g.movie_id
WHERE      rm.category='ACTRESS'
AND        genre='Drama'
GROUP BY   n.NAME
HAVING actress_avg_rating> 8 
limit 3;

/*
# actress_name	total_votes	movie_count	actress_avg_rating	actress_rank
Sangeetha Bhat	1010		1			9.60				1
Fatmire Sahiti	3932		1			9.40				2
Adriana Matoshi	4058		2			9.33				2

*/


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference))   AS avg_inter_movie_days,
         avg_rating		               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;


/* OUTPUT - Andrew Jones top most director with 5 number of movies */