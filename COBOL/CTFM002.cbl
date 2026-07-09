       IDENTIFICATION DIVISION.
       PROGRAM-ID. CTFM002
      *===============================================================*
      * This program is a module for querying the CTF2026 database.   *
      * ------------------------------------------------------------- *
      * Input:                                                        *
      *   OPCODE: 'Q' for query                                       *
      * Output:                                                       *
      *   SQLCODE: DB2 SQLCODE                                        *
      * ------------------------------------------------------------- *
      * Updates:                                                      *
      *                                                               *
      * Date     Who What                                             *
      * -------- --- ------------------------------------------------ *
      * yy/mm/dd ii  description                                      *
      *===============================================================*

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           EXEC SQL INCLUDE SQLCA END-EXEC.
           EXEC SQL INCLUDE SQLDA END-EXEC.

       01 WORK.
          05 W-SQLCODE    PIC -99999.
       
       01 H-STMT1.
          49 H-STMT1-LENGTH  PIC S9(4) COMP-5.
          49 H-STMT1-TEXT    PIC X(256).

       01 ERROR-MESSAGE.
          05 ERROR-LEN    PIC S9(4) COMP
                                     VALUE +720.
          05 ERROR-TEXT   PIC X(72) OCCURS 10 TIMES
                INDEXED BY ERROR-INDEX.
       77 ERROR-TEXT-LEN  PIC S9(9) COMP
                                     VALUE +72.
       
       01 W-LCTFM002.
           COPY LCTFM002.

           EXEC SQL
              INCLUDE ACCLOG
           END-EXEC.

       LINKAGE SECTION.
       01 P-LCTFM002.
           COPY LCTFM002.

       PROCEDURE DIVISION USING P-LCTFM002.
       MAIN SECTION.
           PERFORM R001-INIT

           PERFORM R005-EXECUTE

           PERFORM R009-FINISH
           .
       MAIN-END.
           GOBACK.

      *===============================================================*
      * R001-INIT: Program initialisations                            *
      *===============================================================*
       R001-INIT SECTION.
           MOVE P-LCTFM002 TO W-LCTFM002

           MOVE 0 TO SQLCODE-C OF W-LCTFM002
           .
       R001-INIT-END.
           EXIT.

      *===============================================================*
      * R005-EXECUTE: Execute SQL query                               *
      *===============================================================*
       R005-EXECUTE SECTION.
           INITIALIZE H-STMT1-LENGTH
           INITIALIZE H-STMT1-TEXT

           MOVE SQLQUERY-LEN OF W-LCTFM002 TO H-STMT1-LENGTH
           MOVE FUNCTION DISPLAY-OF(
                   SQLQUERY-TEXT OF W-LCTFM002(1:
                   SQLQUERY-LEN OF W-LCTFM002)) TO H-STMT1-TEXT

           EXEC SQL
              DECLARE STMT1 STATEMENT
           END-EXEC

           EXEC SQL
              DECLARE CURS1 CURSOR FOR STMT1
           END-EXEC

           EXEC SQL
              PREPARE STMT1 INTO :SQLDA FROM :H-STMT1
           END-EXEC

           MOVE SQLCODE TO SQLCODE-C OF W-LCTFM002
           .
       R005-EXECUTE-END.
           EXIT.

      *===============================================================*
      * R009-FINISH: Program finalisations                            *
      *===============================================================*
       R009-FINISH SECTION.
           MOVE W-LCTFM002 TO P-LCTFM002
           .
       R009-FINISH-END.
           EXIT.

      *===============================================================*
      * R900-DSNTIAR: Format SQLCA information to display when error  *
      *===============================================================*
       R900-DSNTIAR SECTION.
           CALL 'DSNTIAR' USING SQLCA ERROR-MESSAGE ERROR-TEXT-LEN

           PERFORM VARYING ERROR-INDEX
              FROM 1 BY 1 UNTIL ERROR-INDEX = 10
                   DISPLAY ERROR-TEXT(ERROR-INDEX)
           END-PERFORM
           .
       R900-DSNTIAR-END.
           EXIT.

       END PROGRAM CTFM002.