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

/*ИСПР. все исполнители, которые не выпустили альбомы в 2020 году;*/
SELECT DISTINCT performers.name  FROM performers
LEFT JOIN albumsofperformers ON albumsofperformers.performer_id = performers.id
LEFT JOIN albums ON albumsofperformers.albums_id = albums.id
WHERE albumsofperformers.albums_id NOT IN (SELECT albums.id FROM albums WHERE albums.yearofrelease = 2020) 
	OR albumsofperformers.albums_id IS NULL 

/*ИСПР. названия сборников, в которых присутствует конкретный исполнитель (выберите сами);*/
SELECT DISTINCT collections.name FROM tracksincollection
LEFT JOIN collections ON tracksincollection.collections_id = collections.id 
LEFT JOIN tracks ON tracksincollection.track_id = collections.id 
LEFT JOIN albumsofperformers ON tracks.album_id = albumsofperformers.albums_id 
LEFT JOIN performers ON albumsofperformers.performer_id = performers.id 
WHERE performers.name = 'Майкл Джексон'

/*ИСПР. название альбомов, в которых присутствуют исполнители более 1 жанра;*/
SELECT albums.name,COUNT(genre_id) FROM albumsofperformers
LEFT JOIN albums ON albumsofperformers.albums_id = albums.id
LEFT JOIN genresofperformers ON albumsofperformers.performer_id = genresofperformers.performer_id 
GROUP BY albums.name
HAVING COUNT(genre_id)>1

/*наименование треков, которые не входят в сборники;*/
SELECT tracks.name FROM tracks
WHERE tracks.id NOT IN (SELECT track_id FROM tracksincollection) 

/*ИСПР. исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);*/
SELECT DISTINCT performers.name FROM tracks
LEFT JOIN albumsofperformers ON tracks.album_id = albumsofperformers.albums_id 
LEFT JOIN performers ON albumsofperformers.performer_id = performers.id 
WHERE tracks.duration IN (SELECT Min(tracks.duration) FROM tracks)

/*ИСПР. название альбомов, содержащих наименьшее количество треков.*/
SELECT albums.name FROM tracks
LEFT JOIN albums ON tracks.album_id = albums.id 
GROUP BY albums.name
HAVING count(tracks.album_id) = (
	SELECT count(tracks.album_id) AS cnt FROM tracks
	GROUP BY tracks.album_id
	ORDER BY count(tracks.album_id)
	LIMIT 1
	)








