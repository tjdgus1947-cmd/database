-- ============================================================
-- 08. Subquery (Single-row / Multi-row / Multi-column)
-- 교안: 03_DataBase_SQL_Advanced (MySQL 8.4 LTS 기준)
-- ============================================================

-- world DB 사용 (조회만 수행, 데이터 변경 없음)
USE world; 

-- ------------------------------------------------------------
-- Single-row Subquery (단일 행 서브쿼리)
-- ------------------------------------------------------------
-- Single-row Subquery 활용 1
-- 'North America' 대륙의 평균 인구 (서브쿼리 단독 실행 확인)
SELECT AVG(Population) FROM country WHERE Continent = 'North America';

-- 'North America' 대륙의 평균 인구보다 인구가 많은 국가의 이름과 인구 조회
SELECT 
  Name, Population
FROM 
  country
WHERE 
  Population > (
    SELECT AVG(Population) 
    FROM country
    WHERE Continent = 'North America'
  );

-- [에러 발생 예시] 집계 함수를 사용하지 않으면 다중 행이 반환되어 에러 발생
--   (Error 1242: Subquery returns more than 1 row)
-- SELECT 
--   Name, Population
-- FROM 
--   country
-- WHERE 
--   Population > (
--     SELECT Population
--     FROM country
--     WHERE Continent = 'North America'
--   );


-- Single-row Subquery 활용 2
-- country 테이블의 'Benin' 이라는 국가의 국가 코드 (서브쿼리 단독 실행 확인)
SELECT Code FROM country WHERE Name = 'Benin';

-- country 테이블의 'Benin' 이라는 국가의 국가 코드를 이용하여,
-- city 테이블에 등록된 'Benin'의 모든 도시 정보를 조회
SELECT
  * 
FROM 
  city
WHERE 
  CountryCode = (
    SELECT Code
    FROM country
    WHERE Name = 'Benin'
  );


-- Single-row Subquery 활용 3
-- country 테이블의 각 국가마다 해당 국가 소속의 평균 도시 인구를 city 테이블을 이용하여 조회
-- (아래 서브쿼리는 단독으로는 country 정보를 얻을 수 없으므로 실행 불가)
-- SELECT AVG(city.Population) FROM city WHERE city.CountryCode = country.Code;

-- 메인 쿼리의 country 테이블 정보를 활용하여 서브쿼리에서 평균 값 1개를 반환 (SELECT 절 스칼라 서브쿼리)
SELECT 
  Name AS country_name,
  (
    SELECT AVG(Population) 
    FROM city 
    WHERE CountryCode = Code
  ) AS avg_city_population
FROM country;

-- 어떤 테이블의 컬럼을 사용하는지 테이블 명을 붙여주는 것이 가독성이 좋음
SELECT 
  country.Name AS country_name,
  (
    SELECT AVG(city.Population) 
    FROM city 
    WHERE city.CountryCode = country.Code
  ) AS avg_city_population
FROM country;

-- 참고) 위 쿼리는 국가마다 서브쿼리가 반복 실행되므로 국가가 많을수록 부담이 커짐
--       JOIN + GROUP BY 로 작성하는 것이 더 효율적
-- SELECT 
--   country.Name AS country_name,
--   AVG(city.Population) AS avg_city_population
-- FROM 
--   country
-- JOIN 
--   city ON country.Code = city.CountryCode
-- GROUP BY 
--   country.Name;


-- ------------------------------------------------------------
-- Multi-row Subquery (다중 행 서브쿼리)
-- ------------------------------------------------------------
-- Multi-row Subquery 활용 1
-- 대륙 정보가 Asia인 국가의 코드 (서브쿼리 단독 실행 확인)
SELECT Code FROM country WHERE Continent = 'Asia';

-- Asia 에 속하는 모든 도시를 조회
SELECT * 
FROM city
WHERE 
  CountryCode IN (
    SELECT Code
    FROM country
    WHERE Continent = 'Asia'
  );

-- [에러 발생 예시] 다중 행 서브쿼리에 비교 연산자를 사용하면 에러 발생
--   (Error 1242: Subquery returns more than 1 row)
-- SELECT * 
-- FROM city
-- WHERE 
--   CountryCode = (
--     SELECT Code
--     FROM country
--     WHERE Continent = 'Asia'
--   );


-- Multi-row Subquery 활용 2 (FROM 절 Subquery 활용)
-- 인구가 10,000,000명 이상인 국가들의 국가 코드 (서브쿼리 단독 실행 확인)
SELECT Code FROM country WHERE Population >= 10000000;

-- 인구가 10,000,000명 이상인 국가들의 국가 코드, 도시 이름, 지구, 인구를 조회
SELECT co.Code, c.Name, c.District, c.Population
FROM 
  city c
  JOIN (SELECT Code
        FROM country
        WHERE Population >= 10000000) co
ON c.CountryCode = co.Code;


-- ------------------------------------------------------------
-- Multi-column Subquery (다중 컬럼 서브쿼리)
-- ------------------------------------------------------------
-- Multi-column Subquery 활용 1
-- 각 대륙별 가장 최근 독립 연도 (서브쿼리 단독 실행 확인)
SELECT Continent, MAX(IndepYear)
FROM country
GROUP BY Continent;

-- 각 대륙별 독립 연도가 최근인 국가의 이름, 대륙, 독립 연도를 조회
--   (a, b) IN (...) 은 여러 행 허용
SELECT
  Name, Continent, IndepYear
FROM country
WHERE (Continent, IndepYear) IN (
    SELECT Continent, MAX(IndepYear)
    FROM country
    GROUP BY Continent
);


-- Multi-column Subquery 활용 2
-- Africa에서 가장 땅이 넓은 국가의 이름, 대륙, 면적을 조회
--   (a, b) = (...) 비교는 최대 한 행만 허용
SELECT 
  Name, Continent, SurfaceArea
FROM country
WHERE (Continent, SurfaceArea) = (
    SELECT Continent, MAX(SurfaceArea)
    FROM country
    GROUP BY Continent
    HAVING Continent = 'Africa'
);
