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
          05 W-SQLCODE       PIC -99999.
          05 W-COL-COUNT     PIC S9(4) COMP.
          05 W-IDX           PIC S9(4) COMP.
          05 W-PTR           POINTER.
          05 W-PTRN          REDEFINES W-PTR PIC S9(8) COMP-5.
          05 W-COLUMN-IND    PIC S9(4) COMP.
          05 W-COLUMN-LEN    PIC S9(4) COMP.
          05 W-COLUMN-PREC   PIC S9(4) COMP.
          05 W-COLUMN-SCALE  PIC S9(4) COMP.
          05 W-DUMMY         PIC S9(4) COMP.
          05 W-MYTYPE        PIC S9(4) COMP.
          05 W-INT           PIC S9(8) COMP-5.
          05 W-INT-C         REDEFINES W-INT PIC X(4).
          05 W-INT-Z         PIC -9(9).
          05 W-BIGINT        PIC S9(18) COMP-5.
          05 W-BIGINT-C      REDEFINES W-BIGINT PIC X(8).
          05 W-BIGINT-Z      PIC -9(18).

       01 H-STMT1.
          49 H-STMT1-LENGTH  PIC S9(4) COMP-5.
          49 H-STMT1-TEXT    PIC X(256).
       
       01 W-DATA-BUFFERS.
          05 W-COLUMN-BUFFER OCCURS 10 TIMES.
             10 W-COL-DATA   PIC X(256).
             10 W-COL-DATA4 REDEFINES W-COL-DATA PIC S9(8) COMP-5.
          05 W-COLUMN-IND-BUFFER OCCURS 10 TIMES.
             10 W-COL-IND    PIC S9(4) COMP.

       77 VARCTYPE           PIC S9(4)  COMP-5 VALUE +448.
       77 CHARTYPE           PIC S9(4)  COMP-5 VALUE +452.
       77 VARLTYPE           PIC S9(4)  COMP-5 VALUE +456.
       77 VARGTYPE           PIC S9(4)  COMP-5 VALUE +464.
       77 GTYPE              PIC S9(4)  COMP-5 VALUE +468.
       77 LVARGTYP           PIC S9(4)  COMP-5 VALUE +472.
       77 FLOATYPE           PIC S9(4)  COMP-5 VALUE +480.
       77 DECTYPE            PIC S9(4)  COMP-5 VALUE +484.
       77 INTTYPE            PIC S9(4)  COMP-5 VALUE +496.
       77 BIGINTTP           PIC S9(4)  COMP-5 VALUE +492.
       77 HWTYPE             PIC S9(4)  COMP-5 VALUE +500.
       77 DATETYP            PIC S9(4)  COMP-5 VALUE +384.
       77 TIMETYP            PIC S9(4)  COMP-5 VALUE +388.
       77 TIMESTMP           PIC S9(4)  COMP-5 VALUE +392.

       77 ONE                PIC S9(4)  COMP-5 VALUE +1.
       77 TWO                PIC S9(4)  COMP-5 VALUE +2.
       77 FOUR               PIC S9(4)  COMP-5 VALUE +4.

       01 ERROR-MESSAGE.
          05 ERROR-LEN       PIC S9(4) COMP VALUE +720.
          05 ERROR-TEXT      PIC X(72) OCCURS 10 TIMES
                                       INDEXED BY ERROR-INDEX.
       77 ERROR-TEXT-LEN     PIC S9(9) COMP VALUE +72.
       
           EXEC SQL
              INCLUDE ACCLOG
           END-EXEC.

       LINKAGE SECTION.
       01 P-LCTFM002.
           COPY LCTFM002.
       
       01 P-CHAR             PIC X.

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
           MOVE 0 TO SQLCODE-C OF P-LCTFM002
           MOVE 0 TO RESULT-LINECT OF P-LCTFM002
           .
       R001-INIT-END.
           EXIT.

      *===============================================================*
      * R005-EXECUTE: Execute SQL query                               *
      *===============================================================*
       R005-EXECUTE SECTION.
           INITIALIZE H-STMT1-LENGTH
           INITIALIZE H-STMT1-TEXT

           MOVE SQLQUERY-LEN OF P-LCTFM002 TO H-STMT1-LENGTH
           MOVE SQLQUERY-TEXT OF P-LCTFM002(1:
                   SQLQUERY-LEN OF P-LCTFM002) TO H-STMT1-TEXT

           EXEC SQL
              DECLARE STMT1 STATEMENT
           END-EXEC

           EXEC SQL
              DECLARE CURS1 CURSOR FOR STMT1
           END-EXEC

           MOVE 10 TO SQLN OF SQLDA
           COMPUTE SQLDABC = 456

           EXEC SQL
              PREPARE STMT1 INTO :SQLDA FROM :H-STMT1
           END-EXEC

           IF SQLCODE = 0
              MOVE SQLD TO W-COL-COUNT

              PERFORM VARYING W-IDX FROM 1 BY 1
                UNTIL W-IDX > W-COL-COUNT
                 SET W-PTR TO ADDRESS OF W-COL-DATA(W-IDX)
                 SET SQLDATA(W-IDX) TO W-PTR
                 MOVE 0 TO W-COL-IND(W-IDX)
                 IF W-COLUMN-IND = ONE
                    SET W-PTR TO ADDRESS OF W-COL-IND(W-IDX)
                    SET SQLIND(W-IDX) TO W-PTR
                 END-IF
              END-PERFORM

              EXEC SQL
                 OPEN CURS1 USING DESCRIPTOR :SQLDA
              END-EXEC

              IF SQLCODE = 0
                 EXEC SQL
                    FETCH CURS1
                     INTO DESCRIPTOR :SQLDA
                 END-EXEC

                 PERFORM UNTIL SQLCODE NOT = 0
                            OR RESULT-LINECT >= 300
                    ADD 1 TO RESULT-LINECT
                    INITIALIZE SQLRESLINE(RESULT-LINECT)

                    SET W-PTR TO ADDRESS OF SQLRESLINE(RESULT-LINECT)

                    PERFORM VARYING W-IDX FROM 1 BY 1
                      UNTIL W-IDX > W-COL-COUNT
                       MOVE SQLLEN(W-IDX) TO W-COLUMN-LEN
                       DIVIDE SQLTYPE(W-IDX) BY TWO GIVING W-DUMMY
                              REMAINDER W-COLUMN-IND
                       MOVE SQLTYPE(W-IDX) TO W-MYTYPE
                       SUBTRACT W-COLUMN-IND FROM W-MYTYPE
                       EVALUATE W-MYTYPE
                          WHEN CHARTYPE  CONTINUE,
                          WHEN DATETYP   CONTINUE,
                          WHEN TIMETYP   CONTINUE,
                          WHEN TIMESTMP  CONTINUE,
                          WHEN FLOATYPE  CONTINUE,
                          WHEN VARCTYPE
                             ADD TWO TO W-COLUMN-LEN,
                          WHEN VARLTYPE
                             ADD TWO TO W-COLUMN-LEN,
                          WHEN GTYPE
                             MULTIPLY W-COLUMN-LEN BY TWO
                                GIVING W-COLUMN-LEN,
                          WHEN VARGTYPE
                             MULTIPLY W-COLUMN-LEN BY TWO
                                GIVING W-COLUMN-LEN
                             ADD TWO TO W-COLUMN-LEN
                          WHEN LVARGTYP
                             MULTIPLY W-COLUMN-LEN BY TWO
                               GIVING W-COLUMN-LEN
                             ADD TWO TO W-COLUMN-LEN
                          WHEN HWTYPE
                             MOVE TWO TO W-COLUMN-LEN,
                          WHEN INTTYPE
                             MOVE FOUR TO W-COLUMN-LEN,
                          WHEN BIGINTTP
                             MOVE W-COL-DATA(W-IDX)(1:8) TO W-BIGINT-C
                             MOVE W-BIGINT TO W-BIGINT-Z
                             MOVE W-BIGINT-Z TO W-COL-DATA(W-IDX)(1:18)
                             MOVE 18 TO W-COLUMN-LEN,
                          WHEN DECTYPE
                             DIVIDE W-COLUMN-LEN BY 256
                                GIVING W-COLUMN-PREC
                                REMAINDER W-COLUMN-SCALE
                             MOVE W-COLUMN-PREC TO W-COLUMN-LEN
                             ADD ONE TO W-COLUMN-LEN
                             DIVIDE W-COLUMN-LEN BY TWO
                                GIVING W-COLUMN-LEN
                          WHEN OTHER
                             PERFORM R900-DSNTIAR
                       END-EVALUATE

                       SET ADDRESS OF P-CHAR TO W-PTR
                       MOVE W-COL-DATA(W-IDX)(1:W-COLUMN-LEN) TO
                            P-CHAR(1:W-COLUMN-LEN)
                       ADD W-COLUMN-LEN TO W-PTRN
                       ADD ONE TO W-PTRN
                    END-PERFORM

                    EXEC SQL
                       FETCH CURS1
                        INTO DESCRIPTOR :SQLDA
                    END-EXEC
                 END-PERFORM

                 EXEC SQL
                    CLOSE CURS1
                 END-EXEC
              END-IF
           END-IF

           MOVE SQLCODE TO SQLCODE-C OF P-LCTFM002
           .
       R005-EXECUTE-END.
           EXIT.

      *===============================================================*
      * R009-FINISH: Program finalisations                            *
      *===============================================================*
       R009-FINISH SECTION.
           MOVE P-LCTFM002 TO P-LCTFM002
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