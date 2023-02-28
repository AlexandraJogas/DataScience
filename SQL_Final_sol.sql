/*Using the BoxOffice database write  the following queries:*/
USE BoxOffice;


select *  from [dbo].[movies]

/*1.Get the top ten popular movies where the original language was English. */

select Top 10 popularity, movie_id, original_language
from dbo.movies
where original_language='en'
order by popularity desc

/* 2. Calculate the number of movies that were released by year  */
select *  from dbo.movies

select year(release_date) as year_release, count(distinct movie_id) as cnt_movies
from dbo.movies
group by year(release_date)


/* 3. Calculate the number of movies that were released by month */
select *  from dbo.movies

select month(release_date) as month_release, count(distinct movie_id) as cnt_movies
from dbo.movies
group by month(release_date)

/* 4. Create a new variable based on runtime, where the movies are categorized 
      into the following categories: 0 = Unknown, 1-50 = Short, 51-120 =Average, >120 =Long. */

select *  from dbo.movies

select movie_id, runtime,
       case when (     runtime  =0               )    then 'Unknown'
	        when (1 <= runtime  and runtime <=50 )    then 'Short'
			when (51<= runtime  and runtime<=120 )    then 'Average'
			                                          else 'Long'
			end   as runtime_category
from dbo.movies

/* 5. For each year, calculate :
a. The dense rank, based on the revenue (descending order)
b. The yearly revenue's sum of the movies
c. The percent of the revenue with respect to the yearly annual revenue (b) */

select year(release_date) as year_release,
       movie_id,
       revenue,
	   DENSE_RANK() OVER (PARTITION BY year(release_date) ORDER BY revenue DESC) AS rownum  
from dbo.movies

select *  from dbo.movies

select year(release_date) as year_release,
	   SUM(CAST(revenue AS BIGINT))  as total_sum_revenue
from dbo.movies
group by year(release_date)
order by year(release_date)


select year(release_date) as year_release, movie_id, revenue
from dbo.movies
order by year(release_date)


select year(a.release_date) as year_release,
       a.movie_id, 
	   a.revenue,
	   (select 
		       SUM(CAST(revenue AS BIGINT))  
	           from dbo.movies as b
			   where    year(b.release_date)=year(a.release_date)
               group by year(release_date)			                 
        ) as total_sum_revenue,
	   	cast(revenue*1.0/(select 
		       SUM(CAST(revenue AS BIGINT))  
	           from dbo.movies as b
			   where    year(b.release_date)=year(a.release_date)
               group by year(release_date)	)		                 
               AS DECIMAL(7,4) ) as ratio 
from dbo.movies as a
order by year(a.release_date)


/* 6. For each movie, create a table that contains the following features: 
a. Count the number of female actors in the movie. 
b. Count the number of male actors in the movie. 
c. Calculate the ratio of male vs women (female count / male count)*
* Take into account that if the denominator (male_cnt) is zero you will get an 
  "arithmetic overflow" error!
*/
select *  from dbo.actors_dim   /* actor_id, gender */
select *  from dbo.movies_cast  /* movie_id, actor_id */

select a.movie_id, a.actor_id, b.gender
from       dbo.movies_cast as a
inner join dbo.actors_dim  as b
on a.actor_id=b.actor_id
where b.gender in (1, 2)

select a.movie_id, 
       count(case when (gender=1) then ( 1) end ) as cnt_female,
	   count(case when (gender=2) then ( 1) end ) as cnt_male,
	   count(case when (gender=1) then ( 1) end )*1.0 / count(case when (gender=2) then ( 1) end ) 
		as ratio
from       dbo.movies_cast as a
inner join dbo.actors_dim  as b
on a.actor_id=b.actor_id
where b.gender in (1, 2) 
group by a.movie_id
having count(case when (gender=2) then ( 1) end ) not in (0)
order by a.movie_id

/* 7. For each of the following languages: [en, fr, es, de, ru, it, ja]: 
      Create a column and set it to 1 if the movie has a translation** 
      to the language and zero if not. 
      ** Not only the original language  */
select *  from [dbo].[movies]
select *  from [dbo].[movie_languages]

select * from
(select a.movie_id, 
        a.original_language, 
        b.iso_639_1           as translate_lang,
		b.sw_original_lang    as origin_lang,
		case when b.sw_original_lang= 0 THEN  1  ELSE 0 END as ind_has_translate
from       dbo.movies           as a
left join  dbo.movie_languages  as b
on a.movie_id=b.movie_id
where a.original_language in ('en', 'fr', 'es', 'de', 'ru', 'it', 'ja')     
) as t
PIVOT(
      count(t.ind_has_translate)
		    for t.translate_lang  in ([en], [fr], [es], [de], [ru], [it], [ja])
) AS pivot_table


/*8. For each of the crew departments, create a column and count the total number of individuals
     for each movie. Create a view with this query */
select *  from  dbo.movies
select *  from  dbo.movies_crew

select distinct( department) from  dbo.movies_crew
order by department


select a.movie_id,  b.crew_id, b.department
from       dbo.movies       as a
inner join dbo.movies_crew  as b
on a.movie_id=b.movie_id
order by a.movie_id, b.department



create view dsuser02.Movie_Department_V as
select * from
(select a.movie_id, b.department, 1 as cnt_crew
from       dbo.movies       as a
inner join dbo.movies_crew  as b
on a.movie_id=b.movie_id
) as t
PIVOT(
      count(t.cnt_crew)
		    for department  in ([Actors], [Art], [Camera], [Costume & Make-Up], [Crew], [Directing], 
			                    [Editing],[Lighting], [Production], [Sound], [Visual Effects], [Writing])
) AS pivot_table

