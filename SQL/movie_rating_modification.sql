/* Works in SQLite */

/* read data */
.read rating.sql


/* Add the reviewer Roger Ebert to your database, with an rID of 209. */
insert into reviewer values (209,'Roger Ebert');


/* Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. */
insert into rating
	select rid,mid,5,null
	from movie,reviewer
	where name='James Cameron';


/* For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) */
update movie set year=25+year
where 4 <= (select avg(stars) from rating where mid=movie.mid);


/* Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. */
delete from rating
where stars < 4 and mid in (select mid from movie where year < 1970 or year > 2000);

