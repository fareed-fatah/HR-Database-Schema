-- ===================================================
-- File: advanced_database_schema.sql
-- Description: Oracle 11g Database Schema with Constraints, FKs, Indexes, Comments & Sequences
-- Created for: HR, Finance, Document & Security Management System
-- ===================================================


-- ---------------------------------------------------
-- SEQUENCES (تسلسلات للأرقام التلقائية)
-- ---------------------------------------------------

CREATE SEQUENCE SEQ_HOLIDAYS_MEMO START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_VAC_INSRT_SERIAL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_AMAR_FRDI_SERIAL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_TRGEEM_SERIAL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_DOC_NUM START WITH 100000 INCREMENT BY 1;
CREATE SEQUENCE SEQ_USER_ID START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE SEQ_BEN_NUM START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ALLOW_NUM START WITH 1 INCREMENT BY 1;


-- ---------------------------------------------------
-- Table: HOLIDAYS
-- ---------------------------------------------------
CREATE TABLE holidays (
    HOLIDAY_NAME    VARCHAR2(50),
    HOLIDAY_DATE    DATE,
    INSERT_DATE     DATE DEFAULT SYSDATE,
    USER_ID         NUMBER(6),
    HOLIDAY_MEMO    NUMBER DEFAULT SEQ_HOLIDAYS_MEMO.NEXTVAL,
    CONSTRAINT PK_HOLIDAYS PRIMARY KEY (HOLIDAY_MEMO)
);

COMMENT ON TABLE holidays IS 'جدول الأعياد والإجازات الرسمية';
COMMENT ON COLUMN holidays.HOLIDAY_NAME IS 'اسم العيد';
COMMENT ON COLUMN holidays.HOLIDAY_DATE IS 'تاريخ العيد';
COMMENT ON COLUMN holidays.USER_ID IS 'رقم المستخدم الذي أدخل البيانات';


-- ---------------------------------------------------
-- Table: BRANCHES_TBL
-- ---------------------------------------------------
CREATE TABLE BRANCHES_TBL (
    BRANCH_ID       NUMBER(5) NOT NULL,
    BRANCH_NAME     VARCHAR2(50),
    CONSTRAINT PK_BRANCHES PRIMARY KEY (BRANCH_ID)
);

COMMENT ON TABLE BRANCHES_TBL IS 'فروع المؤسسة';
COMMENT ON COLUMN BRANCHES_TBL.BRANCH_ID IS 'رقم الفرع';
COMMENT ON COLUMN BRANCHES_TBL.BRANCH_NAME IS 'اسم الفرع';


-- ---------------------------------------------------
-- Table: DEPT
-- ---------------------------------------------------
CREATE TABLE dept (
    DEPTNO          NUMBER(4) NOT NULL,
    DEPT_NAME       VARCHAR2(300),
    BRANCH_ID       NUMBER(5),
    ABBREV_NAME     VARCHAR2(100),
    DEPT_DEPEN      NUMBER(4),
    DEPT_ACC        VARCHAR2(20),
    DEPT_TYPE       NUMBER(4),
    IS_ACTIVE       CHAR(1) DEFAULT 'Y',
    CONSTRAINT PK_DEPT PRIMARY KEY (DEPTNO),
    CONSTRAINT FK_DEPT_BRANCH FOREIGN KEY (BRANCH_ID) REFERENCES BRANCHES_TBL(BRANCH_ID)
);

COMMENT ON TABLE dept IS 'الإدارات';
COMMENT ON COLUMN dept.IS_ACTIVE IS 'حالة النشاط: Y=نشط، N=غير نشط';


-- ---------------------------------------------------
-- Table: SECTIONS
-- ---------------------------------------------------
CREATE TABLE SECTIONS (
    SECTION_NO      NUMBER(4),
    SECTION_NAME    VARCHAR2(200),
    DEPT_TO_NO      NUMBER(4),
    CONSTRAINT PK_SECTIONS PRIMARY KEY (SECTION_NO),
    CONSTRAINT FK_SECTIONS_DEPT FOREIGN KEY (DEPT_TO_NO) REFERENCES dept(DEPTNO)
);

