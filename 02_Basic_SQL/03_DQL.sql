-- ============================================================
-- 03. DQL (SELECT / Filtering data)
-- 교안: 02_DataBase_Basic_SQL (MySQL 8.4 LTS 기준)
-- ============================================================

-- 사전 준비: MySQL 설치 시 제공되는 world DB 사용 (조회만 수행, 데이터 변경 없음)
-- 참고) world 는 레거시 샘플 DB 라 컬럼명이 PascalCase (Name, CountryCode 등)
--       기존 스키마의 이름은 그대로 따르고, 새로 설계할 때는 snake_case 를 권장


-- ------------------------------------------------------------
-- SELECT
-- ------------------------------------------------------------
-- SELECT 활용 1
-- 테이블 country 에서 Name 필드의 모든 데이터를 조회


-- SELECT 활용 2
-- 테이블 country 에서 Code, Name 필드의 모든 데이터를 조회


-- SELECT 활용 3
-- 테이블 country 에서 모든 필드 데이터를 조회


-- SELECT 활용 4
-- 테이블 country 에서 Name 필드의 모든 데이터를 조회
-- (단, 조회 시 Name 이 아닌 '국가'로 출력될 수 있도록 변경)


-- SELECT 활용 5
-- 테이블 country에서 Name, Population 필드의 모든 데이터 조회
-- (단, Population 필드는 1000으로 나눠 k 단위 값으로 출력)


-- 참고) 소수점 자리수 조절: FORMAT(Population / 1000, 2), ROUND(Population / 1000, 2), FLOOR(Population / 1000)


-- ------------------------------------------------------------
-- Filtering data
-- ------------------------------------------------------------
-- DISTINCT 활용
-- 테이블 country에서 Continent 필드의 데이터를 중복 없이 조회


-- WHERE 활용 1
-- 테이블 country 에서 Region 필드 값이 'Eastern Asia'인 데이터의 Name, Population 조회


-- WHERE 활용 2
-- 테이블 country 에서 IndepYear 필드 값이 Null이 아닌 데이터의
-- Name, Region, Population, IndepYear 조회


-- WHERE 활용 3
-- 테이블 country 에서 Population 필드 값이 천만 이상이고
-- LifeExpectancy 필드가 78 이상인 데이터의 Name, Region, LifeExpectancy 조회
