/* Works in SQLite */

/* Read Schema and Data */
.read viewmovie.sql


/* Write an instead-of trigger that enables simultaneous updates to attributes mID, title, and/or stars in view LateRating. Make sure the ratingDate attribute of view LateRating has not also been updated -- if it has been updated, don't make any changes. */

create trigger LateRatingUpdate
instead of update on LateRating
when old.ratingDate=new.ratingDate
begin
    update movie
    set mID=new.mID, title=new.title
    where mID=old.mID and title=old.title;
    
    update rating
    set stars=new.stars
    where mID=old.mID and stars=old.stars and ratingDate=new.ratingDate;
    
    update rating
    set mID=new.mID
    where mID=old.mID;
end;


/* Write an instead-of trigger that enables deletions from view HighlyRated. */

create trigger HighlyRatedDelete
instead of delete on HighlyRated
begin
    delete from Rating
    where mID=old.mID and stars>3;
end;


/* Write an instead-of trigger that enables deletions from view HighlyRated. 
Policy: Deletions from view HighlyRated should update all ratings for the corresponding movie that have stars > 3 so they have stars = 3. */

create trigger HighlyRateDeleteUpdate
instead of delete on HighlyRated
begin
    update Rating
    set stars=3
    where mID=old.mID and stars>3;
end;


/* Write an instead-of trigger that enables insertions into view HighlyRated. 
Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie table. (Otherwise, do nothing.) Insertions into view HighlyRated should add a new rating for the inserted movie with rID = 201, stars = 5, and NULL ratingDate. */

create trigger HighlyRatedInsert
instead of insert on HighlyRated
when exists (select mID,title from Movie where mID=new.mID and title=new.title)
begin
    insert into Rating values (201,new.mID,5,NULL);
end;


/* Write an instead-of trigger that enables insertions into view NoRating. 
Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie table. (Otherwise, do nothing.) Insertions into view NoRating should delete all ratings for the corresponding movie. */

create trigger NoRatingInsert
instead of insert on NoRating
when exists (select * from movie where mid=new.mid and title=new.title)
begin
    delete from Rating
    where mID=new.mID;
end;


/* Write an instead-of trigger that enables deletions from view NoRating. 
Policy: Deletions from view NoRating should delete the corresponding movie from the Movie table. */

create trigger NoRatingDelete
instead of delete on NoRating
for each row
begin
    delete from Movie
    where mID=old.mID and title=old.title;
end;


/* Write an instead-of trigger that enables deletions from view NoRating. 
Policy: Deletions from view NoRating should add a new rating for the deleted movie with rID = 201, stars = 1, and NULL ratingDate. */

create trigger NoRatingDeleteAdd
instead of delete on NoRating
begin
    insert into rating values (201,old.mID,1,NULL);
end;