COMMENT ON TABLE SECTIONS IS 'الأقسام الفرعية داخل الإدارة';


-- ---------------------------------------------------
-- Table: PORTIONS
-- ---------------------------------------------------
CREATE TABLE PORTIONS (
    PORTION_NO      NUMBER(4),
    PORTION_NAME    VARCHAR2(200),
    SECTION_TO_NO   NUMBER(4),
    CONSTRAINT PK_PORTIONS PRIMARY KEY (PORTION_NO),
    CONSTRAINT FK_PORTIONS_SECTION FOREIGN KEY (SECTION_TO_NO) REFERENCES SECTIONS(SECTION_NO)
);


-- ---------------------------------------------------
-- Table: emp_data
-- ---------------------------------------------------
CREATE TABLE emp_data (
    EMPNO           NUMBER(7) NOT NULL,
    DEPTNO          NUMBER(4),
    BIRTH_DATE      DATE,
    HIRE_DATE       DATE,
    HIRE_TYPE       CHAR(1),
    SEX_TYPE        CHAR(1),
    CONSTRAINT PK_EMP_DATA PRIMARY KEY (EMPNO),
    CONSTRAINT FK_EMP_DEPT FOREIGN KEY (DEPTNO) REFERENCES dept(DEPTNO)
);

COMMENT ON TABLE emp_data IS 'بيانات التوظيف للموظفين';
COMMENT ON COLUMN emp_data.HIRE_TYPE IS 'نوع التعيين: داخلي، خارجي...';
COMMENT ON COLUMN emp_data.SEX_TYPE IS 'الجنس: M / F';


-- ---------------------------------------------------
-- Table: FIXED_DATA
-- ---------------------------------------------------
CREATE TABLE FIXED_DATA (
    EMP_NO          NUMBER(6),
    EMP_NAME        VARCHAR2(50),
    NATIONAL_NO     VARCHAR2(15),
    LOAN_NO         VARCHAR2(15),
    HIRE_DATE       DATE,
    APPOINTEMENT_DATE DATE,
    RETIRE_RESON_NO NUMBER(4),
    SEX_NO          CHAR(1),
    END_HIRE_DATE   DATE,
    CONSTRAINT PK_FIXED_DATA PRIMARY KEY (EMP_NO),
    CONSTRAINT FK_FIXED_EMP FOREIGN KEY (EMP_NO) REFERENCES emp_data(EMPNO)
);


-- ---------------------------------------------------
-- Table: SOCIALANDPERSONAL_DATA
-- ---------------------------------------------------
CREATE TABLE SOCIALANDPERSONAL_DATA (
    EMP_NO          NUMBER(6),
    SOCIAL_STATUS   NUMBER(4),
    BRITH_DATE      DATE,
    BRITH_PLACE     VARCHAR2(50),
    IDENTITY_TYPE_NO NUMBER(4),
    IDENTITY_NO     VARCHAR2(15),
    ADDRESS         VARCHAR2(60),
    TELEPHONE       VARCHAR2(15),
    OTHER_PHONE     VARCHAR2(15),
    SOCIAL_PHONE    VARCHAR2(15),
    OFFICE_PHONE    NUMBER(6),
    WORK_SERVICE    CHAR(1),
    CONSTRAINT PK_SOCIAL_DATA PRIMARY KEY (EMP_NO),
    CONSTRAINT FK_SOCIAL_EMP FOREIGN KEY (EMP_NO) REFERENCES emp_data(EMPNO)
);


-- ---------------------------------------------------
-- Table: LEVELS
-- ---------------------------------------------------
CREATE TABLE LEVELS (
    LEVEL_NO        VARCHAR2(2),
    LEVEL_NAME      VARCHAR2(20),
    CONSTRAINT PK_LEVELS PRIMARY KEY (LEVEL_NO)
);


