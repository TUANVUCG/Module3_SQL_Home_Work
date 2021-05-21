CREATE DATABASE BT3_19_05_21;

USE BT3_19_05_21;

CREATE TABLE Subject(
SubjectID INT(4) PRIMARY KEY,
SubjectName NVARCHAR(50));

CREATE TABLE Class(
ClassID INT(4) PRIMARY KEY,
ClassName NVARCHAR(50));


CREATE TABLE Student(
StudentID INT(4) PRIMARY KEY,
StudentName NVARCHAR(50),
Age INT (4),
Email VARCHAR (50));

CREATE TABLE ClassStudent(
StudentID INT ,
ClassID INT,
PRIMARY KEY  (StudentID, ClassID));

CREATE TABLE Mark(
Mark FLOAT,
SubjectID INT,
StudentID INT,
PRIMARY KEY (StudentID, SubjectID));

-- 1. Hien thi danh sach tat ca cac hoc vien (danh sach phai sap xep theo ten hoc vien) 
SELECT*
FROM student
ORDER BY student.StudentName;

-- 2.Hien thi danh sach tat ca cac mon hoc
SELECT*
FROM subject;

-- 3.Hien thi danh sach nhung hoc vien nao co dia chi email chinh xac
SELECT*
FROM student 
WHERE Email LIKE ("%@%.%");

-- 4.Hien thi danh sach nhung hoc vien nao co ho la Nguyen
SELECT*
FROM student
WHERE StudentName LIKE("Nguyen%");

-- 5.Hien thi danh sach cac ban hoc vien cua lop C0706L
SELECT*
FROM student S
JOIN classstudent ST
ON ST.StudentID = S.StudentID
JOIN class C
ON C.ClassID = ST.ClassID
WHERE C.ClassName = 'C0706L';

-- 6.Hien danh sach va diem cua hoc vien ung voi cac mon hoc
SELECT S.StudentID, S.StudentName, Sub.SubjectName,M.Mark
FROM student S
JOIN mark M
ON M.StudentID = S.StudentID
JOIN Subject Sub
ON Sub.SubjectID = M.SubjectID;

-- 7.Hien thi danh sach hoc vien chua thi mon nao (chua co diem)
SELECT S.StudentID,S.StudentName,S.Age,S.Email
FROM student S
WHERE S.studentID NOT IN (
SELECT S.StudentID
FROM student
JOIN mark M
ON M.StudentID = S.StudentID);

-- 8.Hien thi mon hoc chua duoc hoc vien nao thi
SELECT S.SubjectID, S.SubjectName
FROM subject S
WHERE S.SubjectID NOT IN(
SELECT S.SubjectID
FROM subject S
RIGHT JOIN mark M
ON S.SubjectID = M.SubjectID);

-- 9.Tinh diem trung binh cho cac hoc vien
SELECT S.StudentID, S.StudentName, AVG(M.mark)
FROM student S
JOIN mark M
ON S.StudentID = M.StudentID
GROUP BY S.StudentID;

-- 10.Hien thi mon hoc nao duoc thi nhieu nhat
SELECT SubjectName, COUNT(*) SoLuongThi
FROM Mark
JOIN Subject ON Mark.SubjectID = Subject.SubjectID
GROUP BY  SubjectName
ORDER BY COUNT(*) DESC
LIMIT 1;
-- 11.Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
SELECT SubjectName, MAX(M.mark) Mark
FROM subject Sub
JOIN mark M
ON Sub.SubjectID =  M.SubjectID;

-- 12.Hien thi mon hoc nao co nhieu diem duoi diem trung binh nhat (<5)
SELECT SubjectName TenMonHoc, COUNT(Mark) SoDiemDuoiTrungBinh
FROM Subject Sub
JOIN mark M
ON Sub.SubjectID = M.SubjectID
WHERE Mark<5
GROUP BY SubjectName
ORDER BY SoDiemDuoiTrungBinh DESC
LIMIT 1
;
-- 13.Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age <50
ALTER TABLE student
ADD CONSTRAINT Age
CHECK (Age>15 OR Age<50);
-- 14.Loai bo tat ca quan he giua cac bang

-- 15.Xoa hoc vien co StudentID la 1
DELETE FROM student
WHERE student.StudentID = 1; 

-- 16.Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
ALTER TABLE student
ADD Status BIT DEFAULT 1;
-- 17.Cap nhap gia tri Status trong bang Student thanh 1




