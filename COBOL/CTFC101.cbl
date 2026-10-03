       IDENTIFICATION DIVISION.
       PROGRAM-ID. CTFC101.
      *===============================================================*
      * This program is a REST program for the CTF2026 app.           *
      * Get a HINT.                                                   *
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
           05  C-CONT-NAME-LWW-03    PIC X(16) VALUE 'LWW-LINK-PAR-03'.
           05  W-CHNL-NAME           PIC X(16).
           05  W-CONT-NAME           PIC X(16).
           05  W-CONT-POINTER        POINTER.
           05  W-CONT-LENGTH         PIC S9(9) USAGE COMP-5.
           05  W-RETURNCODE          PIC X(2)  VALUE '00'.
           05  W-PGMNAME             PIC X(8)  VALUE SPACES.
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
       
       01  W-LCTFC101.
           COPY LCTFC101.
       01  W-LCTFM003.
           COPY LCTFM003.
       01  W-LINKPAR.
           COPY LINKPAR.

       LINKAGE SECTION.
       01  P-CHAR                    PIC X.

       PROCEDURE DIVISION.
       MAIN SECTION.
           PERFORM R001-INIT

           PERFORM R005-DO-HINT

           PERFORM R009-FINISH
           .

      *===============================================================*
      * R001-INIT: Program initialisations                            *
      *===============================================================*
       R001-INIT SECTION.
           MOVE C-CHNL-NAME-LWW    TO W-CHNL-NAME 
           MOVE C-CONT-NAME-LWW-03 TO W-CONT-NAME

           PERFORM R910-GET-CONTAINER

           IF SW-CONT-FOUND
              SET ADDRESS OF P-CHAR TO W-CONT-POINTER
              MOVE P-CHAR(1:W-CONT-LENGTH) TO W-LCTFC101
           END-IF

           MOVE C-CHNL-NAME-LWW    TO W-CHNL-NAME 
           MOVE C-CONT-NAME-LWW-00 TO W-CONT-NAME

           PERFORM R910-GET-CONTAINER

           IF SW-CONT-FOUND
              SET ADDRESS OF P-CHAR TO W-CONT-POINTER
              MOVE P-CHAR(1:W-CONT-LENGTH) TO W-LINKPAR
           END-IF

           INITIALIZE W-LCTFM003
           .
       R001-INIT-END.
           EXIT.

      *===============================================================*
      * R005-DO-HINT: Retrieve HINT and insert negative PROGRESS      *
      *===============================================================*
       R005-DO-HINT SECTION.
           MOVE ZERO TO HINT-LEN OF W-LCTFC101

           EVALUATE FRAGMENT OF W-LCTFC101
           WHEN N'INTRO'
              MOVE 1 TO HINT-LEN OF W-LCTFC101
              STRING N'To convert Unix epoch timestamps to local time'
                     N' use TIMESTAMP(''1970-01-01'') + ACCTIME SECONDS'
                     N' + CURRENT TIMEZONE'
                     DELIMITED BY SIZE
                INTO HINT-TEXT OF W-LCTFC101
                WITH POINTER HINT-LEN OF W-LCTFC101
              SUBTRACT 1 FROM HINT-LEN OF W-LCTFC101

              MOVE -5 TO POINTS OF LCTFM003

           WHEN N'SUSPECT1'
              MOVE 1 TO HINT-LEN OF W-LCTFC101
              STRING N'These strings were found on the mainframe,'
                     N' so they''re in EBCDIC.'
                     N' I''ll show the translated values.'
                     DELIMITED BY SIZE
                INTO HINT-TEXT OF W-LCTFC101
                WITH POINTER HINT-LEN OF W-LCTFC101
              SUBTRACT 1 FROM HINT-LEN OF W-LCTFC101

              MOVE -5 TO POINTS OF LCTFM003
           END-EVALUATE

           IF HINT-LEN OF W-LCTFC101 > 0
              MOVE 'C' TO OPCODE OF W-LCTFM003 
              MOVE FUNCTION DISPLAY-OF(USERID OF W-LCTFC101) TO
                   USERID OF W-LCTFM003
              MOVE FUNCTION DISPLAY-OF(FRAGMENT OF W-LCTFC101) TO
                   FRAGMENT OF W-LCTFM003
              MOVE 'N' TO POSNEG OF W-LCTFM003

              MOVE C-CHNL-NAME-LWW      TO W-CHNL-NAME
              MOVE C-CONT-NAME-LWW-03   TO W-CONT-NAME
              MOVE LENGTH OF W-LCTFM003 TO W-CONT-LENGTH
              SET W-CONT-POINTER TO ADDRESS OF W-LCTFM003

              PERFORM R920-PUT-CONTAINER

              EXEC CICS
                 LINK PROGRAM('CTFC003') CHANNEL(C-CHNL-NAME-LWW)
              END-EXEC

              MOVE C-CHNL-NAME-LWW    TO W-CHNL-NAME
              MOVE C-CONT-NAME-LWW-03 TO W-CONT-NAME

              PERFORM R910-GET-CONTAINER

              IF SW-CONT-FOUND
                 SET ADDRESS OF P-CHAR TO W-CONT-POINTER
                 MOVE P-CHAR(1:W-CONT-LENGTH) TO W-LCTFM003
              END-IF
           END-IF
           .
       R005-DO-HINT-END.
           EXIT.

      *===============================================================*
      * R009-FINISH: Program finalisations                            *
      *===============================================================*
       R009-FINISH SECTION.
           MOVE C-CHNL-NAME-LWW      TO W-CHNL-NAME 
           MOVE C-CONT-NAME-LWW-03   TO W-CONT-NAME
           MOVE LENGTH OF W-LCTFC101 TO W-CONT-LENGTH
           SET W-CONT-POINTER TO ADDRESS OF W-LCTFC101

           PERFORM R920-PUT-CONTAINER

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
       END PROGRAM CTFC101.