-- ============================================================
-- 02. DML (INSERT / UPDATE / DELETE)
-- 교안: 02_DataBase_Basic_SQL (MySQL 8.4 LTS 기준)
-- ============================================================

-- 실습용 데이터베이스 선택
-- (world, sakila 등 기본 제공 DB에 실습 테이블이 생성되지 않도록 반드시 실행)
USE db_intro;

-- 사전 준비: 실습 테이블 생성
CREATE TABLE articles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content VARCHAR(255) NOT NULL,
  created_at DATE NOT NULL
);


-- ------------------------------------------------------------
-- INSERT
-- ------------------------------------------------------------
-- INSERT 활용 1
-- articles 테이블에 데이터 입력
INSERT INTO articles (title, content, created_at)
VALUES ('title', 'content', '2024-06-05');

-- articles 테이블 전체 조회 (SELECT는 DQL 파트에서 학습, 확인용)
SELECT * FROM articles;

-- INSERT 활용 2
-- articles 테이블에 여러 데이터 추가 입력
INSERT INTO articles (title, content, created_at)
VALUES 
  ('title2', 'content3', '2024-06-05'),
  ('title3', 'content4', '2024-07-05'),
  ('title4', 'content5', '2024-08-05'),
  ('title5', 'content6', '2024-09-05');


-- INSERT 활용 3
-- CURDATE 함수를 사용해 현재 날짜로 데이터 추가 입력
-- (created_at 은 DATE 타입이므로 날짜만 반환하는 CURDATE() 사용)
-- https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html
INSERT INTO articles (title, content, created_at)
VALUES 
  ('title2', 'content3', now());


-- ------------------------------------------------------------
-- UPDATE
-- ------------------------------------------------------------
-- UPDATE 활용 1
-- articles 테이블 1번 레코드의 title 필드 값을 'update Title'로 변경
UPDATE articles
SET title = 'Title'
WHERE id = 1;


-- UPDATE 활용 2
-- articles 테이블 2번 레코드의 title, content 필드 값을
-- 각각 'update Title', 'update Content' 로 변경
UPDATE articles
SET
  title = 'title22222',
  content = 'content22222'
WHERE id = 2;

-- ------------------------------------------------------------
-- DELETE
-- ------------------------------------------------------------
-- DELETE 활용
-- articles 테이블의 1번 레코드 삭제
DELETE FROM articles
WHERE id = 1;


-- ------------------------------------------------------------
-- 참고: DDL 의 TRUNCATE TABLE 과 DML 의 DELETE 비교
-- ------------------------------------------------------------
-- DELETE 동작: AUTO_INCREMENT 값 유지 (id 가 초기화되지 않음)

DELETE FROM articles;

INSERT INTO 
  articles (title, content, created_at)
VALUES 
  ('hello', 'world', '2000-01-01');

SELECT * FROM articles;

-- TRUNCATE 동작: 테이블을 DROP 후 재생성하므로 AUTO_INCREMENT 값 초기화 (id 가 1부터 시작)
TRUNCATE TABLE articles;

INSERT INTO 
  articles (title, content, created_at)
VALUES 
  ('hello', 'world', '2000-01-01');

SELECT * FROM articles;