-- ---------------------------------------------------
-- Table: DEGREES
-- ---------------------------------------------------
CREATE TABLE DEGREES (
    DEGREE_NO       NUMBER(2),
    LEVEL_NO        VARCHAR2(2),
    DEGREE_NAME     VARCHAR2(50),
    CONSTRAINT PK_DEGREES PRIMARY KEY (DEGREE_NO, LEVEL_NO),
    CONSTRAINT FK_DEGREES_LEVEL FOREIGN KEY (LEVEL_NO) REFERENCES LEVELS(LEVEL_NO)
);


-- ---------------------------------------------------
-- Table: CHANGEABLE_DATA
-- ---------------------------------------------------
CREATE TABLE CHANGEABLE_DATA (
    EMP_NO          NUMBER(6),
    CYCLE_NO        NUMBER(6),
    LEVEL_NO        VARCHAR2(2),
    DEGREE_NO       NUMBER(2),
    JOB_NO          NUMBER(4),
    JOB_TYPE_NO     NUMBER(4),
    BRANCH_NO       NUMBER(4),
    DEPT_NO         NUMBER(4),
    SECTION_NO      NUMBER(6),
    PORTION_NO      NUMBER(6),
    CONSTRAINT PK_CHANGEABLE PRIMARY KEY (EMP_NO, CYCLE_NO),
    CONSTRAINT FK_CHANGEABLE_EMP FOREIGN KEY (EMP_NO) REFERENCES emp_data(EMPNO),
    CONSTRAINT FK_CHANGEABLE_LEVEL FOREIGN KEY (LEVEL_NO) REFERENCES LEVELS(LEVEL_NO),
    CONSTRAINT FK_CHANGEABLE_DEGREE FOREIGN KEY (DEGREE_NO, LEVEL_NO) REFERENCES DEGREES(DEGREE_NO, LEVEL_NO)
);


-- ---------------------------------------------------
-- Table: users
-- ---------------------------------------------------
CREATE TABLE users (
    USER_ID         NUMBER(6) NOT NULL,
    USER_NAME       VARCHAR2(100),
    USER_PASS       VARCHAR2(20),
    USER_STATUS     CHAR(1) DEFAULT 'A',
    USER_HINT       VARCHAR2(100),
    USER_FLAG       CHAR(1),
    SDATE           DATE,
    EDATE           DATE,
    CONSTRAINT PK_USERS PRIMARY KEY (USER_ID)
);

-- تعيين القيمة الافتراضية للمستخدم
CREATE OR REPLACE TRIGGER TRG_SET_USER_ID
    BEFORE INSERT ON users
    FOR EACH ROW
BEGIN
    IF :NEW.USER_ID IS NULL THEN
        :NEW.USER_ID := SEQ_USER_ID.NEXTVAL;
    END IF;
END;
/

COMMENT ON TABLE users IS 'جدول المستخدمين للنظام';
COMMENT ON COLUMN users.USER_STATUS IS 'A=نشط، I=معطل';


-- ---------------------------------------------------
-- Table: SECURITY
-- ---------------------------------------------------
CREATE TABLE SECURITY (
    ID              VARCHAR2(6),
    FROMID          VARCHAR2(10),
    SCREEN_NAME     VARCHAR2(50),
    OPEN            VARCHAR2(1),
    INSERT1         VARCHAR2(1),
    UPDATE1         VARCHAR2(1),
    DELETE1         VARCHAR2(1),
    PRINT           VARCHAR2(1),
    POST            VARCHAR2(1),
    COMFIRM         VARCHAR2(1),
    ACTIVE          VARCHAR2(1),
    CONSTRAINT PK_SECURITY PRIMARY KEY (ID)
);


-- ---------------------------------------------------
-- Table: VACATIONS_TYPE
-- ---------------------------------------------------
CREATE TABLE VACATIONS_TYPE (
    VAC_NO          NUMBER(4),
    VAC_NAME        VARCHAR2(200),
    ADD_TO          NUMBER(4),
    TREAT_BLA_TYPE  NUMBER(1),
    BLANCE          NUMBER(4),
    ADD_OR_REDUCED  CHAR(1),
    ONLY_FOR_SEX    CHAR(1),
    BADEAH          VARCHAR2(10),
    CONSTRAINT PK_VAC_TYPE PRIMARY KEY (VAC_NO)
);


