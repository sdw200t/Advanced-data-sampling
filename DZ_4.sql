/*количество исполнителей в каждом жанре;*/
SELECT genres.name, COUNT(*) FROM genresofperformers
LEFT JOIN genres ON genresofperformers.genre_id = genres.id 
GROUP BY genres.name

/*количество треков, вошедших в альбомы 2019-2020 годов;*/
SELECT COUNT(*) FROM tracks
LEFT JOIN albums ON tracks.album_id = albums.id 
WHERE albums.yearofrelease BETWEEN 2019 AND 2020

/*средняя продолжительность треков по каждому альбому;*/
SELECT albums.name, AVG(duration) FROM tracks
LEFT JOIN albums ON tracks.album_id = albums.id
GROUP BY albums.name

/*все исполнители, которые не выпустили альбомы в 2020 году;*/
SELECT performers.name  FROM performers
LEFT JOIN albumsofperformers ON albumsofperformers.performer_id = performers.id
LEFT JOIN albums ON albumsofperformers.albums_id = albums.id
WHERE albumsofperformers.albums_id != (SELECT albums.id FROM albums WHERE albums.yearofrelease = 2020) 
	OR albumsofperformers.albums_id IS NULL 
GROUP BY performers.name

/*названия сборников, в которых присутствует конкретный исполнитель (выберите сами);*/
SELECT collections.name FROM tracksincollection
LEFT JOIN collections ON tracksincollection.collections_id = collections.id 
LEFT JOIN tracks ON tracksincollection.track_id = collections.id 
LEFT JOIN albumsofperformers ON tracks.album_id = albumsofperformers.albums_id 
LEFT JOIN performers ON albumsofperformers.performer_id = performers.id 
WHERE performers.name = 'Майкл Джексон'
GROUP BY collections.name

/*название альбомов, в которых присутствуют исполнители более 1 жанра;*/
SELECT albums.name FROM albumsofperformers
LEFT JOIN albums ON albumsofperformers.albums_id = albums.id
WHERE albumsofperformers.performer_id in (SELECT performer_id FROM genresofperformers GROUP BY performer_id HAVING COUNT(genre_id)>1)
GROUP BY albums.name

/*наименование треков, которые не входят в сборники;*/
SELECT tracks.name FROM tracks
WHERE tracks.id NOT IN (SELECT track_id FROM tracksincollection) 

/*исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);*/
SELECT performers.name FROM tracks
LEFT JOIN albumsofperformers ON tracks.album_id = albumsofperformers.albums_id 
LEFT JOIN performers ON albumsofperformers.performer_id = performers.id 
WHERE tracks.duration IN (SELECT Min(tracks.duration) FROM tracks)
GROUP BY performers.name

/*название альбомов, содержащих наименьшее количество треков.*/
SELECT albums.name FROM tracks
LEFT JOIN albums ON tracks.album_id = albums.id 
GROUP BY albums.name
HAVING count(tracks.album_id) = (
	SELECT min(cnt) from(
		SELECT count(tracks.album_id) AS cnt FROM tracks
		GROUP BY tracks.album_id
	) AS tbl)







