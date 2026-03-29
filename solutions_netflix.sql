
-- 15 Business Problems & Solutions


SELECT * FROM NETFLIX

-- 1. Count the number of Movies vs TV Shows


select type,
count(*) as total_number
from netflix
group by type

--OR
select sum(case when type='Movie'then 1 else 0 end ) as number_of_movies,
sum(case when type='TV Show'then 1 else 0 end ) as number_of_tv_shows
from netflix









-- 2. Find the most common rating for movies and TV shows

select  
rating as most_common_rating

from netflix
group by rating 
order by count(*) desc
limit 1


--3. List all movies released in a specific year (e.g., 2020)


select *
from netflix 
where type= 'Movie' and release_year=2020



--4. Find the top 5 countries with the most content on Netflix


select
new_country,
count(*)
from
    (select 
	trim(unnest(string_to_array(country,','))) as new_country
	from netflix) t
group by new_country
order by count(*) desc
limit 5





--5. Identify the longest movie
select *
from netflix 
where cast(split_part(duration,' ', 1) as int)= (select 
											     max(cast(split_part(duration,' ', 1) as int)) as maximum_duration
											     from netflix)



--6. Find content added in the last 5 years

select *
from netflix 
where coalesce(extract(year from cast(date_added as date)),0) in (select 
																coalesce(extract(year from cast(date_added as date)),0)
																from netflix
																group by 1
																order by 1 desc
																limit 5
																)

		--or 

select current_date - interval '5 years' -- problem because data is not updated till 2026)4
select
*
from netflix 
where cast(date_added as date)>= current_date - interval '5 years'





--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!


select * from netflix
where director = 'Rajiv Chilaka'







--8. List all TV shows with more than 5 seasons

select *
from netflix
where type ='TV Show' and cast(split_part(duration,' ', 1) as int) > 5




--9. Count the number of content items in each genre
select trim(unnest(string_to_array(coalesce(listed_in,'unknown'),','))) as new_genre,
count(*) as total_content
from netflix
group by 1        






select*
from netflix


--10.Find each year and the average numbers of content release in India on netflix. 

select *,
(num_of_content/sum(num_of_content) over())*100 as avg_content_per_year
from
	(select  extract(year from cast(date_added as date)) as release_year,
	count(*) as num_of_content
	
	
	from netflix
	where country like '%India%'
	group by 1
	order by 1) t
order by 2 desc
limit 5



--return top 5 year with highest avg content release!


--11. List all movies that are documentaries

select *
from netflix
where type = 'Movie' and listed_in = 'Documentaries'



--12. Find all content without a director

select *
from netflix
where director is null



--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select *
from netflix
where release_year in   (select 
						coalesce (release_year ,0)
						from netflix
						group by 1
						order by 1 desc
						limit 10
						)       

						and casts like '%Salman Khan%'
        





--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
	trim(unnest(string_to_array(casts,','))) as casts_new,
	count(*) as num_of_movies
	from netflix
	where type='Movie' and  country like '%India%'
	group by 1 
	order by 2 desc
	limit 10

select * from netflix

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

select category,
count(*) as total_content
from 
    (select *,
	(case when description like '%kill%' or description like '%voilence%' then 'bad' else 'good' end) as category
	from netflix
	) t
group by 1
order by 2 desc