-- ---------------------------------------------------
-- Table: VAC_INSRT
-- ---------------------------------------------------
CREATE TABLE VAC_INSRT (
    USER_ID         NUMBER(6),
    INSRT_DATE      DATE DEFAULT SYSDATE,
    SERIAL_NO       NUMBER(4),
    EMP_NO          NUMBER(6),
    VAC_TYPE_NO     NUMBER(4),
    ORDER_NO        VARCHAR2(15),
    DRAFT_BLANCE    NUMBER(4),
    SDATE           DATE,
    EDATE           DATE,
    IS_OK           CHAR(1) DEFAULT 'N',
    LIST_DATE       DATE NOT NULL,
    MOTAH           NUMBER(4),
    CONSTRAINT PK_VAC_INSRT PRIMARY KEY (SERIAL_NO, LIST_DATE),
    CONSTRAINT FK_VAC_USER FOREIGN KEY (USER_ID) REFERENCES users(USER_ID),
    CONSTRAINT FK_VAC_EMP FOREIGN KEY (EMP_NO) REFERENCES emp_data(EMPNO),
    CONSTRAINT FK_VAC_TYPE FOREIGN KEY (VAC_TYPE_NO) REFERENCES VACATIONS_TYPE(VAC_NO)
);

CREATE SEQUENCE SEQ_VAC_SERIAL START WITH 1 INCREMENT BY 1;


-- ---------------------------------------------------
-- Table: BEN_TBL
-- ---------------------------------------------------
CREATE TABLE BEN_TBL (
    BEN_NUM         NUMBER NOT NULL,
    BEN_NAM         VARCHAR2(200) NOT NULL,
    BEN_TYPE_NO     CHAR(1),
    BEN_TEL         VARCHAR2(10),
    BEN_DEALER      VARCHAR2(200),
    CONSTRAINT PK_BEN_TBL PRIMARY KEY (BEN_NUM)
);

CREATE OR REPLACE TRIGGER TRG_SET_BEN_NUM
    BEFORE INSERT ON BEN_TBL
    FOR EACH ROW
BEGIN
    IF :NEW.BEN_NUM IS NULL THEN
        :NEW.BEN_NUM := SEQ_BEN_NUM.NEXTVAL;
    END IF;
END;
/


-- ---------------------------------------------------
-- Table: CURRENCIES
-- ---------------------------------------------------
CREATE TABLE CURRENCIES (
    CUR_NUM         NUMBER(10) NOT NULL,
    CUR_NAM         VARCHAR2(100) NOT NULL,
    CUR_FRA         VARCHAR2(20),
    CUR_COUN        VARCHAR2(7) NOT NULL,
    CONSTRAINT PK_CURRENCIES PRIMARY KEY (CUR_NUM)
);


-- ---------------------------------------------------
-- Table: ALLOWANCE
-- ---------------------------------------------------
CREATE TABLE ALLOWANCE (
    ALLOW_NUM       NUMBER NOT NULL,
    ALLOW_NAM       VARCHAR2(100) NOT NULL,
    FILE_NUM        NUMBER(4),
    DESC_TXT        VARCHAR2(200),
    ALLOW_TYPE      NUMBER(1),
    ALLOW_ACC       NUMBER(15),
    TAX_TYPE        NUMBER(4),
    IS_ACTIVE       CHAR(1) DEFAULT 'Y',
    GOV_SUB         CHAR(1),
    EMP_SUB         CHAR(1),
    ESABA_SUB       CHAR(1),
    CONSTRAINT PK_ALLOWANCE PRIMARY KEY (ALLOW_NUM)
);

CREATE OR REPLACE TRIGGER TRG_SET_ALLOW_NUM
    BEFORE INSERT ON ALLOWANCE
    FOR EACH ROW
BEGIN
    IF :NEW.ALLOW_NUM IS NULL THEN
        :NEW.ALLOW_NUM := SEQ_ALLOW_NUM.NEXTVAL;
    END IF;
END;
/


