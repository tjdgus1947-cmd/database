-- ============================================================
-- 06. Sorting data (ORDER BY / LIMIT) & Grouping data (집계 함수 / GROUP BY)
-- 교안: 02_DataBase_Basic_SQL (MySQL 8.4 LTS 기준)
-- ============================================================

USE world;

-- ------------------------------------------------------------
-- ORDER BY
-- ------------------------------------------------------------
-- ORDER BY 활용 1
-- 테이블 country에서 GovernmentForm 필드의 모든 데이터를 오름차순으로 조회
SELECT 
  GovernmentForm
FROM 
  country
ORDER BY
  GovernmentForm;

-- ORDER BY 활용 2
-- 테이블 country에서 GovernmentForm 필드의 모든 데이터를 내림차순으로 조회
SELECT 
  GovernmentForm
FROM 
  country
ORDER BY
  GovernmentForm DESC;

-- ORDER BY 활용 3
-- 테이블 country에서 GovernmentForm 필드를 기준으로 내림차순 정렬한 다음
-- SurfaceArea 필드 기준으로 오름차순 정렬하여 조회
SELECT 
  GovernmentForm, SurfaceArea
FROM 
  country
ORDER BY
  GovernmentForm DESC, SurfaceArea ASC;

-- 정렬에서의 NULL
-- NULL 값이 존재할 경우 오름차순 정렬 시 결과에 NULL이 먼저 출력
--   (MySQL 에서 NULL 은 모든 값보다 작은 것으로 취급)
SELECT 
  IndepYear
FROM
  country
ORDER BY
  IndepYear;

-- ORDER BY 활용 4
-- 테이블 country에서 Continent 필드가 'Asia' 인 데이터 중에
-- IndepYear 기준으로 오름차순 정렬한 다음 Name, IndepYear 필드의 모든 데이터를 조회
SELECT
  Name, IndepYear
FROM
  country
WHERE
  Continent = 'Asia'
ORDER BY 
  IndepYear;

-- ORDER BY 활용 5
-- 테이블 country에서 Continent 필드가 'Asia' 인 데이터 중에
-- IndepYear 기준으로 오름차순 정렬할 때 NULL 데이터는 마지막에 위치하도록
-- Name, IndepYear 필드의 모든 데이터를 조회
--   IndepYear IS NULL 의 결과: NULL 이면 1(TRUE), 아니면 0(FALSE)
--   -> 0(NULL 이 아닌 데이터)이 먼저 오고, 그 안에서 IndepYear 오름차순 정렬
SELECT
  Name, IndepYear
FROM
  country
WHERE
  Continent = 'Asia'
ORDER BY 
  IndepYear IS NULL, IndepYear;


-- ------------------------------------------------------------
-- LIMIT
-- ------------------------------------------------------------
-- LIMIT 활용 1
-- 테이블 country에서 IndepYear, Name, Population 필드 데이터를
-- Population 기준 내림차순으로 7개만 조회
SELECT 
  IndepYear, Name, Population
FROM 
  country
ORDER BY 
  Population DESC
LIMIT 7;

-- LIMIT 활용 2
-- 테이블 country에서 IndepYear, Name, Population 필드 데이터를
-- Population 기준 내림차순으로 5번째부터 11번째 데이터만 조회
SELECT 
  IndepYear, Name, Population
FROM 
  country
ORDER BY 
  Population DESC
LIMIT 4, 7;
-- LIMIT 7 OFFSET 4;


-- ------------------------------------------------------------
-- Aggregate Function (집계 함수)
-- ------------------------------------------------------------
-- 집계 함수 1
-- COUNT(*) : NULL 값을 포함한 행의 수 / COUNT(expr) : NULL 값을 제외한 행의 수
SELECT COUNT(*) 
FROM country;

SELECT COUNT(IndepYear) 
FROM country;

-- 집계 함수 2
-- SUM(expr) : NULL 값을 제외한 합계 / AVG(expr) : NULL 값을 제외한 평균
SELECT SUM(GNP) FROM country
WHERE Continent = 'Asia';

SELECT AVG(GNP) FROM country
WHERE Continent = 'Asia';

-- 집계 함수 3
-- MAX(expr) : NULL 값을 제외한 최대값 / MIN(expr) : NULL 값을 제외한 최소값
SELECT MAX(GNP) FROM country
WHERE Continent = 'Asia';

SELECT MIN(GNP) FROM country
WHERE Continent = 'Asia';

-- 집계 함수 4
-- STDDEV(expr) : NULL 제외 모집단 표준편차 / VARIANCE(expr) : NULL 제외 모집단 분산
-- (표본: STDDEV_SAMP(expr), VAR_SAMP(expr))
SELECT STDDEV(GNP) FROM country
WHERE Continent = 'Asia';

SELECT VARIANCE(GNP) FROM country
WHERE Continent = 'Asia';


-- ------------------------------------------------------------
-- GROUP BY
-- ------------------------------------------------------------
-- GROUP BY 예시 (1/2)
-- 1. Continent 필드를 그룹화
SELECT
  Continent
FROM
  country
GROUP BY
  Continent;

-- GROUP BY 예시 (2/2)
-- 2. COUNT 함수가 각 그룹에 대한 집계된 값을 계산
SELECT
  Continent, COUNT(*)
FROM
  country
GROUP BY
  Continent;

-- GROUP BY 활용 1
-- 테이블 country 에서 Continent 필드를 그룹화하여
-- 각 그룹에 대한 GNP의 평균 값을 소수점 2자리로 반올림하여 조회 하고 컬럼 이름을 avg_gnp로 변경
SELECT
  Continent, 
  ROUND(AVG(GNP), 2) AS avg_gnp
FROM
  country
GROUP BY
  Continent;

-- GROUP BY 활용 2
-- 테이블 country 에서 Region 필드를 그룹화하여
-- 각 그룹에 대한 개수가 15 이상 20 이하인 데이터를 내림차순으로 조회

-- [에러 발생 예시]
-- WHERE 단계에서는 집계 결과와 SELECT 별칭 count_reg 를 사용할 수 없음
-- (Error 1054: Unknown column 'count_reg' in 'where clause')
SELECT
  Region,
  COUNT(Region) AS count_reg
FROM
  country
WHERE
  count_reg BETWEEN 15 AND 20 
GROUP BY
  Region
ORDER BY 
  count_reg DESC;

-- HAVING clause: 집계 항목에 대한 세부 조건을 지정 (그룹화·집계 이후 조건을 적용)
SELECT
  Region,
  COUNT(Region) AS count_reg
FROM
  country
GROUP BY
  Region
HAVING
  count_reg BETWEEN 15 AND 20
ORDER BY 
  count_reg DESC;


-- SELECT statement 논리적 처리 순서
--   FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT
