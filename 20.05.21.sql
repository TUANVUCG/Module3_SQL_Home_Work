CREATE DATABASE BAITAP20_05_21;

USE BAITAP20_05_21;

CREATE TABLE class(
ClassID INT PRIMARY KEY AUTO_INCREMENT,
ClassName NVARCHAR(255) NOT NULL,
StartDate DATETIME NOT NULL,
Status BIT);

CREATE TABLE Student(
StudentID INT PRIMARY KEY,
StudentName NVARCHAR(30) NOT NULL,
Address NVARCHAR(50),
Phone VARCHAR(20),
Status BIT,
ClassID INT NOT NULL,
CONSTRAINT FK_ClassID FOREIGN KEY(ClassID) REFERENCES class(ClassID));


CREATE TABLE Subject(
SubID INT PRIMARY KEY AUTO_INCREMENT,
SubName NVARCHAR(30) NOT NULL,
Credit TINYINT NOT NULL DEFAULT 1 CHECK (Credit>=1),
Status BIT DEFAULT 1);

DROP TABLE Mark;
CREATE TABLE Mark(
MarkID INT PRIMARY KEY,
SubID INT NOT NULL ,
StudentID INT NOT NULL ,
Mark FLOAT DEFAULT 0 CHECK (Mark BETWEEN 0 AND 100),
ExamTimes TINYINT DEFAULT 1,
CONSTRAINT FK_StudentID_Mark FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
CONSTRAINT FK_SubID_Mark FOREIGN KEY (SubID) REFERENCES Subject(SubID));
ALTER TABLE Mark
ADD INDEX  (SubID, StudentID) ;

ALTER TABLE Mark
ADD UNIQUE (SubID, StudentID);

-- Thêm ràng buộc cho cột StartDate của  bảng Class là ngày hiện hành.
ALTER TABLE Student
MODIFY Status BIT DEFAULT 1;

-- Thêm dữ liệu vào các bảng
-- Bảng Class
INSERT INTO class
VALUE(1,'A1','2008-12-20',1);
INSERT INTO class
VALUE(2,'A2','2008-12-22',1);
INSERT INTO class
VALUE(3,'B3',CURRENT_DATE(),0);

-- Bảng Student
INSERT INTO student
VALUE(1,'Hung','Ha Noi','0912113113',1,1);
INSERT INTO student
VALUE(2,'Hoa','Hai Phong',NULL,1,1);
INSERT INTO student
VALUE(3,'Manh','HCM','0123123123',0,2);

-- Bảng Subject
INSERT INTO subject
VALUE(1,'CF',5,1);
INSERT INTO subject
VALUE(2,'C',6,1);
INSERT INTO subject
VALUE(3,'HDJ',5,1);
INSERT INTO subject
VALUE(4,'RDBMS',10,1);

-- Bảng Mark
INSERT INTO mark
VALUE(1,3,3,8,1);
INSERT INTO mark
VALUE(2,1,2,10,2);
INSERT INTO mark
VALUE(3,2,1,12,1);

-- 5 Cập nhật dữ liệu
-- a . Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2
SET SQL_SAFE_UPDATES = 0;
UPDATE  student
SET ClassID = 2
 WHERE StudentName = 'Hung';
/* b. Cập nhật cột phone trên bảng sinh viên là ‘No phone’ 
cho những sinh viên chưa có số điện thoại. */
UPDATE student
SET Phone =  'No Phone'
WHERE Phone IS NULL;

/* c. Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
(Chú ý: phải sử dụng phương thức write).*/
UPDATE class
SET ClassName =  CONCAT('New ', ClassName)
WHERE Status = 0;

/* d.Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ 
thì thay thế ‘New’ bằng ‘old’.
(Chú ý: phải sử dụng phương thức write).*/
UPDATE class
SET className = REPLACE(className, 'New','Old')
WHERE (Status = 1 AND ClassName LIKE 'New%');

/*e.Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).*/
UPDATE class
SET Status = 0
WHERE class.classID NOT IN (
SELECT S.classID
FROM Student S
);

/* f.Cập nhật trạng thái của lớp học (bảng subject) là 0 
nếu môn học đó chưa có sinh viên dự thi */
UPDATE subject
SET Status = 0
WHERE subject.SubID NOT IN (
SELECT SubID 
FROM mark);

-- 6.Hiện thị thông tin.
-- Tìm điểm sinh viên lớn thứ hai và đếm xem có bao nhiêu sinh viên có điểm như vậy

