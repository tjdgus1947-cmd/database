-- ============================================================
-- 09. Database Index & VIEW (참고)
-- 교안: 03_DataBase_SQL_Advanced (MySQL 8.4 LTS 기준)
-- ============================================================
-- [주의] 이 파일은 world DB 의 city 테이블에 인덱스를, world DB 에 VIEW 를 "추가했다가 삭제"합니다.
--        파일 끝의 삭제 구문까지 실행하면 world DB 는 원래 상태로 돌아갑니다.
--        world DB 를 전혀 건드리고 싶다면 아래 "대체 방안" 블록을 사용하세요.
--
-- [대체 방안] world DB 대신 db_adv 에 city / country 복사본을 만들어 실습
--   USE db_adv;
--   CREATE TABLE country LIKE world.country;
--   INSERT INTO country SELECT * FROM world.country;
--   CREATE TABLE city LIKE world.city;      -- 인덱스(PRIMARY KEY, KEY CountryCode)는 복사되지만 FK 제약은 복사되지 않음
--   INSERT INTO city SELECT * FROM world.city;
--   (이후 실습 코드는 동일하게 실행 가능, SHOW CREATE TABLE 결과에서 CONSTRAINT 행만 표시되지 않음)

USE world;


-- ------------------------------------------------------------
-- Index 생성하기 (테이블 생성 시 정의) - 문법 참고용 (실행하지 않음)
-- ------------------------------------------------------------
-- CREATE TABLE table_name (
--   column1 INT PRIMARY KEY AUTO_INCREMENT,
--   column2 VARCHAR(150) DEFAULT NULL,
--   column3 VARCHAR(30),
--   -- INDEX 생성하기 1 (INDEX 키워드 사용)
--   INDEX index_name (column2),
--   -- INDEX 생성하기 2 (KEY 키워드 사용)
--   KEY index_name2 (column3)
-- );
-- 어떤 컬럼을 인덱스로 설정하는 것이 좋을까? -> 자주 검색되는 컬럼, 중복되는 데이터가 적은 컬럼


-- ------------------------------------------------------------
-- Index 추가하기
-- ------------------------------------------------------------
-- Index 추가하기 1: CREATE INDEX 구문
--   CREATE INDEX index_name
--   ON table_name (column1, column2, ...);

-- 실습: city 테이블의 Name 컬럼에 idx_city_name 인덱스 추가
CREATE INDEX idx_city_name
ON city (Name);

-- Index 추가하기 2: ALTER TABLE 구문 (동일한 결과, 문법 참고용)
--   ALTER TABLE table_name
--   ADD INDEX index_name (column1, column2, ...);


-- ------------------------------------------------------------
-- Index 사용하기
-- ------------------------------------------------------------
-- city 테이블의 인덱스 확인
-- (CountryCode 는 world DB 기본 제공 인덱스, idx_city_name 은 위에서 추가한 인덱스)
SHOW CREATE TABLE city;
-- CREATE TABLE `city` (
--   `ID` int NOT NULL AUTO_INCREMENT,
--   `Name` char(35) NOT NULL DEFAULT '',
--   `CountryCode` char(3) NOT NULL DEFAULT '',
--   `District` char(20) NOT NULL DEFAULT '',
--   `Population` int NOT NULL DEFAULT '0',
--   PRIMARY KEY (`ID`),
--   KEY `CountryCode` (`CountryCode`),
--   KEY `idx_city_name` (`Name`),
--   CONSTRAINT `city_ibfk_1` FOREIGN KEY (`CountryCode`) REFERENCES `country` (`Code`)
-- ) ENGINE=InnoDB AUTO_INCREMENT=4080 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

SHOW INDEX FROM city;

-- Index 사용하기 1: WHERE 절에서 사용
-- 기존 WHERE 절 사용하는 것과 동일, 내부적으로 INDEX 를 통해 빠르게 데이터 접근
SELECT * FROM city
WHERE Name = 'Seoul';

-- Index 사용하기 2: ORDER BY 에서 사용
-- Name 컬럼에 인덱스가 있어 정렬도 효과적으로 수행됨
SELECT * FROM city
ORDER BY Name;

-- Index 사용하기 3: JOIN 에서 사용
-- city 테이블의 CountryCode 컬럼이 인덱스로 설정되어 있어 JOIN 실행 시 빠르게 수행됨
SELECT city.Name, country.Name 
FROM city
JOIN country ON city.CountryCode = country.Code
WHERE city.Name = 'Seoul';

-- 참고) 인덱스가 실제로 사용되는지는 실행 계획(EXPLAIN)으로 확인
--       key 컬럼에 idx_city_name 이 표시되면 인덱스를 사용한 것
EXPLAIN SELECT * FROM city
WHERE Name = 'Seoul';


-- ------------------------------------------------------------
-- Index 삭제하기
-- ------------------------------------------------------------
-- Index 삭제하기 1: ALTER TABLE 구문 (문법 참고용)
--   ALTER TABLE table_name
--   DROP INDEX index_name;

-- Index 삭제하기 2: DROP INDEX 구문
--   DROP INDEX index_name
--   ON table_name;

-- 실습: 위에서 추가한 idx_city_name 인덱스 삭제 (world DB 원상 복구)
DROP INDEX idx_city_name
ON city;

-- 삭제 확인 (KEY `idx_city_name` 행이 사라짐)
SHOW CREATE TABLE city;


-- ============================================================
-- 참고: VIEW
-- ============================================================
-- VIEW 생성 문법
--   CREATE VIEW view_name AS select_statement;

-- VIEW 활용 1
-- 국가 코드와 이름을 v_simple_country 라는 이름의 view로 생성
CREATE VIEW v_simple_country AS
SELECT Code, Name
FROM country;

-- 생성한 view_name 으로 뷰를 조회
SELECT *
FROM v_simple_country;

-- VIEW 활용 2
-- 각 국가별 가장 인구가 많은 도시를 조인한 뷰를 v_largest_city_per_country 라는 이름의 view로 생성
-- (공동 1위 도시는 모두 반환)
CREATE VIEW v_largest_city_per_country AS
SELECT 
  c.Name AS country_name, 
  c.Continent AS Continent,
  ci.Name AS largest_city, 
  ci.Population AS city_population,
  c.Population AS country_population
FROM country c
JOIN city ci ON c.Code = ci.CountryCode
WHERE (ci.CountryCode, ci.Population) IN (
    SELECT CountryCode, MAX(Population)
    FROM city
    GROUP BY CountryCode
);

SELECT * FROM v_largest_city_per_country;

-- VIEW 활용 3
-- v_largest_city_per_country 뷰를 이용하여
-- Asia 국가별 최대 도시 중 인구가 가장 작은 도시보다 인구가 많은 도시 수 조회
SELECT COUNT(*) AS count_city
FROM v_largest_city_per_country
WHERE Continent = 'Asia'
  AND city_population > (
    SELECT MIN(city_population)
    FROM v_largest_city_per_country
    WHERE Continent = 'Asia'
  );

-- VIEW 삭제하기 (world DB 원상 복구)
DROP VIEW v_simple_country;
DROP VIEW v_largest_city_per_country;

-- 참고) 실습 종료 후 db_intro, db_adv 를 정리하려면
-- DROP DATABASE db_intro;
-- DROP DATABASE db_adv;
