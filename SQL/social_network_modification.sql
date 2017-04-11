/*
It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
*/
delete from highschooler where grade=12;

/*
If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
*/
delete from likes
where id1 in (select id1 from friend where id2=likes.id2)
and id1 not in (select id2 from likes l where l.id1=likes.id2);

/*
For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself.
*/
insert into friend
	select distinct f1.id1,f2.id2
	from friend f1, friend f2
	where f1.id2=f2.id1 and f1.id1!=f2.id2 and f1.id1 not in (select id2 from friend f3 where f3.id1=f2.id2);