-- a.Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
SELECT*
FROM student
WHERE StudentName LIKE 'h%';

-- b.Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
SELECT*
FROM class
WHERE MONTH(StartDate) = 12;

-- .Hiển thị môn học có giá trị lớn thứ hai của credit trong bảng subject.
SELECT SubID, SubName, MAX(Credit) AS SecondCredit, Status
FROM subject
WHERE Credit < ( SELECT CM FROM findMaxCredit);

-- d.Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
-- Tìm giá trị lớn nhất của Credit 
DROP VIEW findMaxCredit;
CREATE VIEW findMaxCredit AS
SELECT MAX(Credit) AS CM
FROM subject;

-- c.Hiển thị môn học có giá trị lớn nhất của credit trong bảng subject.
SELECT *
FROM subject 
WHERE Credit = (SELECT CM FROM findMaxCredit);

-- e.Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
SELECT *
FROM Subject
WHERE Credit BETWEEN 3 AND 5;

-- f.Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bảng Class, student
SELECT C.ClassID, C.ClassName,S.StudentName,S.Address
FROM student S
JOIN class C
GROUP BY C.ClassID, S.StudentID;
-- g.Hiển thị các thông tin môn học chưa có sinh viên dự thi.
DROP VIEW findSubjectsHasStudent;
CREATE VIEW findSubjectsHasStudent AS
SELECT S.SubID AS SubID, S.SubName,S.Credit, S.Status
FROM subject S
JOIN mark M
ON M.SubID = S.SubID;

SELECT *
FROM Subject
WHERE SubID NOT IN (SELECT SubID FROM findSubjectsHasStudent);

-- h.Hiển thị các thông tin môn học có điểm thi lớn nhất.
-- Tìm điểm thi lớn nhất
CREATE VIEW findSubHaveMaxMark AS
    SELECT 
        SubID AS SubHaveMaxMark, MAX(mark)
    FROM
        mark;

SELECT 
    S.SubID, S.SubName, S.Credit, S.Status
FROM
    subject S
        JOIN
    mark
WHERE
    S.SubID = (SELECT 
            SubHaveMaxMark
        FROM
            findSubHaveMaxMark)
GROUP BY S.SubID;
-- i.Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
CREATE VIEW showStudentInfoAndMark AS
SELECT S.StudentID AS ID , S.StudentName AS 'Tên Học sinh', M.Mark AS 'Điểm'
FROM Student S
JOIN mark M
ON S.StudentID = M.StudentID;
-- j.Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)
SELECT RANK() OVER (ORDER BY M.mark DESC) AS 'Rank by Mark',
S.StudentID AS ID , S.StudentName AS 'Tên Học sinh', M.Mark AS 'Điểm'
FROM student S
JOIN mark M
ON S.StudentID = M.StudentID;
 
-- k.Hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10.
SELECT S.StudentID, S.StudentName, M.Mark
FROM student S
JOIN mark M
ON S.StudentID = M.StudentID
WHERE M.Mark>10;

-- l.Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
SELECT S.StudentID, S.StudentName, M.Mark
FROM student S
JOIN mark M
ON S.StudentID = M.StudentID
ORDER BY M.mark DESC , S.StudentName ;

-- 7.Xóa dữ liệu.
-- a.Xóa tất cả các lớp có trạng thái là 0.
DELETE FROM class
WHERE Status = 0;

-- b.Xóa tất cả các môn học chưa có sinh viên dự thi.
-- Tìm môn học chưa có sinh viên dự thi 
SET SQL_SAFE_UPDATES = 0;
DELETE FROM  subject
WHERE SubID NOT IN(
SELECT SubID
FROM mark);

-- 8.Thay đổi.
-- a.Xóa bỏ cột ExamTimes trên bảng Mark.
ALTER TABLE Mark
DROP ExamTimes;

-- b.Sửa đổi cột status trên bảng class thành tên ClassStatus.
ALTER TABLE class
CHANGE Status ClassStatus BIT ;

-- c.Đổi tên bảng Mark thành SubjectTest.
ALTER TABLE Mark
RENAME TO SubjectTest;
ALTER TABLE SubjectTest
RENAME TO Mark;

-- d.Chuyển cơ sở dữ liệu hiện hành sang cơ sở dữ liệu Master.

-- e.Xóa bỏ cơ sở dữ liệu vùa tạo.
DROP DATABASE BAITAP20_05_21;