-- ---------------------------------------------------
-- Table: AMAR_FRDI
-- ---------------------------------------------------
CREATE TABLE AMAR_FRDI (
    SERIAL_NO       VARCHAR2(5) NOT NULL,
    DOC_NUM         VARCHAR2(12) NOT NULL,
    BEN_NUM         NUMBER(6) NOT NULL,
    AMAR_TYPE       NUMBER NOT NULL,
    ALLOW_TYPE_NUM  NUMBER NOT NULL,
    THE_AMOUNT      NUMBER NOT NULL,
    SUB_TXT         VARCHAR2(500) NOT NULL,
    AMAR_TYPE_OK    NUMBER,
    INS_USR         VARCHAR2(5) NOT NULL,
    INS_DAT         DATE NOT NULL,
    AMAR_OK         NUMBER,
    RELATION_TO_OTHER NUMBER,
    CUR_COUN        VARCHAR2(7),
    CONSTRAINT PK_AMAR_FRDI PRIMARY KEY (SERIAL_NO, DOC_NUM),
    CONSTRAINT FK_AMAR_BEN FOREIGN KEY (BEN_NUM) REFERENCES BEN_TBL(BEN_NUM),
    CONSTRAINT FK_AMAR_ALLOW FOREIGN KEY (ALLOW_TYPE_NUM) REFERENCES ALLOWANCE(ALLOW_NUM),
    CONSTRAINT FK_AMAR_CUR FOREIGN KEY (CUR_COUN) REFERENCES CURRENCIES(CUR_COUN)
);

CREATE INDEX IDX_AMAR_BEN ON AMAR_FRDI(BEN_NUM);
CREATE INDEX IDX_AMAR_DOC ON AMAR_FRDI(DOC_NUM);


-- ---------------------------------------------------
-- Table: TRGEEM
-- ---------------------------------------------------
CREATE TABLE TRGEEM (
    SERIAL_NO       NUMBER(4) NOT NULL,
    DOC_NUM         NUMBER(15) NOT NULL,
    ALLOW_NUM       NUMBER,
    ERSHEEF_NUM     NUMBER(3),
    TRGEEM_DAT      DATE NOT NULL,
    USR             NUMBER(6) NOT NULL,
    DOC_SUB         VARCHAR2(300),
    AMAR_TYPE_NO    NUMBER(3),
    CUR_NUM         VARCHAR2(5),
    SIDE_PREFIX     VARCHAR2(20),
    MID_PREFIX      VARCHAR2(20),
    IS_OK           NUMBER(1) DEFAULT 0,
    THE_AMOUNT      NUMBER(15,2),
    CONSTRAINT PK_TRGEEM PRIMARY KEY (SERIAL_NO, DOC_NUM),
    CONSTRAINT FK_TRGEEM_USER FOREIGN KEY (USR) REFERENCES users(USER_ID),
    CONSTRAINT FK_TRGEEM_ALLOW FOREIGN KEY (ALLOW_NUM) REFERENCES ALLOWANCE(ALLOW_NUM)
);


-- ---------------------------------------------------
-- Table: DOCS_TBL
-- ---------------------------------------------------
CREATE TABLE DOCS_TBL (
    DOC_NUM         NUMBER(15),
    DOC_TYPE        NUMBER(1),
    DOC_INFO        VARCHAR2(200),
    DOC_SHAPE       NUMBER(2),
    SECRET_TYPE     NUMBER(1),
    IS_OK           NUMBER(1),
    INS_DAT         DATE,
    USR             NUMBER(6),
    DOC_YEAR        VARCHAR2(4),
    DOC_SEQ         VARCHAR2(5),
    DOC_ADDON       VARCHAR2(2),
    DOC_FACE        VARCHAR2(1),
    CONSTRAINT PK_DOCS_TBL PRIMARY KEY (DOC_NUM),
    CONSTRAINT FK_DOCS_USER FOREIGN KEY (USR) REFERENCES users(USER_ID)
);

-- استخدام التسلسل للحقل DOC_NUM
CREATE OR REPLACE TRIGGER TRG_SET_DOC_NUM
    BEFORE INSERT ON DOCS_TBL
    FOR EACH ROW
BEGIN
    IF :NEW.DOC_NUM IS NULL THEN
        :NEW.DOC_NUM := SEQ_DOC_NUM.NEXTVAL;
    END IF;
