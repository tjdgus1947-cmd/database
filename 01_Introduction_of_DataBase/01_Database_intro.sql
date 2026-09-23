-- ============================================================
-- 01. Introduction to Database (DDL)
-- 교안: 01_DataBase_Introduction_of_DataBase (MySQL 8.4 LTS 기준)
-- ============================================================

-- CREATE DATABASE
-- 연결된 RDBMS 서버에 데이터베이스 생성 (문자 인코딩은 utf8mb4 사용)
CREATE DATABASE db_intro
    DEFAULT CHARACTER SET utf8mb4;

-- 작업을 진행할 데이터베이스 선택
USE db_intro;


-- ------------------------------------------------------------
-- DDL: CREATE TABLE
-- ------------------------------------------------------------
-- CREATE TABLE 활용
-- examples 테이블 생성
CREATE TABLE examples (
  exam_id INT PRIMARY KEY AUTO_INCREMENT,
  last_name VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL
);

-- SCHEMA 확인하기 1
DESCRIBE examples;
-- SCHEMA 확인하기 2
SHOW CREATE TABLE examples;


-- 제약 조건 정의 방법
-- 제약 조건을 정의하여 users 테이블 생성
--   - 한 줄에 길게 작성되는 경우 뒷부분에 제약 조건 작성 가능
--   - CONSTRAINT 키워드로 제약 조건에 이름 지정 (valid_email은 교육용 최소 패턴)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    age INT NOT NULL CHECK (age >= 0 AND age <= 150),
    balance INT DEFAULT 0, 
    FOREIGN KEY (exam_id) REFERENCES examples(exam_id),
    CHECK (balance >= -5000 AND balance <= 5000),
    CONSTRAINT unique_email UNIQUE (email),
    CONSTRAINT valid_email CHECK (email LIKE '%_@__%.__%')
);

DESCRIBE users;
SHOW CREATE TABLE users;


-- ------------------------------------------------------------
-- DDL: ALTER TABLE
-- ------------------------------------------------------------
-- 1. ALTER TABLE ADD COLUMN 활용 1
-- examples 테이블에 country 필드 추가
ALTER TABLE 
  examples
ADD COLUMN
  country VARCHAR(100) NOT NULL DEFAULT 'default value';

-- ALTER TABLE ADD COLUMN 활용 2
-- examples 테이블에 age, address 필드 추가
-- (ADD COLUMN 사이에 , 를 붙여서 여러 컬럼을 한 번에 추가 가능)
ALTER TABLE examples
ADD COLUMN age INTEGER NOT NULL DEFAULT 0,
ADD COLUMN address VARCHAR(100) NOT NULL DEFAULT 'default value';

DESCRIBE examples;

-- 2. ALTER TABLE RENAME COLUMN 활용
-- examples 테이블 address 필드의 이름을 post_code로 변경
ALTER TABLE examples
RENAME COLUMN address TO post_code;

DESCRIBE examples;

-- 3. ALTER TABLE RENAME TO 활용
-- examples 테이블 이름을 new_examples로 변경
ALTER TABLE examples
RENAME TO new_examples;

SHOW TABLES;


-- ------------------------------------------------------------
-- DDL: DROP TABLE
-- ------------------------------------------------------------
-- DROP TABLE 활용
-- [에러 발생 예시]
-- users.exam_id 의 외래 키가 new_examples.exam_id 를 참조하고 있으므로
-- new_examples 테이블을 먼저 삭제할 수 없음 (Error 3730: Cannot drop table ... referenced by a foreign key)
DROP TABLE new_examples;

-- 참조하는 테이블(users)을 먼저 삭제한 뒤, 참조되는 테이블(new_examples)을 삭제
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS new_examples;

SHOW TABLES;


-- ------------------------------------------------------------
-- DDL: TRUNCATE TABLE
-- ------------------------------------------------------------
-- TRUNCATE [TABLE] table_name;
-- 데이터를 삽입하는 DML은 다음 수업에서 진행하므로 실습은 다음 수업(02_DML)에서 진행
-- TRUNCATE TABLE new_examples;
