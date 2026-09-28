-- ============================================================
-- 05. MySQL Built-in Function (문자형 / 숫자형 / 날짜형 / NULL 관련)
-- 교안: 02_DataBase_Basic_SQL (MySQL 8.4 LTS 기준)
-- ============================================================

-- ------------------------------------------------------------
-- 문자형 함수
-- ------------------------------------------------------------
-- CONCAT(str1, str2, ...) : 인자로 들어오는 문자열을 하나로 연결
SELECT CONCAT('FirstName', '_', 'LastName');

-- TRIM([[BOTH | LEADING | TRAILING] remove_str FROM] target_str)
-- 왼쪽, 혹은 오른쪽의 특정 문자를 삭제 (remove_str 생략 시 공백 문자 삭제)
SELECT TRIM('   PHONE   ');
SELECT TRIM('-' FROM '---TITLE---');
SELECT TRIM(LEADING '-' FROM '---TITLE---');
SELECT TRIM(TRAILING '-' FROM '---TITLE---');

-- REPLACE(target_str, from_str, to_str) : 문자열 수정
SELECT REPLACE('$10000', '$', '￦');

-- LOCATE(sub_str, target_str [, pos])
-- 찾으려는 문자가 있다면 첫 번째 위치, 없으면 0 반환 / pos 를 작성하면 해당 위치부터 탐색
SELECT LOCATE('path', 'www.web-path-site.com/path/');
SELECT LOCATE('path', 'www.web-path-site.com/path/', 10);


-- ------------------------------------------------------------
-- 숫자형 함수
-- ------------------------------------------------------------
-- ABS(x) : 절대값
SELECT ABS(-12);

-- MOD(n, m) : 나머지 (n % m 도 동일)
SELECT MOD(10, 7);
SELECT 10 % 7;

-- POW(n, m) : n의 m승 (POWER 와 동일)
SELECT POW(2, 6);
SELECT POWER(2, 6);

-- CEIL(x) : x 이상인 가장 작은 정수
SELECT CEIL(3.3);
-- FLOOR(x) : x 이하인 가장 큰 정수
SELECT FLOOR(3.7);
-- ROUND(x[, d]) : 반올림 (d는 소수점 자리수)
SELECT ROUND(3.7);
SELECT ROUND(3.2);


-- ------------------------------------------------------------
-- 날짜형 함수
-- ------------------------------------------------------------
-- CURDATE() : 현재 날짜
SELECT CURDATE();
-- CURTIME() : 현재 시간
SELECT CURTIME();
-- NOW() : 현재 날짜와 시간
SELECT NOW();

-- DATE_FORMAT(date, format) : 날짜 정보를 원하는 format 형태로 변환
SELECT DATE_FORMAT
('2024-08-23 13:35:20', '%b-%d (%a) %r');


-- ------------------------------------------------------------
-- NULL 관련 함수
-- ------------------------------------------------------------
-- IFNULL(expr1, expr2) : expr1이 NULL 이면 expr2, 아니면 expr1 반환
SELECT IFNULL(NULL, 'expr1 is NULL');
SELECT IFNULL('expr1', 'expr1 is NULL');

-- 데이터베이스 변경
USE world;

-- IFNULL 함수 활용
-- 'North America'에 속한 국가 이름과 독립 연도를 조회하되, 독립 연도가 없으면 'no_data'로 출력
-- (숫자 컬럼과 문자열을 함께 반환하므로 CAST 로 타입을 문자열로 통일)
SELECT 
  Name, IFNULL(CAST(IndepYear AS CHAR), 'no_data') 
FROM 
  country
WHERE 
  Continent = 'North America'; 

-- NULLIF(expr1, expr2) : expr1이 expr2 와 동일하면 NULL, 아니면 expr1 반환
SELECT NULLIF('expr1', 'expr1');
SELECT NULLIF('expr1', 'expr2');

-- NULLIF 함수 활용
-- 모든 국가의 정보 중 인구가 0인 경우 NULL 로 표시되도록 조회
SELECT 
  Name, 
  NULLIF(Population, 0)
FROM country;

-- COALESCE(value1, value2, ..., valueN)
-- 첫 번째 인자부터 순서대로 확인하여 NULL 이 아닌 값을 반환 (모두 NULL 이면 NULL)
SELECT COALESCE('expr1', 'expr2', NULL);
SELECT COALESCE(NULL, 'expr2', NULL);
SELECT COALESCE(NULL, NULL, NULL);

-- COALESCE 함수 활용
-- 'Africa'에서 기대 수명이 70세 미만인 국가의 GNP 조회
-- GNP가 0 또는 NULL이면 GNPOld를, GNPOld도 NULL이면 'No data'를 출력
SELECT 
  Name,
  COALESCE(CAST(NULLIF(GNP, 0) AS CHAR), CAST(GNPOld AS CHAR), 'No data') AS gnp_data
FROM country
WHERE
  Continent = 'Africa'
  AND LifeExpectancy < 70;
