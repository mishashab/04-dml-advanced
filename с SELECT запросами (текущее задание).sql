--1.количество исполнителей в каждом жанре;

select g.gengre_name, count(singer_id) from singersgenres sg
left join genres g on g.genre_id = sg.genre_id
group by g.gengre_name;


--2.количество треков, вошедших в альбомы 2019-2020 годов;
select count(*) Количество from songs s
left join albums a on s.album = a.album_id
where DATE_PART('year', a.album_year_of_issue::date) between 2019 and 2020;

--3.средняя продолжительность треков по каждому альбому;

select a.album_name , avg(s.song_duration) from songs s
left join albums a on s.album = a.album_id
group by a.album_name;

--4.все исполнители, которые не выпустили альбомы в 2020 году;

select s.singer_name from albums a 
left join singersalbums sa on sa.album_id = a.album_id
left join singers s on s.singer_id = sa.singer_id 
where not DATE_PART('year', a.album_year_of_issue::date) = 2020
group by s.singer_name;

--5.названия сборников, в которых присутствует конкретный исполнитель (выберите сами);

select distinct collection_name from collections c
left join collectionssongs cs on cs.collection_id = c.collection_id 
left join songs s on cs.song_id = s.song_id 
left join albums a on s.album = a.album_id 
left join singersalbums sa on a.album_id = sa.album_id 
left join singers s2 on s2.singer_id = sa.singer_id
where s2.singer_name like 'Kanye West';

-- 6. название альбомов, в которых присутствуют исполнители более 1 жанра;

select sg.singer_id, count(sg.genre_id) from albums a 
left join singersalbums sa on a.album_id = sa.album_id 
left join singers s on s.singer_id = sa.singer_id
left join singersgenres sg on sg.singer_id = s.singer_id 
group by sg.singer_id;

select a.album_name  from albums a
left join singersalbums sa on sa.album_id = a.album_id 
left join singers s on s.singer_id = sa.singer_id 
left join singersgenres sg on sg.singer_id = s.singer_id 
left join genres g on g.genre_id = sg.genre_id 
group by a.album_name 
having count(distinct g.gengre_name) > 1;

--7. наименование треков, которые не входят в сборники;
select s.song_name, c.collection_id  from songs s 
left join collectionssongs c on c.song_id = s.song_id 
where c.collection_id is null;

--8. исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);
-- select min(song_duration) from songs s

select s2.singer_name from songs s
left join albums a on s.album = a.album_id 
left join singersalbums sa on a.album_id = sa.album_id 
left join singers s2 on s2.singer_id = sa.singer_id
where s.song_duration = (select min(song_duration) from songs s
);

--9. название альбомов, содержащих наименьшее количество треков.
select a.album_name, count(*) from albums a
left join songs s on s.album = a.album_id 
group by a.album_name
having count(*) = 
				(select count(*) from albums a
				left join songs s on s.album = a.album_id 
				group by a.album_name
				order by count(*) 
				limit 1);