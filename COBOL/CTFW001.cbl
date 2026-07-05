       IDENTIFICATION DIVISION.
       PROGRAM-ID. CTFW001.
      *===============================================================*
      * This program is a WEB program for the CTF2026 app.            *
      * ------------------------------------------------------------- *
      * Updates:                                                      *
      *                                                               *
      * Date     Who What                                             *
      * -------- --- ------------------------------------------------ *
      * yy/mm/dd ii  description                                      *
      *===============================================================*

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WORK.
           05  C-CHNL-NAME-LWW       PIC X(16) VALUE 'LWW-LINK-CHL-00'.
           05  C-CONT-NAME-LWW-00    PIC X(16) VALUE 'LWW-LINK-PAR-00'.
           05  W-CHNL-NAME           PIC X(16).
           05  W-CONT-NAME           PIC X(16).
           05  W-CONT-POINTER        POINTER.
           05  W-CONT-LENGTH         PIC S9(9) USAGE COMP-5.
           05  W-RETURNCODE          PIC X(2)  VALUE '00'.
           05  W-PGMNAME             PIC X(8)  VALUE SPACES.
           05  W-USERID              PIC X(8).
           05  W-EIBRESP             PIC 9(8).
           05  W-EIBRESP2            PIC 9(8).

           05  SW-CONT-FOUND-VAL     PIC X     VALUE 'N'.
               88  SW-CONT-FOUND               VALUE 'Y'.
               88  SW-CONT-MISSING             VALUE 'N'.

           05  MSGSTR.
               10  Vstring-length    PIC S9(4) BINARY.
               10  Vstring-text.
                   15  Vstring-char  PIC X
                               OCCURS 0 TO 256 TIMES
                               DEPENDING ON Vstring-length
                                  of MSGSTR.
           05  MSGDEST               PIC S9(9) BINARY.
           05  FC.
               10  Condition-Token-Value.
               COPY  CEEIGZCT.
                   15  Case-1-Condition-ID.
                       20  Severity    PIC S9(4) BINARY.
                       20  Msg-No      PIC S9(4) BINARY.
                   15  Case-2-Condition-ID
                             REDEFINES Case-1-Condition-ID.
                       20  Class-Code  PIC S9(4) BINARY.
                       20  Cause-Code  PIC S9(4) BINARY.
                   15  Case-Sev-Ctl    PIC X.
                   15  Facility-ID     PIC XXX.
               10  I-S-Info            PIC S9(9) BINARY.
       
       01  W-LCTFM001.
           COPY LCTFM001.
       01  W-LINKPAR.
           COPY LINKPAR.

       LINKAGE SECTION.
       01  P-CHAR                    PIC X.

       PROCEDURE DIVISION.
       MAIN SECTION.
           PERFORM R001-INIT

           PERFORM R005-CHECK-NICNAME

           PERFORM R009-FINISH
           .

      *===============================================================*
      * R001-INIT: Program initialisations                            *
      *===============================================================*
       R001-INIT SECTION.
           MOVE C-CHNL-NAME-LWW    TO W-CHNL-NAME 
           MOVE C-CONT-NAME-LWW-00 TO W-CONT-NAME

           PERFORM R910-GET-CONTAINER

           IF SW-CONT-FOUND
              SET ADDRESS OF P-CHAR TO W-CONT-POINTER
              MOVE P-CHAR(1:W-CONT-LENGTH) TO W-LINKPAR
           END-IF
           .
       R001-INIT-END.
           EXIT.

      *===============================================================*
      * R005-CHECK-NICNAME: Check if user is present in DETECTIV      *
      *===============================================================*
       R005-CHECK-NICNAME SECTION.
           EXEC CICS
              ASSIGN USERID(W-USERID)
           END-EXEC

           MOVE N'R' TO OPCODE OF W-LCTFM001
           MOVE FUNCTION NATIONAL-OF(W-USERID) TO USERID OF W-LCTFM001

           MOVE 'CTFM001' TO W-PGMNAME

           CALL W-PGMNAME USING W-LCTFM001

           IF RETURNCODE OF W-LCTFM001 NOT = N'00'
              IF RETURNCODE OF W-LCTFM001 = N'04'
                 MOVE 'FL000009' TO LREDURI OF W-LINKPAR
              END-IF
           END-IF
           .
       R005-CHECK-NICNAME-END.
           EXIT.

      *===============================================================*
      * R009-FINISH: Program finalisations                            *
      *===============================================================*
       R009-FINISH SECTION.
           MOVE C-CHNL-NAME-LWW     TO W-CHNL-NAME 
           MOVE C-CONT-NAME-LWW-00  TO W-CONT-NAME
           MOVE LENGTH OF W-LINKPAR TO W-CONT-LENGTH
           SET W-CONT-POINTER TO ADDRESS OF W-LINKPAR

           PERFORM R920-PUT-CONTAINER

           EXEC CICS
              RETURN
           END-EXEC
           .

       R910-GET-CONTAINER SECTION.
           EXEC CICS
              GET CONTAINER(W-CONT-NAME)
                  CHANNEL(W-CHNL-NAME)
                  SET(W-CONT-POINTER)
                  FLENGTH(W-CONT-LENGTH)
                  NOHANDLE
           END-EXEC

           IF EIBRESP = DFHRESP(NORMAL)
              SET SW-CONT-FOUND TO TRUE
           ELSE
              SET SW-CONT-MISSING TO TRUE
              
              IF  EIBRESP NOT = DFHRESP(CHANNELERR)
              AND EIBRESP NOT = DFHRESP(CONTAINERERR)
                 MOVE '08' TO W-RETURNCODE

                 MOVE EIBRESP  TO W-EIBRESP
                 MOVE EIBRESP2 TO W-EIBRESP2
                 MOVE 1 TO Vstring-length
                 STRING 'GET CONTAINER ERROR ' W-EIBRESP ' ' W-EIBRESP2
                        DELIMITED BY SIZE
                   INTO Vstring-text
                   WITH POINTER Vstring-length
                 SUBTRACT 1 FROM Vstring-length
                 CALL 'CEEMOUT' USING MSGSTR, MSGDEST, FC
              END-IF
           END-IF
           .
       R910-GET-CONTAINER-END.
           EXIT.

       R920-PUT-CONTAINER SECTION.
           SET ADDRESS OF P-CHAR TO W-CONT-POINTER

           EXEC CICS
              PUT CONTAINER(W-CONT-NAME)
                  CHANNEL(W-CHNL-NAME)
                  FROM(P-CHAR)
                  FLENGTH(W-CONT-LENGTH)
                  NOHANDLE
           END-EXEC

           IF EIBRESP = DFHRESP(NORMAL)
              CONTINUE
           ELSE
              MOVE '08' TO W-RETURNCODE

              MOVE EIBRESP  TO W-EIBRESP
              MOVE EIBRESP2 TO W-EIBRESP2
              MOVE 1 TO Vstring-length
              STRING 'PUT CONTAINER ERROR ' W-EIBRESP ' ' W-EIBRESP2
                     DELIMITED BY SIZE
                INTO Vstring-text
                WITH POINTER Vstring-length
              SUBTRACT 1 FROM Vstring-length
              CALL 'CEEMOUT' USING MSGSTR, MSGDEST, FC
           END-IF
           .
       R930-PUT-CONTAINER-END.
           EXIT.
       END PROGRAM CTFW001.