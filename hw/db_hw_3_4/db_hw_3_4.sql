USE library_db;

-- 인덱스 생성
CREATE INDEX idx_authors_name ON authors(name);
CREATE INDEX idx_genres_genre_name ON genres(genre_name);

-- 전체 조회 (INNER JOIN)
SELECT b.title AS book_title,
       a.name AS author_name,
       g.genre_name AS genre_name
FROM books b
INNER JOIN authors a ON b.author_id = a.id
INNER JOIN genres g ON b.genre_id = g.id;

-- 조건 조회: J.K. Rowling + Fantasy
SELECT b.title AS book_title,
       a.name AS author_name,
       g.genre_name AS genre_name
FROM books b
INNER JOIN authors a ON b.author_id = a.id
INNER JOIN genres g ON b.genre_id = g.id
WHERE a.name = 'J.K. Rowling'
  AND g.genre_name = 'Fantasy';