       IDENTIFICATION DIVISION.
       PROGRAM-ID. CTFM004
      *===============================================================*
      * This program is a list module for the CTF2026 database's      *
      * PROGRESS table.                                               *
      * ------------------------------------------------------------- *
      * Input:                                                        *
      *   USERID: DETECTIV userid                                     *
      * Output:                                                       *
      *   RETURNCODE and REASONCODE                                   *
      *     00 00 = Success                                           *
      *     04 01 = Not found                                         *
      *     08 01 = Error: USERID required                            *
      *     08 02 = Error: SQL error                                  *
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

           EXEC SQL INCLUDE TBPRGRSS END-EXEC.

       01 WORK.
          05 W-PGMNAME    PIC X(8).
          05 W-USERID     PIC X(8).
          05 W-SQLCODE    PIC -99999.

       01 ERROR-MESSAGE.
          05 ERROR-LEN    PIC S9(4) COMP
                                     VALUE +720.
          05 ERROR-TEXT   PIC X(72) OCCURS 10 TIMES
                INDEXED BY ERROR-INDEX.
       77 ERROR-TEXT-LEN  PIC S9(9) COMP
                                     VALUE +72.

       LINKAGE SECTION.
       01 P-LCTFM004.
           COPY LCTFM004.

       PROCEDURE DIVISION USING P-LCTFM004.
       MAIN SECTION.
           PERFORM R001-INIT

           PERFORM R002-CHECKPARM

           IF RETURNCODE OF P-LCTFM004 = '00'
              PERFORM R110-OPEN-CURSOR

              IF RETURNCODE OF P-LCTFM004 = '00'
                 PERFORM R310-FETCH-CURSOR

                 PERFORM WITH TEST BEFORE
                   UNTIL RETURNCODE OF P-LCTFM004 NOT = '00'
                      OR SQLCODE NOT = 0
                      OR FRAGMENT-COUNT OF P-LCTFM004 >= 20
                    PERFORM R310-FETCH-CURSOR
                 END-PERFORM

                 PERFORM R210-CLOSE-CURSOR
              END-IF
           END-IF

           PERFORM R009-FINISH
           .
       MAIN-END.
           GOBACK.

      *===============================================================*
      * R001-INIT: Program initialisations                            *
      *===============================================================*
       R001-INIT SECTION.
           MOVE P-LCTFM004 TO P-LCTFM004

           MOVE '00' TO RETURNCODE OF P-LCTFM004
           MOVE '00' TO REASONCODE OF P-LCTFM004
           MOVE SPACES TO INFOMESSAGE OF P-LCTFM004
           .
       R001-INIT-END.
           EXIT.

      *===============================================================*
      * R002-CHECKPARM: Check parameters                              *
      *===============================================================*
       R002-CHECKPARM SECTION.
           IF USERID OF P-LCTFM004 = SPACES
              MOVE '08' TO RETURNCODE OF P-LCTFM004
              MOVE '01' TO REASONCODE OF P-LCTFM004
              MOVE 'USERID is required' TO INFOMESSAGE OF P-LCTFM004
           END-IF
           .
       R002-CHECKPARM-END.
           EXIT.

      *===============================================================*
      * R009-FINISH: Program finalisations                            *
      *===============================================================*
       R009-FINISH SECTION.
           MOVE P-LCTFM004 TO P-LCTFM004
           .
       R009-FINISH-END.
           EXIT.

      *===============================================================*
      * R110-OPEN-CURSOR: Open cursor for SELECT of PROGRESS table    *
      *===============================================================*
       R110-OPEN-CURSOR SECTION.
           MOVE USERID OF P-LCTFM004 TO USERID OF DCLPROGRESS

           EXEC SQL
              DECLARE C1 CURSOR FOR
                 SELECT FRAGMENT, POINTS
                   FROM PROGRESS
                  WHERE USERID = :DCLPROGRESS.USERID
                    FOR FETCH ONLY
                  FETCH FIRST 20 ROWS ONLY
           END-EXEC

           EXEC SQL
              OPEN C1
           END-EXEC

           IF SQLCODE NOT = 0
              MOVE SQLCODE TO W-SQLCODE

              MOVE '08' TO RETURNCODE OF P-LCTFM004
              MOVE '02' TO REASONCODE OF P-LCTFM004
              STRING 'SELECT gave SQLCODE='
                     W-SQLCODE
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF P-LCTFM004
              PERFORM R900-DSNTIAR
           END-IF
           .
       R110-OPEN-CURSOR-END.
           EXIT.

      *===============================================================*
      * R210-CLOSE-CURSOR: Close cursor for SELECT of PROGRESS table  *
      *===============================================================*
       R210-CLOSE-CURSOR SECTION.
           EXEC SQL
              CLOSE C1
           END-EXEC

           IF SQLCODE NOT = 0
              MOVE SQLCODE TO W-SQLCODE

              MOVE '08' TO RETURNCODE OF P-LCTFM004
              MOVE '02' TO REASONCODE OF P-LCTFM004
              STRING 'SELECT gave SQLCODE='
                     W-SQLCODE
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF P-LCTFM004
              PERFORM R900-DSNTIAR
           END-IF
           .
       R210-CLOSE-CURSOR-END.
           EXIT.

      *===============================================================*
      * R310-FETCH-CURSOR: FETCH a row in PROGRESS                    *
      *===============================================================*
       R310-FETCH-CURSOR SECTION.
           EXEC SQL
              FETCH C1
               INTO :DCLPROGRESS.FRAGMENT,
                    :DCLPROGRESS.POINTS
           END-EXEC

           EVALUATE SQLCODE
           WHEN 0
              ADD 1 TO FRAGMENT-COUNT OF P-LCTFM004

              MOVE FRAGMENT OF DCLPROGRESS TO
                   FRAGMENT OF P-LCTFM004(FRAGMENT-COUNT OF P-LCTFM004)
              MOVE POINTS OF DCLPROGRESS TO
                   POINTS OF P-LCTFM004(FRAGMENT-COUNT OF P-LCTFM004)
           WHEN 100
              IF FRAGMENT-COUNT OF P-LCTFM004 = 0
                 MOVE '04' TO RETURNCODE OF P-LCTFM004
                 MOVE '01' TO REASONCODE OF P-LCTFM004
                 MOVE 'PROGRESS entry not found' TO
                      INFOMESSAGE OF P-LCTFM004
              END-IF
           WHEN OTHER
              MOVE SQLCODE TO W-SQLCODE

              MOVE '08' TO RETURNCODE OF P-LCTFM004
              MOVE '02' TO REASONCODE OF P-LCTFM004
              STRING 'SELECT gave SQLCODE='
                     W-SQLCODE
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF P-LCTFM004
              PERFORM R900-DSNTIAR
            END-EVALUATE
           .
       R310-FETCH-CURSOR-END.
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

       END PROGRAM CTFM004.
