/* Works in SQLite */

/* read data */
.read rating.sql


/* Find the names of all reviewers who rated Gone with the Wind. */
select distinct name
from (reviewer join rating using(rid)) join movie using(mid)
where movie.title='Gone with the Wind';


/* For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */
select distinct name,title,stars
from (movie join rating using(mid)) join reviewer using(rid)
where director=name;


/* Return all reviewer names and movie names together in a single list, alphabetized. */
select name as n from reviewer
union
select title as n from movie
order by n;


/* Find the titles of all movies not reviewed by Chris Jackson. */
select title from movie
where title not in (select title
							from (movie join rating using(mid)) join reviewer using(rid) where name='Chris Jackson');


/* For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. */
select distinct rev1.name,rev2.name
from reviewer rev1, rating rat1, reviewer rev2, rating rat2
where rev1.rid=rat1.rid and rev2.rid=rat2.rid and rat1.mid=rat2.mid and rev1.name<rev2.name;


/* For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. */
select name,title,stars
from (movie join rating r1 using(mid)) join reviewer using(rid)
where stars not in (select r2.stars from rating r2,rating r3 where r2.stars>r3.stars);


/* List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. */
select distinct title, (select avg(stars) from rating where rating.mid=r1.mid) as avgrate
from rating r1 join movie using(mid)
order by avgrate desc,title;


/* Find the names of all reviewers who have contributed three or more ratings. */
select distinct name
from reviewer join rating using(rid)
where 3<= (select count(*) from rating r2 where r2.rid=reviewer.rid);


/* Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. */
select m1.title, director
from movie m1 join movie m2 using(director)
where m1.mid<>m2.mid order by director,m1.title;


/* Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. */
select *
from (select distinct title, (select avg(stars) from rating r2 where r2.mid=r1.mid) as stars
		from rating r1 join movie using(mid)) avgmov
join
(select max(avgmov.stars) as stars
from (select distinct (select avg(stars) from rating r2 where r2.mid=r1.mid) as stars
		from rating r1) avgmov) maxavg
using(stars);


/* Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. */
select *
from (select distinct title, (select avg(stars) from rating r2 where r2.mid=r1.mid) as stars
		from rating r1 join movie using(mid)) avgmov
join
(select min(avgmov.stars) as stars
from (select distinct (select avg(stars) from rating r2 where r2.mid=r1.mid) as stars
		from rating r1) avgmov) maxavg
using(stars);


/* For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. */
select distinct *
from (select director, (select m2.title from rating r2 join movie m2 using(mid)
								where r2.mid=r1.mid and r2.rid=r1.rid and r2.stars=r1.stars and
										r2.stars==(select max(r3.stars) from movie m3 join rating r3 using(mid)
														where m3.director=movie.director)
								) as title, stars
		from movie join rating r1 using(mid) where not director is null) d
where not d.title is null;

