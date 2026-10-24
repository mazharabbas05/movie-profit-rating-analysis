select *,(revenue-budget)*100/budget as pct_profit
from financials
where (revenue- budget)*100/budget>=500;


select
 x.movie_id,x.pct_profit,
 y.title,y.imdb_rating
 from (select *,(revenue-budget)*100/budget as pct_profit
from financials)x
join (select * from movies 
where imdb_rating<(select avg(imdb_rating) from movies)) y
using (movie_id)
where pct_profit>=500;


select * from movies 
where imdb_rating<(select avg(imdb_rating) from movies)
