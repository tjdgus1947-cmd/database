-- ============================================================
-- 07. JOIN (INNER / LEFT / RIGHT / SELF)
-- 교안: 03_DataBase_SQL_Advanced (MySQL 8.4 LTS 기준)
-- ============================================================

-- ------------------------------------------------------------
-- 사전 준비 (1/5): db_adv 데이터베이스 생성 및 연결
-- ------------------------------------------------------------
CREATE DATABASE db_adv
  DEFAULT CHARACTER SET 'utf8mb4';
USE db_adv;

-- 사전 준비 (2/5): users 테이블 생성
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  age INTEGER,
  parent_id INTEGER,
  FOREIGN KEY (parent_id) REFERENCES users(id)
);

-- 사전 준비 (3/5): users 실습 데이터 입력
INSERT INTO 
  users (name, age, parent_id)
VALUES 
  ('하석주', 50, NULL),
  ('정윤미', 48, NULL),
  ('유하선', 46, NULL),
  ('하민성', 24, 1),
  ('정아인', 22, 2),
  ('송민', 19, 1),
  ('정지민', 22, 2);

-- 사전 준비 (4/5): articles 테이블 생성
CREATE TABLE articles (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(50) NOT NULL,
  content VARCHAR(100) NOT NULL,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 사전 준비 (5/5): articles 실습 데이터 입력
INSERT INTO
  articles (title, content, user_id)
VALUES 
  ('제목1', '내용1', 1),
  ('제목2', '내용2', 2),
  ('제목3', '내용3', NULL),
  ('제목4', '내용4', 3),
  ('제목5', '내용5', 1),
  ('제목6', '내용6', NULL),
  ('제목7', '내용7', 5);

SELECT * FROM users;
SELECT * FROM articles;
-- -- 사전 준비 끝 --


-- ------------------------------------------------------------
-- INNER JOIN
-- ------------------------------------------------------------
-- INNER JOIN 예시
-- 작성자가 있는 (존재하는 회원) 모든 게시글을 작성자 정보와 함께 조회
SELECT articles.*, users.id, users.name FROM articles
INNER JOIN users 
  ON users.id = articles.user_id;

-- 참고) INNER JOIN 은 ON 조건을 만족하는 행 조합만 반환하므로 메인 테이블이 달라져도 결과는 동일
--   단, 메인 테이블을 기준으로 조회하므로 조회 순서가 달라질 수 있음에 유의
SELECT articles.*, users.id, users.name FROM users
INNER JOIN articles 
  ON users.id = articles.user_id;

-- INNER JOIN 활용 1
-- 1번 회원(하석주)가 작성한 모든 게시글의 제목과 작성자명을 조회
SELECT articles.title, users.name
FROM articles
INNER JOIN users 
  ON users.id = articles.user_id
WHERE users.id = 1;


-- ------------------------------------------------------------
-- LEFT JOIN
-- ------------------------------------------------------------
-- LEFT JOIN 예시
-- 모든 게시글을 작성자 정보와 함께 조회
-- (왼쪽 테이블의 모든 레코드를 표기, 오른쪽 테이블과 매칭되는 레코드가 없으면 NULL)
SELECT articles.*, users.id, users.name FROM articles
LEFT JOIN users 
  ON users.id = articles.user_id;

-- LEFT JOIN 활용 1
-- 게시글을 작성한 이력이 없는 회원의 name 조회
SELECT users.name
FROM users
LEFT JOIN articles 
  ON articles.user_id = users.id
WHERE articles.id IS NULL;


-- ------------------------------------------------------------
-- RIGHT JOIN
-- ------------------------------------------------------------
-- RIGHT JOIN 예시
-- 모든 사용자가 작성한 글을 조회 (오른쪽 테이블 users 의 모든 레코드 반환)
SELECT articles.*, users.id, users.name FROM articles
RIGHT JOIN users 
  ON users.id = articles.user_id;

-- 참고) MySQL 은 RIGHT JOIN 을 동등한 LEFT JOIN 으로 변환하여 처리
-- SELECT articles.*, users.id, users.name FROM users
-- LEFT JOIN articles
--   ON users.id = articles.user_id;


-- ------------------------------------------------------------
-- SELF JOIN
-- ------------------------------------------------------------
-- SELF JOIN 예시
-- users 테이블의 부모 자식 관계 조회
SELECT 
  parent.id AS p_id, 
  parent.name AS parent, 
  child.id AS c_id, 
  child.name AS child
FROM 
  users parent
INNER JOIN users child 
  ON parent.id = child.parent_id;

-- 참고) 별칭으로 테이블을 구분하지 않으면 Error 발생 (Not unique table/alias: 'users')
-- SELECT 
--   users.id AS p_id, 
--   users.name AS parent, 
--   users.id AS c_id, 
--   users.name AS child
-- FROM 
--   users
-- JOIN 
--   users ON users.id = users.parent_id;

-- SELF JOIN 활용 1
-- 서로의 형제자매가 누구인지 id와 이름 조회
--   (users.id < sibling.id 조건으로 자기 자신 제외 + 같은 쌍의 중복 제거)
SELECT 
  users.id AS user_id, 
  users.name AS user_name, 
  sibling.id AS sibling_id, 
  sibling.name AS sibling_name
FROM 
  users
JOIN 
  users sibling ON users.parent_id = sibling.parent_id
WHERE 
  users.id < sibling.id;
