       IDENTIFICATION DIVISION.
       PROGRAM-ID. CTFC901.
      *===============================================================*
      * This program is an admin program for the CTF2026 app.         *
      * init TSQs                                                     *
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
           05  W-EIBRESP             PIC 9(8).
           05  W-EIBRESP2            PIC 9(8).
           05  W-TSQ-LEN             PIC S9(4) USAGE COMP-5.
           05  W-TSQ-ITEM            PIC S9(4) USAGE COMP-5.
           05  W-TSQ-CONTENT1.
               10 FILLER PIC X(80) VALUE
                  'import sys'.
               10 FILLER PIC X(80) VALUE
                  'import time'.
               10 FILLER PIC X(80) VALUE
                  ' '.
               10 FILLER PIC X(80) VALUE
                  'GREEN = "\033[92m"'.
               10 FILLER PIC X(80) VALUE
                  'RED = "\033[91m"'.
               10 FILLER PIC X(80) VALUE
                  'DIM = "\033[2m"'.
               10 FILLER PIC X(80) VALUE
                  'RESET = "\033[0m"'.
               10 FILLER PIC X(80) VALUE
                  ' '.
               10 FILLER PIC X(80) VALUE
                  'BANNER = r"""'.
               10 FILLER PIC X(80) VALUE
                  ' _              _       _                _   _   _   
      -           '          _'.
               10 FILLER PIC X(80) VALUE
                  '| |            | | __ _| | _____        / \ | |_| |_ 
      -           '__ _  ___| | __'.
               10 FILLER PIC X(80) VALUE
                  '| |   _____ _  | |/ _` | |/ / __|_____ / _ \| __| __/
      -           ' _` |/ __| |/ /'.
               10 FILLER PIC X(80) VALUE
                  '| |__|_____| |_| | (_| |   <\__ \_____/ ___ \ |_| || 
      -           '(_| | (__|   <'.
               10 FILLER PIC X(80) VALUE
                  '|_____|     \___/ \__,_|_|\_\___/    /_/   \_\__|\__\
      -           '__,_|\___|_|\_\'.
               10 FILLER PIC X(80) VALUE
                  '          [ unauthorized access framework ]  v4.2.1'.
               10 FILLER PIC X(80) VALUE
                  '"""'.
               10 FILLER PIC X(80) VALUE
                  ' '.
               10 FILLER PIC X(80) VALUE
                  'def main():'.
               10 FILLER PIC X(80) VALUE
                  '    print(RED + BANNER + RESET)'.
               10 FILLER PIC X(80) VALUE
                  '    time.sleep(0.4)'.
               10 FILLER PIC X(80) VALUE
                  '    print(GREEN + "\nGet cert from LEGOROCKS" + RESET
      -           ')'.
               10 FILLER PIC X(80) VALUE
                  ' '.
               10 FILLER PIC X(80) VALUE
                  'if __name__ == "__main__":'.
               10 FILLER PIC X(80) VALUE
                  '    main()'.

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

       PROCEDURE DIVISION.
       MAIN SECTION.
           MOVE LENGTH OF W-TSQ-CONTENT1 TO W-TSQ-LEN
           MOVE 1 TO W-TSQ-ITEM

           EXEC CICS
              WRITEQ TS QNAME('LETMYLEGOGO') ITEM(W-TSQ-ITEM)
                        FROM(W-TSQ-CONTENT1) LENGTH(W-TSQ-LEN) NOHANDLE
           END-EXEC
           
           EXEC CICS
              RETURN
           END-EXEC
           .
       END PROGRAM CTFC901.
