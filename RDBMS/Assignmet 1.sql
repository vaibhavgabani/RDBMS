-- create table 
CREATE TABLE StudentAttendance (
    StudentID INT,
    TotalLecturesConducted INT,
    TotalLecturesAttended INT,
    AttendancePercentage DECIMAL(5, 2),
    AttendanceStatus VARCHAR(50)
);

-- ans 1 

CREATE OR REPLACE TRIGGER AUTOSTUD
BEFORE INSERT ON StudentAttendance
FOR EACH ROW  
BEGIN
    :NEW.AttendancePercentage := (:NEW.TotalLecturesAttended / :NEW.TotalLecturesConducted) * 100;

    IF :NEW.AttendancePercentage >=90 THEN
        :NEW.AttendanceStatus := 'Excellent';
    ELSIF :NEW.AttendancePercentage >=70 AND :NEW.AttendancePercentage <=89 THEN
        :NEW.AttendanceStatus := 'Excellent';
    ELSE 
        :NEW.AttendanceStatus := 'POOR';
    END IF;
END;


-- Q2

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


-- ANS 2

DECLARE 
    CURSOR DATA IS 
    SELECT STUDENTID , CATEGORY
    FROM STUDENTMASTER
    WHERE CATEGORY = 'SC'
    OR CATEGORY = 'ST'
    OR (CATEGORY = 'SCBC' AND GENDER = 'FEMALE');
BEGIN
    FOR REC IN DATA LOOP
    INSERT INTO STUDENTSCHOLARSHIP (StudentID,YEAR,Category)  VALUES (REC.STUDENTID,SYSDATE,REC.CATEGORY);
    END LOOP;
END;

-- Q3
CREATE TABLE CUSTOMERLOGinactivityTable (
    CUSTOMERID      NUMBER PRIMARY KEY,
    LASTLOGINDATE   DATE,
    LASTLOGINTIME   VARCHAR2(10),
    CUSTOMERSTATUS  VARCHAR2(20)
);


BEGIN
    UPDATE CUSTOMERLOGinactivityTable
    SET CUSTOMERSTATUS = ' In_Active'
    WHERE LASTLOGINDATE < SYSDATE - 30;
END;
