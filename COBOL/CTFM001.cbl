       IDENTIFICATION DIVISION.
       PROGRAM-ID. CTFM001
      *===============================================================*
      * This program is a CRUD module for the CTF2026 database's      *
      * DETECTIV table.                                               *
      * ------------------------------------------------------------- *
      * Input:                                                        *
      *   OPCODE: 'C', 'R', 'U' or 'D' for create, read, update or    *
      *            delete a row in DETECTIV                           *
      *   DETECTIV Fields depending on OPCODE                         *
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

           EXEC SQL INCLUDE TBDETECT END-EXEC.

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

       01 W-LCTFM001.
           COPY LCTFM001.

       LINKAGE SECTION.
       01 P-LCTFM001.
           COPY LCTFM001.

       PROCEDURE DIVISION USING P-LCTFM001.
       MAIN SECTION.
           PERFORM R001-INIT

           PERFORM R002-CHECKPARM

           IF RETURNCODE OF W-LCTFM001 = N'00'
              EVALUATE OPCODE OF W-LCTFM001
              WHEN N'C'
                   PERFORM R110-INSERT
              WHEN N'R'
                   PERFORM R120-SELECT
              WHEN N'U'
                   PERFORM R130-UPDATE
              WHEN N'D'
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
           MOVE P-LCTFM001 TO W-LCTFM001

           MOVE N'00' TO RETURNCODE OF W-LCTFM001
           MOVE N'00' TO REASONCODE OF W-LCTFM001
           MOVE SPACES TO INFOMESSAGE OF W-LCTFM001
           .
       R001-INIT-END.
           EXIT.

      *===============================================================*
      * R002-CHECKPARM: Check parameters                              *
      *===============================================================*
       R002-CHECKPARM SECTION.
           IF  OPCODE OF W-LCTFM001 NOT = N'C'
           AND OPCODE OF W-LCTFM001 NOT = N'R'
           AND OPCODE OF W-LCTFM001 NOT = N'U'
           AND OPCODE OF W-LCTFM001 NOT = N'D'
              MOVE N'08' TO RETURNCODE OF W-LCTFM001
              MOVE N'01' TO REASONCODE OF W-LCTFM001
              MOVE N'OPCODE is invalid' TO INFOMESSAGE OF W-LCTFM001
           END-IF

           IF  RETURNCODE OF W-LCTFM001 = N'00'
           AND USERID OF W-LCTFM001 = SPACES
              MOVE N'08' TO RETURNCODE OF W-LCTFM001
              MOVE N'02' TO REASONCODE OF W-LCTFM001
              MOVE N'USERID is required' TO INFOMESSAGE OF W-LCTFM001
           END-IF

           IF OPCODE OF W-LCTFM001 = N'C'
           OR OPCODE OF W-LCTFM001 = N'U'
              IF  RETURNCODE OF W-LCTFM001 = N'00'
              AND NICKNAME-LEN OF W-LCTFM001 = 0
                 MOVE N'08' TO RETURNCODE OF W-LCTFM001
                 MOVE N'03' TO REASONCODE OF W-LCTFM001
                 MOVE N'NICKNAME is required' TO
                      INFOMESSAGE OF W-LCTFM001
              END-IF
           END-IF
           .
       R002-CHECKPARM-END.
           EXIT.

      *===============================================================*
      * R009-FINISH: Program finalisations                            *
      *===============================================================*
       R009-FINISH SECTION.
           MOVE W-LCTFM001 TO P-LCTFM001
           .
       R009-FINISH-END.
           EXIT.

      *===============================================================*
      * R110-INSERT: INSERT a row into DETECTIV                       *
      *===============================================================*
       R110-INSERT SECTION.
           PERFORM R210-COPY-TO-DCL

           EXEC SQL
              SELECT CREATEDDATE,
                     UPDATEDDATE
                INTO :DCLDETECTIV.CREATEDDATE,
                     :DCLDETECTIV.UPDATEDDATE
                FROM FINAL TABLE
                   (
              INSERT
                INTO DETECTIV
                     (USERID,
                      NICKNAME,
                      EMAIL,
                      INTRODONE,
                      CREATEDBY,
                      CREATEDDATE,
                      UPDATEDBY,
                      UPDATEDDATE)
              VALUES(:DCLDETECTIV.USERID,
                     :DCLDETECTIV.NICKNAME,
                     :DCLDETECTIV.EMAIL,
                     :DCLDETECTIV.INTRODONE,
                     :DCLDETECTIV.CREATEDBY,
                     CURRENT TIMESTAMP,
                     :DCLDETECTIV.UPDATEDBY,
                     CURRENT_TIMESTAMP)
                     )
           END-EXEC

           MOVE SQLCODE TO W-SQLCODE

           EVALUATE SQLCODE
           WHEN 0
              MOVE CREATEDDATE OF DCLDETECTIV TO
                   CREATEDDATE OF W-LCTFM001
              MOVE UPDATEDDATE OF DCLDETECTIV TO
                   UPDATEDDATE OF W-LCTFM001
           WHEN -803
              MOVE N'08' TO RETURNCODE OF W-LCTFM001
              MOVE N'11' TO REASONCODE OF W-LCTFM001
              MOVE N'DETECTIV duplicate entry' TO
                   INFOMESSAGE OF W-LCTFM001
           WHEN OTHER
              MOVE N'08' TO RETURNCODE OF W-LCTFM001
              MOVE N'12' TO REASONCODE OF W-LCTFM001
              STRING N'INSERT gave SQLCODE='
                     FUNCTION NATIONAL-OF(W-SQLCODE)
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF W-LCTFM001
              PERFORM R900-DSNTIAR
           END-EVALUATE
           .
       R110-INSERT-END.
           EXIT.

      *===============================================================*
      * R120-SELECT: SELECT a row from DETECTIV                       *
      *===============================================================*
       R120-SELECT SECTION.
           MOVE USERID OF W-LCTFM001 TO USERID OF DCLDETECTIV

           EXEC SQL
              SELECT NICKNAME,
                     EMAIL,
                     INTRODONE,
                     CREATEDBY,
                     CREATEDDATE,
                     UPDATEDBY,
                     UPDATEDDATE
                INTO :DCLDETECTIV.NICKNAME,
                     :DCLDETECTIV.EMAIL,
                     :DCLDETECTIV.INTRODONE,
                     :DCLDETECTIV.CREATEDBY,
                     :DCLDETECTIV.CREATEDDATE,
                     :DCLDETECTIV.UPDATEDBY,
                     :DCLDETECTIV.UPDATEDDATE
                FROM DETECTIV
               WHERE USERID = :DCLDETECTIV.USERID
           END-EXEC

           MOVE SQLCODE TO W-SQLCODE

           EVALUATE SQLCODE
           WHEN 0
              MOVE NICKNAME-LEN OF DCLDETECTIV TO
                   NICKNAME-LEN OF W-LCTFM001
              IF NICKNAME-LEN OF DCLDETECTIV > 0
                 MOVE NICKNAME-TEXT OF DCLDETECTIV(1:
                         NICKNAME-LEN OF DCLDETECTIV) TO
                      NICKNAME-TEXT OF W-LCTFM001
              END-IF
              MOVE EMAIL-LEN OF DCLDETECTIV TO
                   EMAIL-LEN OF W-LCTFM001
              IF EMAIL-LEN OF DCLDETECTIV > 0
                 MOVE EMAIL-TEXT OF DCLDETECTIV(1:
                         EMAIL-LEN OF DCLDETECTIV) TO
                      EMAIL-TEXT OF W-LCTFM001
              END-IF
              MOVE INTRODONE   OF DCLDETECTIV TO
                   INTRODONE OF W-LCTFM001
              MOVE CREATEDBY   OF DCLDETECTIV TO
                   CREATEDBY   OF W-LCTFM001
              MOVE CREATEDDATE OF DCLDETECTIV TO
                   CREATEDDATE OF W-LCTFM001
              MOVE UPDATEDBY   OF DCLDETECTIV TO
                   UPDATEDBY   OF W-LCTFM001
              MOVE UPDATEDDATE OF DCLDETECTIV TO
                   UPDATEDDATE OF W-LCTFM001
           WHEN 100
              MOVE N'04' TO RETURNCODE OF W-LCTFM001
              MOVE N'01' TO REASONCODE OF W-LCTFM001
              MOVE N'DETECTIV entry not found' TO
                   INFOMESSAGE OF W-LCTFM001
           WHEN OTHER
              MOVE N'08' TO RETURNCODE OF W-LCTFM001
              MOVE N'21' TO REASONCODE OF W-LCTFM001
              STRING N'SELECT gave SQLCODE='
                     FUNCTION NATIONAL-OF(W-SQLCODE)
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF W-LCTFM001
              PERFORM R900-DSNTIAR
           END-EVALUATE
           .
       R120-SELECT-END.
           EXIT.

      *===============================================================*
      * R130-UPDATE: UPDATE a row in DETECTIV                         *
      *===============================================================*
       R130-UPDATE SECTION.
           PERFORM R210-COPY-TO-DCL

           EXEC SQL
              SELECT CREATEDDATE,
                     UPDATEDDATE
                INTO :DCLDETECTIV.CREATEDDATE,
                     :DCLDETECTIV.UPDATEDDATE
                FROM FINAL TABLE
                   (
              UPDATE DETECTIV
                 SET NICKNAME    = :DCLDETECTIV.NICKNAME,
                     EMAIL       = :DCLDETECTIV.EMAIL,
                     INTRODONE   = :DCLDETECTIV.INTRODONE,
                     UPDATEDBY   = :DCLDETECTIV.UPDATEDBY,
                     UPDATEDDATE = CURRENT TIMESTAMP
               WHERE USERID      = :DCLDETECTIV.USERID
                     )
           END-EXEC

           MOVE SQLCODE TO W-SQLCODE

           EVALUATE SQLCODE
           WHEN 0
              MOVE CREATEDDATE OF DCLDETECTIV TO
                   CREATEDDATE OF W-LCTFM001
              MOVE UPDATEDDATE OF DCLDETECTIV TO
                   UPDATEDDATE OF W-LCTFM001
           WHEN 100
              MOVE N'08' TO RETURNCODE OF W-LCTFM001
              MOVE N'31' TO REASONCODE OF W-LCTFM001
              MOVE N'DETECTIV entry not found' TO
                   INFOMESSAGE OF W-LCTFM001
           WHEN OTHER
              MOVE N'08' TO RETURNCODE OF W-LCTFM001
              MOVE N'32' TO REASONCODE OF W-LCTFM001
              STRING N'UPDATE gave SQLCODE='
                     FUNCTION NATIONAL-OF(W-SQLCODE)
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF W-LCTFM001
              PERFORM R900-DSNTIAR
           END-EVALUATE
           .
       R130-UPDATE-END.
           EXIT.

      *===============================================================*
      * R140-DELETE: DELETE a row from DETECTIV                       *
      *===============================================================*
       R140-DELETE SECTION.
           MOVE USERID OF W-LCTFM001 TO USERID OF DCLDETECTIV

           EXEC SQL
              DELETE
                FROM DETECTIV
               WHERE USERID = :DCLDETECTIV.USERID
           END-EXEC

           MOVE SQLCODE TO W-SQLCODE

           EVALUATE SQLCODE
           WHEN 0
              CONTINUE
           WHEN 100
              MOVE N'08' TO RETURNCODE OF W-LCTFM001
              MOVE N'41' TO REASONCODE OF W-LCTFM001
              MOVE N'DETECTIV entry not found' TO
                   INFOMESSAGE OF W-LCTFM001
           WHEN OTHER
              MOVE N'08' TO RETURNCODE OF W-LCTFM001
              MOVE N'42' TO REASONCODE OF W-LCTFM001
              STRING N'DELETE gave SQLCODE='
                     FUNCTION NATIONAL-OF(W-SQLCODE)
                 DELIMITED BY SIZE
                 INTO INFOMESSAGE OF W-LCTFM001
              PERFORM R900-DSNTIAR
           END-EVALUATE
           .
       R140-DELETE-END.
           EXIT.

      *===============================================================*
      * R210-COPY-TO-DCL: Copy from copybook to DCLDETECTIV           *
      *===============================================================*
       R210-COPY-TO-DCL SECTION.
           MOVE USERID OF W-LCTFM001 TO USERID OF DCLDETECTIV
           MOVE NICKNAME-LEN OF W-LCTFM001 TO
                NICKNAME-LEN OF DCLDETECTIV
           IF NICKNAME-LEN OF W-LCTFM001 > 0
              MOVE NICKNAME-TEXT OF W-LCTFM001(1:
                      NICKNAME-LEN OF W-LCTFM001) TO
                   NICKNAME-TEXT OF DCLDETECTIV
           END-IF
           MOVE EMAIL-LEN OF W-LCTFM001 TO EMAIL-LEN OF DCLDETECTIV
           IF EMAIL-LEN OF W-LCTFM001 > 0
              MOVE EMAIL-TEXT OF W-LCTFM001(1:
                      EMAIL-LEN OF W-LCTFM001) TO
                   EMAIL-TEXT OF DCLDETECTIV
           END-IF
           MOVE INTRODONE OF W-LCTFM001 TO INTRODONE OF DCLDETECTIV
           MOVE CREATEDBY OF W-LCTFM001 TO CREATEDBY OF DCLDETECTIV
           MOVE FUNCTION DISPLAY-OF(CREATEDDATE OF W-LCTFM001) TO
              CREATEDDATE OF DCLDETECTIV
           MOVE UPDATEDBY OF W-LCTFM001 TO UPDATEDBY OF DCLDETECTIV
           MOVE FUNCTION DISPLAY-OF(UPDATEDDATE OF W-LCTFM001) TO
              UPDATEDDATE OF DCLDETECTIV
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

       END PROGRAM CTFM001.