------------------------------------------------------------
-- Q.1 : STUDENT ATTENDANCE
-- Consider the following Table for maintaining students' attendance
-- StudentAttendance(StudentID, TotalLecturesConducted, TotalLecturesAttended,
-- AttendancePercentage, AttendanceStatus)
--
-- Assume that the StudentAttendance Table contains data for:
-- StudentID, TotalLecturesConducted and TotalLecturesAttended fields.
--
-- Write a PL/SQL program to calculate AttendancePercentage and AttendanceStatus
-- fields for StudentAttendance Table.
--
-- Rules:
-- Excellent → 90% or more
-- Good      → 70 to 89%
-- Poor and Can Be Detained → less than 70%
------------------------------------------------------------
CREATE TABLE STUDENTATTENDANCE (
    STUDENTID               NUMBER(10) PRIMARY KEY,
    TOTALLECTURESCONDUCTED  NUMBER(3) NOT NULL,
    TOTALLECTURESATTENDED   NUMBER(3) NOT NULL,
    ATTENDANCEPERCENTAGE    NUMBER(5,2),
    ATTENDANCESTATUS        VARCHAR2(30)
);

INSERT ALL
    INTO STUDENTATTENDANCE VALUES (1,  100, 95, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (2,   90, 85, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (3,   80, 75, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (4,   60, 55, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (5,  120,110, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (6,  100, 88, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (7,   75, 60, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (8,   90, 65, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (9,   85, 84, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (10, 100, 70, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (11,  50, 45, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (12,  95, 80, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (13,  88, 87, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (14,  92, 91, NULL, NULL)
    INTO STUDENTATTENDANCE VALUES (15,  70, 50, NULL, NULL)
SELECT * FROM dual;

CREATE OR REPLACE TRIGGER CALCULATEPERCENTAGE
BEFORE INSERT OR UPDATE ON STUDENTATTENDANCE
FOR EACH ROW
BEGIN
    :NEW.ATTENDANCEPERCENTAGE := (:NEW.TOTALLECTURESATTENDED / :NEW.TOTALLECTURESCONDUCTED) * 100;

    IF    :NEW.ATTENDANCEPERCENTAGE >= 90 THEN
        :NEW.ATTENDANCESTATUS := 'Excellent';
    ELSIF :NEW.ATTENDANCEPERCENTAGE >= 70 AND :NEW.ATTENDANCEPERCENTAGE < 90 THEN
        :NEW.ATTENDANCESTATUS := 'Good';
    ELSE
        :NEW.ATTENDANCESTATUS := 'Poor and can be Detained';
    END IF;
END;
/
------------------------------------------------------------
-- Q.2 : STUDENT MASTER & SCHOLARSHIP
-- StudentMaster(StudentID, StudentName, Category, Gender, Semester, Address, Phone, Mobile, Email)
-- StudentScholarship(StudentID, Year, Category)
--
-- Criteria:
-- - All SC category students
-- - All ST category students
-- - Female SEBC students
--
-- System date should be used for Year field.
------------------------------------------------------------
CREATE TABLE STUDENTMASTER (
    STUDENTID   INT PRIMARY KEY,
    STUDENTNAME VARCHAR2(50),
    CATEGORY    VARCHAR2(50),
    GENDER      VARCHAR2(50),
    SEMESTER    NUMBER(10),
    ADDRESS     VARCHAR2(100),
    PHONE       NUMBER(15),
    MOBILE      NUMBER(15),
    EMAIL       VARCHAR2(50)
);

INSERT ALL
    INTO STUDENTMASTER VALUES (101, 'Anita Shah',    'SEBC', 'FEMALE', 3, '123 Street, Ahmedabad', 794411111, 9876543210, 'anita.shah@example.com')
    INTO STUDENTMASTER VALUES (102, 'Rahul Kumar',   'SC',   'MALE',   2, '456 Avenue, Surat',     794422222, 9876500000, 'rahul.kumar@example.com')
    INTO STUDENTMASTER VALUES (103, 'Priya Mehta',   'GEN',  'FEMALE', 5, '789 Road, Vadodara',    794433333, 9876511111, 'priya.mehta@example.com')
    INTO STUDENTMASTER VALUES (104, 'Manoj Patel',   'ST',   'MALE',   4, '234 Colony, Rajkot',    794444444, 9876522222, 'manoj.patel@example.com')
    INTO STUDENTMASTER VALUES (105, 'Kavita Desai',  'SEBC', 'FEMALE', 1, '321 Nagar, Bhavnagar',  794455555, 9876533333, 'kavita.desai@example.com')
    INTO STUDENTMASTER VALUES (106, 'Ramesh Yadav',  'GEN',  'MALE',   3, '654 Layout, Jamnagar',  794466666, 9876544444, 'ramesh.yadav@example.com')
    INTO STUDENTMASTER VALUES (107, 'Sneha Joshi',   'SC',   'FEMALE', 6, '741 Street, Gandhinagar', 794477777, 9876555555, 'sneha.joshi@example.com')
    INTO STUDENTMASTER VALUES (108, 'Deepak Verma',  'OBC',  'MALE',   2, '852 Colony, Mehsana',   794488888, 9876566666, 'deepak.verma@example.com')
    INTO STUDENTMASTER VALUES (109, 'Pooja Shah',    'SEBC', 'FEMALE', 4, '963 Circle, Anand',     794499999, 9876577777, 'pooja.shah@example.com')
    INTO STUDENTMASTER VALUES (110, 'Amit Trivedi',  'ST',   'MALE',   5, '159 Park, Bharuch',     794410101, 9876588888, 'amit.trivedi@example.com')
SELECT * FROM dual;

CREATE TABLE STUDENTSCHOLARSHIP (
    STUDENTID INT REFERENCES STUDENTMASTER(STUDENTID),
    YEAR      DATE,
    CATEGORY  VARCHAR2(50)
);

DECLARE
    CURSOR TSINFO IS
        SELECT * 
        FROM STUDENTMASTER
        WHERE CATEGORY = 'SC'
           OR CATEGORY = 'ST'
           OR (CATEGORY = 'SEBC' AND GENDER = 'FEMALE');
BEGIN
    FOR DATA IN TSINFO LOOP
        INSERT INTO STUDENTSCHOLARSHIP
        VALUES (
            DATA.STUDENTID,
            TO_DATE(EXTRACT(YEAR FROM SYSDATE) || '-01-01', 'YYYY-MM-DD'),
            DATA.CATEGORY
        );
    END LOOP;
END;

------------------------------------------------------------
-- Q.3 : CUSTOMER LOGIN ACTIVITY
-- CustomerLoginActivityTable (CustomerID, LastLoginDate, LastLoginTime, CustomerStatus)
--
-- Rule:
-- Mark all customers as 'In_Active' if the customer
-- has not logged in for more than 30 days.
------------------------------------------------------------
CREATE TABLE CUSTOMERLOG inactivityTable (
    CUSTOMERID      NUMBER PRIMARY KEY,
    LASTLOGINDATE   DATE,
    LASTLOGINTIME   VARCHAR2(10),
    CUSTOMERSTATUS  VARCHAR2(20)
);

-- Sample data
INSERT ALL
    INTO CUSTOMERLOGINACTIVITYTABLE VALUES (1, DATE '2025-07-01', '10:00', 'Active')
    INTO CUSTOMERLOGINACTIVITYTABLE VALUES (2, DATE '2025-06-15', '09:45', 'Active')
    INTO CUSTOMERLOGINACTIVITYTABLE VALUES (3, DATE '2025-08-05', '11:30', 'Active')
SELECT * FROM DUAL;

-- PL/SQL to mark inactive if not logged in for more than 30 days
BEGIN
    UPDATE CUSTOMERLOGINACTIVITYTABLE
    SET CUSTOMERSTATUS = 'In_Active'
    WHERE LASTLOGINDATE < SYSDATE - 30;
END;
