----------------------------------------------------
-- TABLE CREATION
----------------------------------------------------

CREATE TABLE BOOKSUBJECT (
    BOOKSUB_ID INT PRIMARY KEY,
    BOOKSUBJECT_NAME VARCHAR2(20)
);

CREATE TABLE AUTHOR (
    AUTHOR_ID INT PRIMARY KEY,
    AUTHOR_NAME VARCHAR2(20)
);

CREATE TABLE BOOK (
    BOOK_ID INT PRIMARY KEY,
    BOOK_NAME VARCHAR2(20),
    BOOK_PRICE INT NOT NULL,
    BOOK_QTY INT NOT NULL CHECK (BOOK_QTY > 0),
    DISCOUNT_AMT INT,
    NETPRICE INT,
    BOOKSUB_ID INT,
    AUTHOR_ID INT,
    PURCHASEDATE DATE,
    FOREIGN KEY (BOOKSUB_ID) REFERENCES BOOKSUBJECT(BOOKSUB_ID),
    FOREIGN KEY (AUTHOR_ID) REFERENCES AUTHOR(AUTHOR_ID)
);

----------------------------------------------------
-- INSERT DATA INTO BOOKSUBJECT AND AUTHOR
----------------------------------------------------

INSERT ALL
    -- BOOKSUBJECT DATA
    INTO BOOKSUBJECT VALUES (1, 'COMPUTER SCIENCE')
    INTO BOOKSUBJECT VALUES (2, 'PHYSICS')
    INTO BOOKSUBJECT VALUES (3, 'MATHEMATICS')
    INTO BOOKSUBJECT VALUES (4, 'CHEMISTRY')
    INTO BOOKSUBJECT VALUES (5, 'BIOLOGY')
    INTO BOOKSUBJECT VALUES (6, 'HISTORY')
    INTO BOOKSUBJECT VALUES (7, 'ECONOMICS')
    INTO BOOKSUBJECT VALUES (8, 'LITERATURE')

    -- AUTHOR DATA
    INTO AUTHOR VALUES (101, 'JAMES SMITH')
    INTO AUTHOR VALUES (102, 'LINDA JOHNSON')
    INTO AUTHOR VALUES (103, 'MICHAEL BROWN')
    INTO AUTHOR VALUES (104, 'PATRICIA DAVIS')
    INTO AUTHOR VALUES (105, 'ROBERT MILLER')
    INTO AUTHOR VALUES (106, 'BARBARA WILSON')
    INTO AUTHOR VALUES (107, 'DAVID MOORE')
    INTO AUTHOR VALUES (108, 'SUSAN TAYLOR')
SELECT * FROM DUAL;

----------------------------------------------------
-- INSERT DATA INTO BOOK
----------------------------------------------------

INSERT ALL
    INTO BOOK VALUES (1,  'C++ BASICS',        450, 10, 50, NULL, 1, 101, '12-AUG-2025')
    INTO BOOK VALUES (2,  'JAVA PROGRAMMING',  550, 15, 75, NULL, 1, 102, '11-AUG-2025')
    INTO BOOK VALUES (3,  'DATA STRUCTURES',   600, 12, 80, NULL, 1, 103, '10-AUG-2025')
    INTO BOOK VALUES (4,  'PHYSICS PART 1',    500, 20, 60, NULL, 2, 104, '09-AUG-2025')
    INTO BOOK VALUES (5,  'PHYSICS PART 2',    520, 18, 65, NULL, 2, 105, '08-AUG-2025')
    INTO BOOK VALUES (6,  'MATH ALGEBRA',      400, 25, 40, NULL, 3, 106, '07-AUG-2025')
    INTO BOOK VALUES (7,  'MATH CALCULUS',     480, 15, 50, NULL, 3, 107, '06-AUG-2025')
    INTO BOOK VALUES (8,  'CHEMISTRY BASICS',  450, 12, 45, NULL, 4, 108, '05-AUG-2025')
    INTO BOOK VALUES (9,  'ORGANIC CHEMISTRY', 600, 14, 70, NULL, 4, 101, '04-AUG-2025')
    INTO BOOK VALUES (10, 'BIOLOGY PART 1',    500, 10, 55, NULL, 5, 102, '03-AUG-2025')
    INTO BOOK VALUES (11, 'BIOLOGY PART 2',    520, 16, 60, NULL, 5, 103, '02-AUG-2025')
    INTO BOOK VALUES (12, 'WORLD HISTORY',     450, 20, 50, NULL, 6, 104, '01-AUG-2025')
    INTO BOOK VALUES (13, 'INDIAN HISTORY',    470, 15, 55, NULL, 6, 105, '31-JUL-2025')
    INTO BOOK VALUES (14, 'MICRO ECONOMICS',   400, 18, 40, NULL, 7, 106, '30-JUL-2025')
    INTO BOOK VALUES (15, 'MACRO ECONOMICS',   420, 22, 45, NULL, 7, 107, '29-JUL-2025')
    INTO BOOK VALUES (16, 'ENGLISH LITERATURE',380, 10, 30, NULL, 8, 108, '28-JUL-2025')
    INTO BOOK VALUES (17, 'SHAKESPEARE WORKS', 450, 12, 40, NULL, 8, 101, '27-JUL-2025')
    INTO BOOK VALUES (18, 'NETWORKING BASICS', 550, 14, 70, NULL, 1, 102, '26-JUL-2025')
    INTO BOOK VALUES (19, 'DATABASE SYSTEMS',  600, 16, 80, NULL, 1, 103, '25-JUL-2025')
    INTO BOOK VALUES (20, 'THERMODYNAMICS',    500, 20, 60, NULL, 2, 104, '24-JUL-2025')
    INTO BOOK VALUES (21, 'QUANTUM MECHANICS', 650, 10, 90, NULL, 2, 105, '23-JUL-2025')
    INTO BOOK VALUES (22, 'STATISTICS BASICS', 480, 12, 50, NULL, 3, 106, '22-JUL-2025')
    INTO BOOK VALUES (23, 'TRIGONOMETRY',      420, 18, 45, NULL, 3, 107, '21-JUL-2025')
    INTO BOOK VALUES (24, 'PHYSICAL CHEMISTRY',580, 14, 75, NULL, 4, 108, '20-JUL-2025')
    INTO BOOK VALUES (25, 'BOTANY BASICS',     500, 15, 55, NULL, 5, 101, '19-JUL-2025')
