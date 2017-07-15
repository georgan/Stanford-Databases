/* Works in SQLite */

/* read data */
.read social.sql


/* Find the names of all students who are friends with someone named Gabriel. */
select h2.name
from highschooler h1, highschooler h2, friend f
where h1.id=f.id1 and h2.id=f.id2 and h1.name='Gabriel';


/* For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. */
select h1.name,h1.grade,h2.name,h2.grade
from highschooler h1,highschooler h2, likes
where h1.id=likes.id1 and h2.id=likes.id2 and h1.grade-h2.grade>=2;


/* For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. */
select h1.name,h1.grade,h2.name,h2.grade
from likes l1, likes l2, highschooler h1, highschooler h2
where h1.id=l1.id1 and h2.id=l1.id2 and h1.name<h2.name and l1.id1=l2.id2 and l2.id1=l1.id2;


/* Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. */
select name,grade
from highschooler h1
where id not in (select id1 from likes union select id2 from likes) order by grade,name;


/* For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */
select h1.name,h1.grade,h2.name,h2.grade
from highschooler h1,highschooler h2, likes l1
where h1.id=l1.id1 and h2.id=l1.id2 and h2.id not in (select id1 from likes);


/* Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. */
select distinct name,grade
from highschooler, friend
where id=id1 and id not in
						(select h1.id from highschooler h1,highschooler h2, friend f
						where f.id1=h1.id and f.id2=h2.id and h1.grade<>h2.grade)
order by grade,name;


/* For each student A who likes a student B where the two are not friends, find if they have a friend C in common. For all such trios, return the name and grade of A, B, and C. */
select h1.name,h1.grade,h2.name,h2.grade,h3.name,h3.grade
from friend f1, highschooler h1, friend f2, highschooler h2, highschooler h3, likes l
where h1.id=f1.id1 and h2.id=f2.id1 and h3.id = f1.id2 and f1.id1 = l.id1 and f2.id1=l.id2 and f1.id2=f2.id2 and
l.id2 not in (select id2 from friend where friend.id1=l.id1);


/* Find the difference between the number of students in the school and the number of different first names. */
select count(distinct id) - count(distinct name) from highschooler;


/* Find the name and grade of all students who are liked by more than one other student. */
select distinct name,grade
from highschooler h, likes l
where l.id2=h.id and 2 <= (select count(id1) from likes where likes.id2=l.id2);

