CREATE DATABASE library_db;
USE library_db;

CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(100)
);

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);

INSERT INTO authors (name) VALUES
('J.K. Rowling'), ('George R.R. Martin'), ('J.R.R. Tolkien'),
('Isaac Asimov'), ('Agatha Christie');

INSERT INTO genres (genre_name) VALUES
('Fantasy'), ('Science Fiction'), ('Mystery'), ('Thriller');

INSERT INTO books (title, author_id, genre_id) VALUES
('Harry Potter and the Philosopher''s Stone', 1, 1),
('Harry Potter and the Chamber of Secrets', 1, 1),
('A Game of Thrones', 2, 1),
('A Clash of Kings', 2, 1),
('The Hobbit', 3, 1),
('The Lord of the Rings', 3, 1),
('Foundation', 4, 2),
('I, Robot', 4, 2),
('Murder on the Orient Express', 5, 3),
('The Mysterious Affair at Styles', 5, 3),
('The Girl with the Dragon Tattoo', 5, 4);