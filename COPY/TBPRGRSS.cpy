           EXEC SQL DECLARE PROGRESS TABLE
           ( USERID                         CHAR(8) NOT NULL,
             FRAGMENT                       CHAR(8) NOT NULL,
             POINTS                         INTEGER NOT NULL
           ) END-EXEC.
      *
       01 DCLPROGRESS.
          10 USERID                PIC X(8).
          10 FRAGMENT              PIC X(8).
          10 POINTS                PIC S9(9) USAGE COMP-5.