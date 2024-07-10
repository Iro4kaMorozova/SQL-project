-- 1. Створіть базу даних для управління курсами. 

DROP DATABASE IF EXISTS course_management;
CREATE DATABASE IF NOT EXISTS course_management;
USE course_management;
-- База має включати наступні таблиці:
-- - students: student_no, teacher_no, course_no, student_name, email, birth_date.
  -- teachers: teacher_no, teacher_name, phone_no
-- - courses: course_no, course_name, start_date, end_date
DROP TABLE IF EXISTS teachers, courses, students;
CREATE TABLE IF NOT EXISTS teachers (
teacher_no    INT          AUTO_INCREMENT    PRIMARY KEY,
teacher_name  VARCHAR(48)  NOT NULL,
phone_no      VARCHAR(15)  NOT NULL
)
ENGINE = InnoDB DEFAULT CHARSET = utf8mb4  COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS courses (
course_no    CHAR(4)       NOT NULL    PRIMARY KEY,
course_name  VARCHAR(48)   NOT NULL    UNIQUE KEY,
start_date   DATE          NOT NULL,
end_date     DATE          NOT NULL
)
ENGINE = InnoDB DEFAULT CHARSET = utf8mb4  COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS students(
student_no     INT         AUTO_INCREMENT,
teacher_no     INT         NOT NULL,
course_no      CHAR(4)     NOT NULL,
student_name   VARCHAR(48) NOT NULL,
email          VARCHAR(64) NOT NULL,
birth_date     DATE        NOT NULL,
PRIMARY KEY (student_no, teacher_no, course_no),
FOREIGN KEY (teacher_no) REFERENCES teachers (teacher_no)  ON DELETE CASCADE,
FOREIGN KEY (course_no) REFERENCES courses (course_no)  ON DELETE CASCADE
)
ENGINE = InnoDB DEFAULT CHARSET = utf8mb4  COLLATE = utf8mb4_0900_ai_ci;

-- 2. Додайте будь-які данні (7-10 рядків) в кожну таблицю.

INSERT INTO teachers (teacher_name, phone_no)
VALUES ('Chirstian Koblick', '+38(095)1111111'),
('Anneke Preusig', '+38(067)2222222'),
('Berni Genin', '+38(067)3333333'),
('Suzette Pettey', '+38(066)4444444'),
('Alain Chappelet', '+38(095)5555555'),
('Moss Shanbhogue', '+38(099)6666666'),
('Basil Tramer', '+38(095)7777777');

SELECT * FROM course_management.teachers;

INSERT INTO courses (course_no, course_name, start_date, end_date)
VALUES ('c001', 'FrontEnd', '2023-12-5', '2024-06-07'),
('c002', 'Full Stack Developer', '2023-12-15', '2024-12-15'),
('c003', 'UI/UX Design', '2023-12-15', '2024-03-25'),
('c004', 'Programming Essentials', '2023-12-25', '2024-02-27'),
('c005', 'HR Manager', '2023-12-27', '2024-04-30'),
('c006', 'SMM &Content marketing', '2023-01-20', '2023-03-10'),
('c007', 'Business Intelligense', '2023-10-26', '2024-04-30');

SELECT * FROM course_management.courses;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES ('1', 'c001', 'Mark Peltason', 'Mark.Peltason@gmail.com', '1988-06-21'),
('2', 'c002', 'Armond Peir', 'Armond_Peir@gmail.com', '1994-11-17'),
('3', 'c003', 'Perry Shimshoni', 'Perry.Shimshoni@gmail.com', '1991-03-14'),
('4', 'c004', 'Marlo Piancastelli', 'Marlo.Piancastelli@gmail.com', '1991-03-14'),
('5', 'c005', 'Isamu Siochi', 'Isamu_Siochi@gmail.com', '1991-03-14'),
('6', 'c006', 'Shay Poulakidas', 'Shay.Poulakidas@gmail.com', '1985-11-12'),
('7', 'c007', 'Petter Lorho', 'Petter_Lorho@gmail.com', '1989-01-30'),
('1', 'c001', 'Faiza Baer', 'Faiza_Baer@gmail.com', '1987-08-27'),
('2', 'c002', 'Maris Birge', 'Maris_Birge@gmail.com', '1997-04-29'),
('3', 'c003', 'Christoper Schwaller', 'Christoper.Schwaller@gmail.com', '1992-06-25'),
('4', 'c004', 'Remko Shigei', 'Remko.Shigei@gmail.com', '1996-08-30'),
('5', 'c005', 'Heon Ranai', 'Heon.Ranai@gmail.com', '1988-01-18'),
('6', 'c006', 'Vasilis Standera', 'Vasilis.Standera@gmail.com', '1992-08-30'),
('7', 'c007', 'Rosine Granlund', 'Rosine.Granlund@gmail.com', '1992-06-25'),
('1', 'c001', 'Willard Rosin', 'Willard.Rosin@gmail.com', '1994-02-05'),
('2', 'c002', 'Alejandro Peir', 'Alejandro.Peir@gmail.com', '1990-05-25'),
('3', 'c003', 'Yagil Deverell', 'Yagil.Deverell@gmail.com', '1986-12-17'),
('4', 'c004', 'Volkmar Ebeling', 'Volkmar.Ebeling@gmail.com', '1991-09-18'),
('5', 'c005', 'Uli Keustermans', 'Uli.Keustermans@gmail.com', '1989-09-16'),
('6', 'c006', 'Cathie Brlek', 'Cathie.Brlek@gmail.com', '1986-07-22'),
('7', 'c007', 'Akeel Narahara', 'Akeel.Narahara@gmail.com', '1986-07-22'),
('7', 'c007', 'Werner Hasham', 'Werner.Hasham@gmail.com', '1988-05-23');

SELECT * FROM course_management.students;

-- 3. По кожному викладачу покажіть кількість студентів з якими він працював
SELECT teacher_no, count(student_no)
FROM course_management.students
GROUP BY teacher_no;
-- або
SELECT cms.teacher_no, teacher_name, count(student_no)
FROM course_management.students as cms
JOIN course_management.teachers as cmt ON (cms.teacher_no = cmt.teacher_no)
GROUP BY teacher_no, teacher_name;

-- 4. Спеціально зробіть 3 дубляжі в таблиці students (додайте ще 3 однакові рядки)
INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES ('1', 'c001', 'Mark Peltason', 'Mark.Peltason@gmail.com', '1988-06-21'),
('2', 'c002', 'Armond Peir', 'Armond_Peir@gmail.com', '1994-11-17'),
('3', 'c003', 'Perry Shimshoni', 'Perry.Shimshoni@gmail.com', '1991-03-14');

SELECT * FROM course_management.students;

-- 5. Напишіть запит який виведе дублюючі рядки в таблиці students.
SELECT cms.*
FROM course_management.students as cms
LEFT JOIN (SELECT MIN(student_no) AS student_no, student_name, birth_date FROM course_management.students GROUP BY student_name, birth_date) AS tmp 
ON cms.student_no = tmp.student_no  
WHERE tmp.student_no IS NULL;