-- ============================================================
-- 04. Database Operator (BETWEEN / IN / LIKE / IS / 우선순위)
-- 교안: 02_DataBase_Basic_SQL (MySQL 8.4 LTS 기준)
-- ============================================================


-- BETWEEN 연산자
-- 테이블 country 에서 Population 필드 값이 백만 이상 오백만 이하이고
-- GNPOld가 GNP 보다 큰 데이터의
-- Name, Region, Population 그리고 GNPOld와 GNP 차이를 GNP diff로 작성하여 조회
SELECT
  Name, Region, Population, 
  GNPOld - GNP AS 'GNP Diff' 
FROM 
  country
WHERE
  Population >= 1000000 AND Population <= 5000000
  -- Population BETWEEN 1000000 AND 5000000
  AND GNP < GNPOld;


-- IN Operator 활용
-- 테이블 country 에서 Continent 필드 값이
-- 'North America' 또는 'Asia' 인 데이터의 Code, Name, Continent 조회
SELECT
  Code, Name, Continent
FROM
  country
WHERE
  Continent IN ('North America', 'Asia');
-- WHERE
--   Continent = 'North America' OR Continent = 'Asia';


-- LIKE Operator 활용 1
-- 테이블 country에서 Name 필드 값이 'South'로 시작하는 데이터의
-- Name, Region, Population, GNP 조회


-- LIKE Operator 활용 2
-- 테이블 country에서 Name 필드 값이 'South'로 시작하고,
-- 'South' 뒤에 임의의 문자 6개가 이어지는 총 11자 데이터의
-- Name, Region, Population, GNP 조회 ('_' 는 단일 문자와 일치)



-- IS Operator
-- [잘못된 예시] NULL은 = 또는 != 연산자로 비교할 수 없음
--   NULL은 어떤 값과도 같지 않기 때문에 결과가 조회되지 않음
-- SELECT 
--   Name, GNPOld, IndepYear
-- FROM 
--   country
-- WHERE
--   GNPOld = NULL
--   AND IndepYear != NULL;

-- IS 연산자를 통해 NULL 인지 확인



-- 연산자 우선순위 관련 오동작 예시
-- 테이블 country에서 IndepYear가 1981이거나 1901 이고,
-- LifeExpectancy가 75 이하인 데이터의 Name, IndepYear, LifeExpectancy를 조회

-- Ver. Wrong 1
-- 정상적으로 동작하는 것 같지만... (데이터에 따라 우연히 맞는 것처럼 보일 수 있음)
SELECT 
  Name, IndepYear, LifeExpectancy
FROM 
  country
WHERE
  IndepYear = 1981 OR IndepYear = 1901 
  AND LifeExpectancy <= 75;

-- Ver. Wrong 2
-- AND의 우선순위가 OR보다 높기 때문에 예상과 다른 결과 발생
--   -> IndepYear = 1901 OR (IndepYear = 1981 AND LifeExpectancy <= 75) 로 해석됨
SELECT 
  Name, IndepYear, LifeExpectancy
FROM 
  country
WHERE
  IndepYear = 1901 OR IndepYear = 1981 
  AND LifeExpectancy <= 75;

-- Ver. Good
-- 실수하기 쉬운 논리 연산자의 경우 괄호를 사용하여 우선 순위 표시를 권장
SELECT 
  Name, IndepYear, LifeExpectancy
FROM 
  country
WHERE
  (IndepYear = 1901 OR IndepYear = 1981)
  AND LifeExpectancy <= 75;
