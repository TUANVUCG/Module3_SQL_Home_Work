CREATE DATABASE BT_21_05_21;

USE BT_21_05_21;
CREATE TABLE Address
(
id INT PRIMARY KEY,
address VARCHAR(50));

CREATE TABLE Classes(
id INT PRIMARY KEY,
name VARCHAR(50),
language VARCHAR(50),
description VARCHAR(50)
);

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE Student;
CREATE TABLE Student 
(
id INT PRIMARY KEY,
fullname VARCHAR(50),
address_id INT,
phone VARCHAR(30) UNIQUE,
class_id INT,
CONSTRAINT FK_address_id FOREIGN KEY (address_id) REFERENCES address(id),
CONSTRAINT FK_class_id FOREIGN KEY (class_id) REFERENCES classes(id)
);

DROP TABLE Course;
CREATE TABLE Course
(
id INT PRIMARY KEY,
name VARCHAR(50) , 
description VARCHAR(50)
);

CREATE TABLE Point
(
id INT PRIMARY KEY,
course_id INT,
student_id INT,
point FLOAT DEFAULT 0,
CONSTRAINT FK_course_id FOREIGN KEY (course_id) REFERENCES course(id),
CONSTRAINT FK_student_id FOREIGN KEY (student_id) REFERENCES student(id)
);

-- Thêm 5 bản ghi trong bảng Address 
INSERT INTO address
VALUES 
(1,'Viet Nam'),
(2,'Trung Quoc'),
(3,'Han Quoc'),
(4,'My'),
(5,'Nhat Ban'),
(6,'An Do'),
(7,'Argentina');
    
-- Thêm 5 bản ghi trong bảng Classes 
INSERT INTO classes
VALUES 
(1,'SQL','Viet Nam','Xanh'),
(2,'Java','Han Quoc','Vang'),
(3,'PHP','Brazil','Do'),
(4,'C','Indonesia','Trang'),
(5,'Python','Duc','Den');

-- Thêm 10 bản ghi trong bảng Student 
SET SQL_SAFE_UPDATES = 0;
DELETE FROM student;
INSERT INTO student
VALUES 
(1,'Tran Ngoc Anh',2,'09212083084',2),
(2,'Tong Van Son',1,'0121212121',4),
(3,'Vu Van Chinh',5,'09892736262',3),
(4,'Lai Ngoc Huyen',3,'0943123812',1),
(5,'Ha Anh Tuan',2,'01284782847',2),
(6,'Dinh Hong Hanh',3,'0123123123',1),
(7,'Nguyen Tuan Vu',4,'0978326973',4),
(8,'Kha Tran Hai',1,'09838272384',3),
(9,'Lam Chi Dinh',2,'09677626262',2),
(10,'Luu Diec Phi',1,'01233787439',1);

-- Thêm 5 bản ghi trong bảng Course 
INSERT INTO course
VALUES 
(1,'Nau an','Black'),
(2,'My thuat','Puple'),
(3,'Cong Nghe','Blue'),
(4,'Tin hoc','Yellow'),
(5,'Co khi','Red');
-- Thêm 15 bản ghi trong bảng Point
INSERT INTO point
VALUES 
(1,1,7,10),
(2,1,10,11),
(3,5,2,13),
(4,4,3,7),
(5,2,4,8),
(6,5,1,9),
(7,1,2,7.5),
(8,2,5,17),
(9,4,8,3),
(10,5,1,14),
(11,3,2,13.3),
(12,2,5,6),
(13,2,4,7),
(14,4,7,9),
(15,1,3,21);

-- Viết các câu lệnh truy vấn thực hiện nhiệm vụ sau: 
-- Thống kê số lượng HV cáclớp 
SELECT C.name 'Tên lớp', COUNT(*) 'Số học viên'
FROM classes C 
JOIN student S
ON C.id = S.class_id
GROUP BY C.name;

-- Thống kê số lượng học viên theo quê
SELECT A.address 'Quê quán' , COUNT(*)
FROM address A
JOIN student S
ON A.id = S.address_id
GROUP BY address;

-- Tính điểm trung bình của các khóa học
DROP VIEW findAVG;
CREATE VIEW findAVG AS
SELECT C.name AS name , AVG(P.point)  AS Avg_Point
FROM course C 
JOIN point P
ON C.id = P.course_id
GROUP BY C.name
ORDER BY Avg_Point DESC;

-- Đưa ra khóa học có điểm trung bình cao nhất
SELECT C.id, C.name, F.Avg_Point
FROM course C
JOIN findAVG F
ON C.name = F.name
ORDER BY F.Avg_Point DESC
LIMIT 1;