SELECT * FROM DUAL;

----------------------------------------------------
-- 1. PROCEDURE : MOST EXPENSIVE BOOK
----------------------------------------------------

CREATE OR REPLACE PROCEDURE MOSTEXPENSIVEBOOK
AS
    CURSOR VDATA IS
        SELECT BOOK_NAME, BOOK_PRICE, BOOK_QTY
        FROM BOOK B
        WHERE BOOK_PRICE IN (SELECT MAX(BOOK_PRICE) FROM BOOK);
BEGIN
    FOR REC IN VDATA LOOP
        DBMS_OUTPUT.PUT_LINE(
            'NAME = ' || REC.BOOK_NAME ||
            ', PRICE = ' || REC.BOOK_PRICE ||
            ', QTY = ' || REC.BOOK_QTY
        );
    END LOOP;
END;
/

BEGIN
    MOSTEXPENSIVEBOOK();
END;
/

----------------------------------------------------
-- 2. PROCEDURE : COUNT TOTAL BOOKS OF A SUBJECT
----------------------------------------------------

CREATE OR REPLACE PROCEDURE TOTBOOKBYSUBJECT
(
    TBOOKSUBJECT_NAME BOOKSUBJECT.BOOKSUBJECT_NAME%TYPE
)
AS
    TOT NUMBER;
BEGIN
    SELECT COUNT(*) INTO TOT
    FROM BOOK B, BOOKSUBJECT BS 
    WHERE BS.BOOKSUB_ID = B.BOOKSUB_ID
      AND BS.BOOKSUBJECT_NAME = TBOOKSUBJECT_NAME;

    DBMS_OUTPUT.PUT_LINE('TOTAL BOOK IS : ' || TOT);
END;
/

BEGIN
    TOTBOOKBYSUBJECT('COMPUTER SCIENCE');
END;
/

----------------------------------------------------
-- 3. PROCEDURE : BOOKS BY AN AUTHOR
----------------------------------------------------

CREATE OR REPLACE PROCEDURE BOOKSBYAUTHOR
(
    TAUTHOR_NAME AUTHOR.AUTHOR_NAME%TYPE
)
AS
    CURSOR VDATA IS
        SELECT B.BOOK_ID, B.BOOK_NAME, B.BOOK_PRICE, BS.BOOKSUBJECT_NAME
        FROM BOOK B, AUTHOR A, BOOKSUBJECT BS
        WHERE BS.BOOKSUB_ID = B.BOOKSUB_ID
          AND A.AUTHOR_ID = B.AUTHOR_ID
          AND A.AUTHOR_NAME = TAUTHOR_NAME;
BEGIN
    FOR REC IN VDATA LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID = ' || REC.BOOK_ID ||
            ', NAME = ' || REC.BOOK_NAME ||
            ', PRICE = ' || REC.BOOK_PRICE ||
            ', SUBJECT = ' || REC.BOOKSUBJECT_NAME
        );
    END LOOP;
END;
/

BEGIN
    BOOKSBYAUTHOR('JAMES SMITH');
END;
/