END;
/


-- ---------------------------------------------------
-- Table: COUNTRIES, GOVERNORATES, PROVINCES, CITIES
-- ---------------------------------------------------
CREATE TABLE COUNTRIES (
    COUNTRY_NO      VARCHAR2(4) NOT NULL,
    COUNTRY_NAME    VARCHAR2(200) NOT NULL,
    CONSTRAINT PK_COUNTRIES PRIMARY KEY (COUNTRY_NO)
);

CREATE TABLE GOVERNORATES (
    GOV_NO          NUMBER(4) NOT NULL,
    GOV_NAME        VARCHAR2(200) NOT NULL,
    COUNTRY_NO      VARCHAR2(4) NOT NULL,
    CONSTRAINT PK_GOV PRIMARY KEY (GOV_NO),
    CONSTRAINT FK_GOV_COUNTRY FOREIGN KEY (COUNTRY_NO) REFERENCES COUNTRIES(COUNTRY_NO)
);

CREATE TABLE PROVINCES (
    PROVINCE_NO     NUMBER(4) NOT NULL,
    PROVINCE_NAME   VARCHAR2(200) NOT NULL,
    GOV_NO          NUMBER(4) NOT NULL,
    CONSTRAINT PK_PROVINCES PRIMARY KEY (PROVINCE_NO),
    CONSTRAINT FK_PROV_GOV FOREIGN KEY (GOV_NO) REFERENCES GOVERNORATES(GOV_NO)
);

CREATE TABLE CITIES (
    CITY_NO         NUMBER(4) NOT NULL,
    CITY_NAME       VARCHAR2(200) NOT NULL,
    PROVINCE_NO     NUMBER(4) NOT NULL,
    CONSTRAINT PK_CITIES PRIMARY KEY (CITY_NO),
    CONSTRAINT FK_CITY_PROV FOREIGN KEY (PROVINCE_NO) REFERENCES PROVINCES(PROVINCE_NO)
);


-- ---------------------------------------------------
-- Table: EMP_IDEN_INFO
-- ---------------------------------------------------
CREATE TABLE EMP_IDEN_INFO (
    EMP_NO              NUMBER(5),
    IDEN_TYPE_NO        NUMBER(3),
    IDEN_NO             VARCHAR2(20),
    IDEN_DATE           DATE,
    IDEN_ISSUE_GOV      NUMBER(3),
    IDEN_ISSUE_PROVINCE NUMBER(3),
    IDEN_ISSUE_CITY     NUMBER(3),
    CONSTRAINT PK_EMP_IDEN PRIMARY KEY (EMP_NO),
    CONSTRAINT FK_EMP_IDEN_EMP FOREIGN KEY (EMP_NO) REFERENCES emp_data(EMPNO),
    CONSTRAINT FK_IDEN_GOV FOREIGN KEY (IDEN_ISSUE_GOV) REFERENCES GOVERNORATES(GOV_NO),
    CONSTRAINT FK_IDEN_CITY FOREIGN KEY (IDEN_ISSUE_CITY) REFERENCES CITIES(CITY_NO)
);


-- ---------------------------------------------------
-- Table: JOBS
-- ---------------------------------------------------
CREATE TABLE JOBS (
    JOB_NO          NUMBER(10),
    JOB_NAME        VARCHAR2(200),
    JOB_TYPE        NUMBER(1),
    CONSTRAINT PK_JOBS PRIMARY KEY (JOB_NO)
);


-- ---------------------------------------------------
-- Table: LEADER_HISTORY
-- ---------------------------------------------------
CREATE TABLE LEADER_HISTORY (
    OBJ_TYPE        NUMBER(1),
    OBJ_NO          NUMBER(4),
    JOB_NO          NUMBER(4),
    LEADER_NO       NUMBER(6),
    DES_TYPE        NUMBER(1),
    SDATE           DATE,
    EDATE           DATE,
    DOC_NUM         NUMBER(20),
    DES_ISSUE       NUMBER(2),
    CONSTRAINT FK_LEADER_JOB FOREIGN KEY (JOB_NO) REFERENCES JOBS(JOB_NO),
    CONSTRAINT FK_LEADER_EMP FOREIGN KEY (LEADER_NO) REFERENCES emp_data(EMPNO)
);

