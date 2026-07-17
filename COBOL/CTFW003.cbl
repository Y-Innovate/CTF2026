       IDENTIFICATION DIVISION.
       PROGRAM-ID. CTFW003.
      *===============================================================*
      * This program is a WEB program for the CTF2026 app. It tests   *
      * an answer to one of the suspects' puzzle questions.           *
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
           05  W-FF-NAME             PIC X(64).
           05  W-FF-NAMELEN          PIC S9(9) USAGE COMP-5.
           05  W-FF-VALUE            PIC X(64).
           05  W-FF-VALUELEN         PIC S9(9) USAGE COMP-5.
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

       01  W-SUSPECT-ANSWERS.
           05  W-HINT-USED           PIC X.
           05  W-SUSPECT-ANSWER-GRP.
               10  W-SUSPECT-ANSWER1 PIC X  VALUE SPACE.
               10  W-SUSPECT-ANSWER2 PIC X  VALUE SPACE.
               10  W-SUSPECT-ANSWER3 PIC X  VALUE SPACE.
           05  W-SUSPECT-ANSWER-STR REDEFINED W-SUSPECT-ANSWER-GRP
                                     PIC X(3).

       01  W-LCTFM001.
           COPY LCTFM001.
       01  W-LCTFM003.
           COPY LCTFM003.
       01  W-LINKPAR.
           COPY LINKPAR.

       LINKAGE SECTION.
       01  P-CHAR                    PIC X.

       PROCEDURE DIVISION.
       MAIN SECTION.
           PERFORM R001-INIT

           PERFORM R005-CHECK-ANSWER

           PERFORM R009-FINISH
           .

      *===============================================================*
      * R001-INIT: Program initialisations                            *
      *===============================================================*
       R001-INIT SECTION.
           SET SW-LIST-CORRECT TO TRUE

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
      * R005-CHECK-ANSWER: Check suspect puzzle answer                *
      *===============================================================*
       R005-CHECK-ANSWER SECTION.
           MOVE '0' TO W-HINT-USED

           EXEC CICS
              WEB STARTBROWSE FORMFIELD
                              NOHANDLE
           END-EXEC

           IF EIBRESP = DFHRESP(NORMAL)
              MOVE LENGTH OF W-FF-NAME TO W-FF-NAMELEN
              MOVE LENGTH OF W-FF-VALUE TO W-FF-VALUELEN

              EXEC CICS
                 WEB READNEXT FORMFIELD(W-FF-NAME)
                              NAMELENGTH(W-FF-NAMELEN)
                              VALUE(W-FF-VALUE)
                              VALUELENGTH(W-FF-VALUELEN)
                              NOHANDLE
              END-EXEC

              PERFORM
                UNTIL EIBRESP NOT = DFHRESP(NORMAL)
                   OR W-SUSPECT-ANSWER-STR NOT = SPACES
                 IF W-FF-NAMELEN = 16
                    EVALUATE TRUE
                       WHEN W-FF-NAME(1:16) = 'answer_suspect_1'
                          IF  W-FF-VALUELEN = 40
                          AND W-FF-VALUE(1:40) = 'IBM BOB SHOULD GO AWAY
      -    ', I WAS HERE FIRST'
                             W-SUSPECT-ANSWER1 = 'Y'
                          END-IF
                       WHEN W-FF-NAME(1:16) = 'answer_suspect_2'
                          CONTINUE
                       WHEN W-FF-NAME(1:16) = 'answer_suspect_3'
                          CONTINUE
                    END-EVALUATE
                 ELSE
                    IF  W-FF-NAMELEN = 9
                    AND W-FF-NAME(1:9) = 'hint_used'
                       IF  W-FF-VALUELEN=1
                       AND W-FF-VALUE(1:1) = '1'
                          MOVE '1' TO W-HINT-USED
                       END-IF
                    END-IF
                 END-IF

                 EXEC CICS
                    WEB READNEXT FORMFIELD(W-FF-NAME)
                                 NAMELENGTH(W-FF-NAMELEN)
                                 VALUE(W-FF-VALUE)
                                 VALUELENGTH(W-FF-VALUELEN)
                                 NOHANDLE
                 END-EXEC
              END-PERFORM

              EXEC CICS
                 WEB ENDBROWSE FORMFIELD
              END-EXEC
           END-IF

           IF W-SUSPECT-ANSWER1 = 'Y'
           OR W-SUSPECT-ANSWER2 = 'Y'
           OR W-SUSPECT-ANSWER3 = 'Y'
              EXEC CICS
                 ASSIGN USERID(W-USERID)
              END-EXEC

              MOVE FUNCTION NATIONAL-OF(W-USERID) TO
                   USERID OF W-LCTFM001

              MOVE N'R' TO OPCODE OF W-LCTFM001

              MOVE 'CTFM001' TO W-PGMNAME

              CALL W-PGMNAME USING W-LCTFM001

              IF RETURNCODE OF W-LCTFM001 = N'00'
                 MOVE W-USERID TO USERID OF W-LCTFM003
                 MOVE 'SUSPECT1' TO FRAGMENT OF W-LCTFM003

                 MOVE 'R' TO OPCODE OF W-LCTFM003

                 MOVE 'CTFM003' TO W-PGMNAME

                 CALL W-PGMNAME USING W-LCTFM003

                 IF RETURNCODE OF W-LCTFM003 = '04'
                 OR RETURNCODE OF W-LCTFM003 = '04'
                    MOVE 'C' TO OPCODE OF W-LCTFM003

                    IF W-HINT-USED = '1'
                       MOVE 5 TO POINTS OF W-LCTFM003
                    ELSE
                       MOVE 10 TO POINTS OF W-LCTFM003
                    END-IF

                    CALL W-PGMNAME USING W-LCTFM003

                    IF RETURNCODE OF W-LCTFM003 NOT = '00'
                       DISPLAY 'CTFW003 CTFM003 '
                               RETURNCODE OF W-LCTFM003 ' '
                               REASONCODE OF W-LCTFM003 ' '
                               INFOMESSAGE OF W-LCTFM003

                       SET SW-LIST-INCORRECT TO TRUE
                    END-IF
                 END-IF
              ELSE
                 DISPLAY 'CTFW003 CTFM001 '
                         RETURNCODE OF W-LCTFM001 ' '
                         REASONCODE OF W-LCTFM001 ' '
                         INFOMESSAGE OF W-LCTFM001

                 SET SW-LIST-INCORRECT TO TRUE
              END-IF
           END-IF

           IF SW-LIST-CORRECT
              MOVE 'true' TO W-FF-VALUE
              MOVE 4 TO W-FF-VALUELEN
           ELSE
              MOVE 'false' TO W-FF-VALUE
              MOVE 5 TO W-FF-VALUELEN
           END-IF

           EXEC CICS
              DOCUMENT SET DOCTOKEN(DTOKEN)
                           SYMBOL('ANSWERCORRECT')
                           VALUE(W-FF-VALUE)
                           LENGTH(W-FF-VALUELEN)
                           NOHANDLE
           END-EXEC
           .
       R005-CHECK-ANSWER-END.
           EXIT.

      *===============================================================*
      * R009-FINISH: Program finalisations                            *
      *===============================================================*
       R009-FINISH SECTION.
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
       END PROGRAM CTFW003.