----------------------------------------------------
-- 4. PROCEDURE : Total Amount of Book Purchased in a Particular Duration
----------------------------------------------------
CREATE OR REPLACE PROCEDURE duration
(SDATE DATE, EDATE DATE)
AS
    TDATA NUMBER;
BEGIN
    SELECT (BOOK_PRICE * BOOK_QTY) INTO TDATA
    FROM BOOK
    WHERE PURCHASEDATE BETWEEN SDATE AND EDATE;

    DBMS_OUTPUT.PUT_LINE('TOTAL IS : '|| TDATA);
END;

BEGIN
    duration(TO_DATE('06-AUG-25','DD-MON-YYY'),TO_DATE('06-AUG-25','DD-MON-YYY'));
END;



----------------------------------------------------
-- 6. Package : Create Specification 
----------------------------------------------------

CREATE OR REPLACE PACKAGE DATADATA AS

    -- Procedure to find and display the most expensive book(s)
    PROCEDURE MOSTEXPENSIVEBOOK;

    -- Procedure to count total books for a given subject
    PROCEDURE TOTBOOKBYSUBJECT (
        p_subject_name IN BOOKSUBJECT.BOOKSUBJECT_NAME%TYPE
    );

    -- Procedure to list all books by a specific author
    PROCEDURE BOOKSBYAUTHOR (
        p_author_name IN AUTHOR.AUTHOR_NAME%TYPE
    );

    -- Procedure to calculate the total purchase amount within a date range
    PROCEDURE TOTALPURCHASEAMOUNT (
        p_start_date IN DATE,
        p_end_date   IN DATE
    );

END DATADATA;
/

----------------------------------------------------
-- 6. Package : Create Body 
----------------------------------------------------
    
CREATE OR REPLACE PACKAGE BODY DATADATA AS

    PROCEDURE MOSTEXPENSIVEBOOK AS
        CURSOR v_data IS
            SELECT BOOK_NAME, BOOK_PRICE, BOOK_QTY
            FROM BOOK
            WHERE BOOK_PRICE = (SELECT MAX(BOOK_PRICE) FROM BOOK); -- Use '=' for efficiency
    BEGIN
        FOR rec IN v_data LOOP
            DBMS_OUTPUT.PUT_LINE(
                'NAME = ' || rec.BOOK_NAME ||
                ', PRICE = ' || rec.BOOK_PRICE ||
                ', QTY = ' || rec.BOOK_QTY
            );
        END LOOP;
    END MOSTEXPENSIVEBOOK;

    PROCEDURE TOTBOOKBYSUBJECT (
        p_subject_name IN BOOKSUBJECT.BOOKSUBJECT_NAME%TYPE
    ) AS
        v_total NUMBER;
    BEGIN
        -- Using modern ANSI JOIN syntax for clarity
        SELECT COUNT(*)
        INTO v_total
        FROM BOOK b
        JOIN BOOKSUBJECT bs ON b.BOOKSUB_ID = bs.BOOKSUB_ID
        WHERE bs.BOOKSUBJECT_NAME = p_subject_name;

        DBMS_OUTPUT.PUT_LINE('Total books for subject "' || p_subject_name || '": ' || v_total);
    END TOTBOOKBYSUBJECT;

    PROCEDURE BOOKSBYAUTHOR (
        p_author_name IN AUTHOR.AUTHOR_NAME%TYPE
    ) AS
        CURSOR v_data IS
            -- Using modern ANSI JOIN syntax for clarity
            SELECT b.BOOK_ID, b.BOOK_NAME, b.BOOK_PRICE, bs.BOOKSUBJECT_NAME
            FROM BOOK b
            JOIN AUTHOR a ON b.AUTHOR_ID = a.AUTHOR_ID
            JOIN BOOKSUBJECT bs ON b.BOOKSUB_ID = bs.BOOKSUB_ID
            WHERE a.AUTHOR_NAME = p_author_name;
    BEGIN
        FOR rec IN v_data LOOP
            DBMS_OUTPUT.PUT_LINE(
                'ID = ' || rec.BOOK_ID ||
                ', NAME = ' || rec.BOOK_NAME ||
                ', PRICE = ' || rec.BOOK_PRICE ||
                ', SUBJECT = ' || rec.BOOKSUBJECT_NAME
            );
        END LOOP;
    END BOOKSBYAUTHOR;

    PROCEDURE TOTALPURCHASEAMOUNT (
        p_start_date IN DATE,
        p_end_date   IN DATE
    ) AS
        v_total_amount NUMBER;
    BEGIN
        SELECT SUM(BOOK_PRICE * BOOK_QTY)
        INTO v_total_amount
        FROM BOOK
        WHERE PURCHASEDATE BETWEEN p_start_date AND p_end_date;

        DBMS_OUTPUT.PUT_LINE('Total purchase amount is: ' || NVL(v_total_amount, 0));
    END TOTALPURCHASEAMOUNT;

END DATADATA;
/