-- مركبة من (OBJ_TYPE, OBJ_NO, SDATE)
-- لا يمكن إضافتها كمفتاح رئيسي بدون تعريف مركب


-- ---------------------------------------------------
-- Table: SCREEN_TBL
-- ---------------------------------------------------
CREATE TABLE SCREEN_TBL (
    SCR_ID          NUMBER(5),
    SCR_ENAME       VARCHAR2(50),
    SCR_ANAME       VARCHAR2(50),
    SCR_TITLE       VARCHAR2(50),
    SCR_TYPE        CHAR(1),
    SCR_INFO        VARCHAR2(50),
    CONSTRAINT PK_SCREEN_TBL PRIMARY KEY (SCR_ID)
);


-- ---------------------------------------------------
-- Table: SYSTEMS_TBL
-- ---------------------------------------------------
CREATE TABLE SYSTEMS_TBL (
    SYS_ID          NUMBER(5),
    SYS_ENAME       VARCHAR2(50),
    SYS_ANAME       VARCHAR2(50),
    SYS_TITLE       VARCHAR2(50),
    SYS_INFO        VARCHAR2(50),
    CONSTRAINT PK_SYSTEMS_TBL PRIMARY KEY (SYS_ID)
);


-- ---------------------------------------------------
-- Table: PRIVS_TBL
-- ---------------------------------------------------
CREATE TABLE PRIVS_TBL (
    PRIV_ID         NUMBER(5),
    PRIV_NAME       VARCHAR2(50),
    CONSTRAINT PK_PRIVS_TBL PRIMARY KEY (PRIV_ID)
);


-- ---------------------------------------------------
-- Table: USERS_PRIVS
-- ---------------------------------------------------
CREATE TABLE USERS_PRIVS (
    USER_ID         NUMBER(5),
    PRIV_ID         NUMBER(5),
    CONSTRAINT PK_USERS_PRIVS PRIMARY KEY (USER_ID, PRIV_ID),
    CONSTRAINT FK_UP_USER FOREIGN KEY (USER_ID) REFERENCES users(USER_ID),
    CONSTRAINT FK_UP_PRIV FOREIGN KEY (PRIV_ID) REFERENCES PRIVS_TBL(PRIV_ID)
);


-- ---------------------------------------------------
-- Table: SCREEN_PRIVS
-- ---------------------------------------------------
CREATE TABLE SCREEN_PRIVS (
    PRIV_ID         NUMBER(5),
    SYS_ID          NUMBER(5),
    OPEN            CHAR(1),
    SELECT1         CHAR(1),
    INSERT1         CHAR(1),
    UPDATE1         CHAR(1),
    DELETE1         CHAR(1),
    PRINT           CHAR(1),
    POST            CHAR(1),
    COMFIRM         CHAR(1),
    ACTIVE          CHAR(1),
    SCREEN_ID       NUMBER(6),
    CONSTRAINT PK_SCREEN_PRIVS PRIMARY KEY (PRIV_ID, SCREEN_ID),
    CONSTRAINT FK_SP_PRIV FOREIGN KEY (PRIV_ID) REFERENCES PRIVS_TBL(PRIV_ID),
    CONSTRAINT FK_SP_SCR FOREIGN KEY (SCREEN_ID) REFERENCES SCREEN_TBL(SCR_ID)
);


-- ---------------------------------------------------
-- Table: USERS_BRANCHES
-- ---------------------------------------------------
CREATE TABLE USERS_BRANCHES (
    USER_ID         NUMBER(5),
    BRANCH_ID       NUMBER(5),
    SYS_ID          NUMBER(5),
    CONSTRAINT PK_USERS_BRANCHES PRIMARY KEY (USER_ID, BRANCH_ID, SYS_ID),
    CONSTRAINT FK_UB_USER FOREIGN KEY (USER_ID) REFERENCES users(USER_ID),
    CONSTRAINT FK_UB_BRANCH FOREIGN KEY (BRANCH_ID) REFERENCES BRANCHES_TBL(BRANCH_ID),
    CONSTRAINT FK_UB_SYS FOREIGN KEY (SYS_ID) REFERENCES SYSTEMS_TBL(SYS_ID)
);


