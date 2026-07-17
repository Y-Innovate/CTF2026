       IDENTIFICATION DIVISION.
       PROGRAM-ID. CTFM003
      *===============================================================*
      * This program is a CRUD module for the CTF2026 database's      *
      * PROGRESS table.                                               *
      * ------------------------------------------------------------- *
      * Input:                                                        *
      *   OPCODE: 'C', 'R', 'U' or 'D' for create, read, update or    *
      *            delete a row in PROGRESS                           *
      *   PROGRESS Fields depending on OPCODE                         *
      * Output:                                                       *
      *   RETURNCODE and REASONCODE                                   *
      *     00 00 = Success                                           *
      *     04 01 = Not found                                         *
      *     08 01 = Error: OPCODE invalid                             *
      *     08 02 = Error: USERID required                            *
      *     08 03 = Error: NICKNAME required                          *
      *     08 11 = Error: INSERT of duplicate key                    *
      *     08 12 = Error: SQL error in INSERT                        *
      *     08 21 = Error: SQL error in SELECT                        *
      *     08 31 = Error: UPDATE of non existing key                 *
      *     08 32 = Error: SQL error in UPDATE                        *
      *     08 41 = Error: DELETE of non existing key                 *
      *     08 42 = Error: SQL error in DELETE                        *
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

       01 W-LCTFM003.
           COPY LCTFM003.

       LINKAGE SECTION.
       01 P-LCTFM003.
           COPY LCTFM003.

       PROCEDURE DIVISION USING P-LCTFM003.
       MAIN SECTION.
           PERFORM R001-INIT

           PERFORM R002-CHECKPARM

           IF RETURNCODE OF W-LCTFM003 = '00'
              EVALUATE OPCODE OF W-LCTFM003
              WHEN 'C'
                   PERFORM R110-INSERT
              WHEN 'R'
                   PERFORM R120-SELECT
              WHEN 'U'
                   PERFORM R130-UPDATE
              WHEN 'D'
                   PERFORM R140-DELETE
              END-EVALUATE
           END-IF

           PERFORM R009-FINISH
           .
       MAIN-END.
           GOBACK.

      *===============================================================*
      * R001-INIT: Program initialisations                            *
      *===============================================================*
       R001-INIT SECTION.
           MOVE P-LCTFM003 TO W-LCTFM003

           MOVE '00' TO RETURNCODE OF W-LCTFM003
           MOVE '00' TO REASONCODE OF W-LCTFM003
           MOVE SPACES TO INFOMESSAGE OF W-LCTFM003
           .
       R001-INIT-END.
           EXIT.

      *===============================================================*
      * R002-CHECKPARM: Check parameters                              *
      *===============================================================*
       R002-CHECKPARM SECTION.
           IF  OPCODE OF W-LCTFM003 NOT = 'C'
           AND OPCODE OF W-LCTFM003 NOT = 'R'
           AND OPCODE OF W-LCTFM003 NOT = 'U'
           AND OPCODE OF W-LCTFM003 NOT = 'D'
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '01' TO REASONCODE OF W-LCTFM003
              MOVE 'OPCODE is invalid' TO INFOMESSAGE OF W-LCTFM003
           END-IF

           IF  RETURNCODE OF W-LCTFM003 = '00'
           AND USERID OF W-LCTFM003 = SPACES
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '02' TO REASONCODE OF W-LCTFM003
              MOVE 'USERID is required' TO INFOMESSAGE OF W-LCTFM003
           END-IF

           IF  RETURNCODE OF W-LCTFM003 = '00'
           AND FRAGMENT OF W-LCTFM003 = SPACES
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '02' TO REASONCODE OF W-LCTFM003
              MOVE 'FRAGMENT is required' TO INFOMESSAGE OF W-LCTFM003
           END-IF
           .
       R002-CHECKPARM-END.
           EXIT.

      *===============================================================*
      * R009-FINISH: Program finalisations                            *
      *===============================================================*
       R009-FINISH SECTION.
           MOVE W-LCTFM003 TO P-LCTFM003
           .
       R009-FINISH-END.
           EXIT.

      *===============================================================*
      * R110-INSERT: INSERT a row into PROGRESS                       *
      *===============================================================*
       R110-INSERT SECTION.
           PERFORM R210-COPY-TO-DCL

           EXEC SQL
              INSERT
                INTO PROGRESS
                     (USERID,
                      FRAGMENT,
                      POINTS)
              VALUES(:DCLPROGRESS.USERID,
                     :DCLPROGRESS.FRAGMENT,
                     :DCLPROGRESS.POINTS)
           END-EXEC

           MOVE SQLCODE TO W-SQLCODE

           EVALUATE SQLCODE
           WHEN 0
              CONTINUE
           WHEN -803
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '11' TO REASONCODE OF W-LCTFM003
              MOVE 'PROGRESS duplicate entry' TO
                   INFOMESSAGE OF W-LCTFM003
           WHEN OTHER
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '12' TO REASONCODE OF W-LCTFM003
              STRING 'INSERT gave SQLCODE='
                     W-SQLCODE
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF W-LCTFM003
              PERFORM R900-DSNTIAR
           END-EVALUATE
           .
       R110-INSERT-END.
           EXIT.

      *===============================================================*
      * R120-SELECT: SELECT a row from PROGRESS                       *
      *===============================================================*
       R120-SELECT SECTION.
           MOVE USERID OF W-LCTFM003 TO USERID OF DCLPROGRESS
           MOVE FRAGMENT OF W-LCTFM003 TO FRAGMENT OF DCLPROGRESS

           EXEC SQL
              SELECT POINTS
                INTO :DCLPROGRESS.POINTS
                FROM PROGRESS
               WHERE USERID = :DCLPROGRESS.USERID
                 AND FRAGMENT = :DCLPROGRESS.FRAGMENT
           END-EXEC

           MOVE SQLCODE TO W-SQLCODE

           EVALUATE SQLCODE
           WHEN 0
              MOVE POINTS OF DCLPROGRESS TO POINTS OF W-LCTFM003
           WHEN 100
              MOVE '04' TO RETURNCODE OF W-LCTFM003
              MOVE '01' TO REASONCODE OF W-LCTFM003
              MOVE 'PROGRESS entry not found' TO
                   INFOMESSAGE OF W-LCTFM003
           WHEN OTHER
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '21' TO REASONCODE OF W-LCTFM003
              STRING 'SELECT gave SQLCODE='
                     W-SQLCODE
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF W-LCTFM003
              PERFORM R900-DSNTIAR
           END-EVALUATE
           .
       R120-SELECT-END.
           EXIT.

      *===============================================================*
      * R130-UPDATE: UPDATE a row in PROGRESS                         *
      *===============================================================*
       R130-UPDATE SECTION.
           PERFORM R210-COPY-TO-DCL

           EXEC SQL
              UPDATE PROGRESS
                 SET POINTS = :DCLPROGRESS.POINTS
               WHERE USERID = :DCLPROGRESS.USERID
                 AND FRAGMENT = :DCLPROGRESS.FRAGMENT
           END-EXEC

           MOVE SQLCODE TO W-SQLCODE

           EVALUATE SQLCODE
           WHEN 0
              CONTINUE
           WHEN 100
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '31' TO REASONCODE OF W-LCTFM003
              MOVE 'PROGRESS entry not found' TO
                   INFOMESSAGE OF W-LCTFM003
           WHEN OTHER
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '32' TO REASONCODE OF W-LCTFM003
              STRING 'UPDATE gave SQLCODE='
                     W-SQLCODE
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF W-LCTFM003
              PERFORM R900-DSNTIAR
           END-EVALUATE
           .
       R130-UPDATE-END.
           EXIT.

      *===============================================================*
      * R140-DELETE: DELETE a row from PROGRESS                       *
      *===============================================================*
       R140-DELETE SECTION.
           MOVE USERID OF W-LCTFM003 TO USERID OF DCLPROGRESS
           MOVE FRAGMENT OF W-LCTFM003 TO FRAGMENT OF DCLPROGRESS

           EXEC SQL
              DELETE
                FROM PROGRESS
               WHERE USERID = :DCLPROGRESS.USERID
                 AND FRAGMENT = :DCLPROGRESS.FRAGMENT
           END-EXEC

           MOVE SQLCODE TO W-SQLCODE

           EVALUATE SQLCODE
           WHEN 0
              CONTINUE
           WHEN 100
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '41' TO REASONCODE OF W-LCTFM003
              MOVE 'PROGRESS entry not found' TO
                   INFOMESSAGE OF W-LCTFM003
           WHEN OTHER
              MOVE '08' TO RETURNCODE OF W-LCTFM003
              MOVE '42' TO REASONCODE OF W-LCTFM003
              STRING 'DELETE gave SQLCODE='
                     W-SQLCODE
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF W-LCTFM003
              PERFORM R900-DSNTIAR
           END-EVALUATE
           .
       R140-DELETE-END.
           EXIT.

      *===============================================================*
      * R210-COPY-TO-DCL: Copy from copybook to DCLPROGRESS           *
      *===============================================================*
       R210-COPY-TO-DCL SECTION.
           MOVE USERID OF W-LCTFM003 TO USERID OF DCLPROGRESS
           MOVE FRAGMENT OF W-LCTFM003 TO FRAGMENT OF DCLPROGRESS
           MOVE POINTS OF W-LCTFM003 TO POINTS OF DCLPROGRESS
           .
       R210-COPY-TO-DCL-END.
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

       END PROGRAM CTFM003.