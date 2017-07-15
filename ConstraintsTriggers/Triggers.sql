/* It works in SQLite database management system */

/* Read the data */
.read social.sql


/* Write a trigger that makes new students named 'Friendly' automatically like everyone else in their grade. That is, after the trigger runs, we should have ('Friendly', A) in the Likes table for every other Highschooler A in the same grade as 'Friendly */

create trigger Friendly
after insert on highschooler
when new.name = 'Friendly'
begin
    insert into likes
    select new.id,h2.id
    from highschooler h2
    where h2.grade = new.grade and h2.id <> new.id;
end;


/* Write one or more triggers to manage the grade attribute of new Highschoolers. If the inserted tuple has a value less than 9 or greater than 12, change the value to NULL. On the other hand, if the inserted tuple has a null value for grade, change it to 9 */

create trigger LargeSmallGrade
after insert on highschooler
when new.grade < 9 or new.grade > 12
begin
    update highschooler
    set grade = NULL
    where highschooler.id = new.id;
end;

create trigger NullGrade
after insert on highschooler
when new.grade is NULL
begin
    update highschooler
    set grade = 9
    where highschooler.id = new.id;
end;


/* Write one or more triggers to maintain symmetry in friend relationships. Specifically, if (A,B) is deleted from Friend, then (B,A) should be deleted too. If (A,B) is inserted into Friend then (B,A) should be inserted too */

create trigger FriendSymmetryInsert
after insert on friend
begin
    insert into friend
    select id2,id1
    from friend
    where id1 = new.id1 and id2 = new.id2;
end;

create trigger FriendSymmetryDelete
after delete on friend
begin
    delete from friend
    where id1=old.id2 and id2 = old.id1;
end;


/* Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12 */

create trigger DeleteGraduates
after update of grade on highschooler
when new.grade > 12
begin
    delete from highschooler
    where id = new.id;
 end;


/* Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12 (same as Question 4). In addition, write a trigger so when a student is moved ahead one grade, then so are all of his or her friends */

/*
create trigger DeleteGraduates
after update of grade on highschooler
when new.grade > 12
begin
    delete from highschooler
    where id = new.id;
end;
*/

create trigger MoveAheadFriends
after update of grade on highschooler
when new.grade=old.grade+1
begin
     update highschooler
     set grade = grade+1
     where id in (select id2 from friend where id1 = new.id);
end;


/* Write a trigger to enforce the following behavior: If A liked B but is updated to A liking C instead, and B and C were friends, make B and C no longer friends. */

create trigger UpdateFriendship
after update of id2 on likes
when old.id1=new.id1 and exists (select id2 from friend where id1 = new.id2 and id2=old.id2)
begin
    delete from friend
    where (id1=old.id2 and id2=new.id2) or (id1=new.id2 and id2=old.id2);
end;