-- ---------------------------------------------------
-- Table: GEN_LISTS
-- ---------------------------------------------------
CREATE TABLE GEN_LISTS (
    BRANCH_NO       NUMBER(4),
    LIST_NO         NUMBER(4),
    LIST_NAME       VARCHAR2(200),
    DESC_TXT        VARCHAR2(200),
    DOWN_LNK        VARCHAR2(50),
    UP_LNK          VARCHAR2(50),
    SIGN_SHOW       CHAR(1),
    EQUAL_SIDES     CHAR(1),
    COPY_DATA       CHAR(1),
    CLOSE_ORDR      NUMBER(2),
    CONSTRAINT PK_GEN_LISTS PRIMARY KEY (BRANCH_NO, LIST_NO)
);


-- ---------------------------------------------------
-- Table: CLOSE_LISTS
-- ---------------------------------------------------
CREATE TABLE CLOSE_LISTS (
    BRANCH_NO       NUMBER(4),
    CYCLE_NO        NUMBER(6),
    LIST_NO         NUMBER(4),
    IS_CLOSED       CHAR(1),
    CLOSE_DATE      DATE,
    CLOSE_USR       NUMBER(6),
    CONSTRAINT PK_CLOSE_LISTS PRIMARY KEY (BRANCH_NO, CYCLE_NO, LIST_NO),
    CONSTRAINT FK_CLOSE_USER FOREIGN KEY (CLOSE_USR) REFERENCES users(USER_ID)
);


-- ---------------------------------------------------
-- Table: INS_LISTS
-- ---------------------------------------------------
CREATE TABLE INS_LISTS (
    CYCLE_NO        NUMBER(6),
    BRANCH_NO       NUMBER(4),
    LIST_NO         NUMBER(4),
    EMP_NO          NUMBER(6),
    MRKZ_NUM        NUMBER(4),
    ALLOW_NUM       NUMBER(4),
    THE_AMOUNT      NUMBER(15,2),
    IS_OK           CHAR(1),
    COL_1           NUMBER(4),
    COL_2           NUMBER(4),
    SEQ             NUMBER(4),
    DOC_NUM_I       NUMBER(15),
    CONSTRAINT PK_INS_LISTS PRIMARY KEY (CYCLE_NO, BRANCH_NO, LIST_NO, EMP_NO),
    CONSTRAINT FK_INS_EMP FOREIGN KEY (EMP_NO) REFERENCES emp_data(EMPNO),
    CONSTRAINT FK_INS_DOC FOREIGN KEY (DOC_NUM_I) REFERENCES DOCS_TBL(DOC_NUM)
);


-- ---------------------------------------------------
-- Table: MARAKEZ_TBL
-- ---------------------------------------------------
CREATE TABLE MARAKEZ_TBL (
    MRKZ_NUM        NUMBER(4),
    MRKZ_NAM        VARCHAR2(300),
    MRKZ_ACC        VARCHAR2(20),
    MRKZ_INFO       VARCHAR2(300),
    IS_OK           CHAR(1),
    CONSTRAINT PK_MARAKEZ PRIMARY KEY (MRKZ_NUM)
);


-- ---------------------------------------------------
-- Table: adrs
-- ---------------------------------------------------
CREATE TABLE adrs (
    ADRS_NO         NUMBER(4),
    ADRS_NAME       VARCHAR2(300),
    PROVINCE_NO     NUMBER(4),
    CONSTRAINT PK_ADRS PRIMARY KEY (ADRS_NO),
    CONSTRAINT FK_ADRS_PROV FOREIGN KEY (PROVINCE_NO) REFERENCES PROVINCES(PROVINCE_NO)
);


-- ===================================================
-- END OF FILE
-- يمكنك تنفيذ هذا الملف كاملاً في Oracle SQL Developer
-- ===================================================
