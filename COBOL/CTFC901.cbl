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
           05  W-TSQ-CONTENT2.
               10 FILLER PIC X(80) VALUE
                  '-----BEGIN CERTIFICATE-----'.
               10 FILLER PIC X(80) VALUE
                  'MIIDMjCCAhqgAwIBAgIUBQ1eG1fsfORW8QRROqTEj54ekAQwDQYJK
      -           'oZIhvcNAQEL'.
               10 FILLER PIC X(80) VALUE
                  'BQAwOTELMAkGA1UEBhMCQ1oxEDAOBgNVBAsMB05PTU9SRVoxGDAWB
      -           'gNVBAMMD0VO'.
               10 FILLER PIC X(80) VALUE
                  'Q1JZUFRTSE9QTElTVDAeFw0yNjEwMDQwNzA0NDBaFw0yNzEwMDQwN
      -           'zA0NDBaMDkx'.
               10 FILLER PIC X(80) VALUE
                  'CzAJBgNVBAYTAkNaMRAwDgYDVQQLDAdOT01PUkVaMRgwFgYDVQQDD
      -           'A9FTkNSWVBU'.
               10 FILLER PIC X(80) VALUE
                  'U0hPUExJU1QwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBA
      -           'QDcJ4a714/1'.
               10 FILLER PIC X(80) VALUE
                  'N9dALO0sccjggo049LeoQNvzVLPG8PRL9oE84T35VTS4CN3EX0cw+
      -           'y0V9Ce28x6A'.
               10 FILLER PIC X(80) VALUE
                  '1RKN1rcsGeHSd4Ra69+VrI8r/wicn0HiJBjIca5/JE1UfJX6MRDrt
      -           'I+JcXk0z/Dj'.
               10 FILLER PIC X(80) VALUE
                  'Oh31rjjgWHfJstBAgzWrAgaFkK20mLIo/Cit1R4jJXj5I9HWxGi4/
      -           'S8L00/GIcEU'.
               10 FILLER PIC X(80) VALUE
                  'LcXmgKIFJ1ForeFceNfdIY+Gl99RO6jXlom69B4734W1MBHijFuN+
      -           'ZLnyobeRBd5'.
               10 FILLER PIC X(80) VALUE
                  'I1sNugfcQXesaLdbEr8mKdExhLkOp2ExsQOb4e5QAKnvJgXW/Y/A/
      -           'Kz3Ggo9efdE'.
               10 FILLER PIC X(80) VALUE
                  'BXi08jwzl7vpAgMBAAGjMjAwMB0GA1UdDgQWBBT8BtYFEFuzYOghN
      -           '9I71j20ILnU'.
               10 FILLER PIC X(80) VALUE
                  'JTAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQC+/
      -           'owjxA6pmEO8'.
               10 FILLER PIC X(80) VALUE
                  'ZZLSqyDlqEfeHvP1wRBMIY7sGSt3n6Ts6P46TqURomioJkrBiQv9X
      -           'Hk01zE0ukfn'.
               10 FILLER PIC X(80) VALUE
                  '3kMllb0F0LLNbhjhJ6d3G+0gJXQ4uQrGwHqcDlvYvZloKPzg8dJZH
      -           'onj7e1jwCO4'.
               10 FILLER PIC X(80) VALUE
                  'oPnZDwG3fI7qk6c8DlwlZgHHxRXIHNRlaGwt8vMpDGe/+PyUDrTD0
      -           'Z/M8xphCfQA'.
               10 FILLER PIC X(80) VALUE
                  'KNvSIUp477rTpovtKj53JaFf7xLO2rz3rALVgeQ/o2QgUqjoQItu+
      -           'eDeRaVdwx/Y'.
               10 FILLER PIC X(80) VALUE
                  'gX/phapx5Buq/cxLQGrHEL0AdOSx42OAV8Be2JQ/PClxgVMFnUYlr
      -           'OU5Oh76dVXx'.
               10 FILLER PIC X(80) VALUE
                  'vkVjWQdn'.
               10 FILLER PIC X(80) VALUE
                  '-----END CERTIFICATE-----'.
           05  W-TSQ-CONTENT3.
               10 FILLER PIC X(80) VALUE
                  'My shopping list'.
               10 FILLER PIC X(80) VALUE
                  ' '.
               10 FILLER PIC X(80) VALUE
                  '- LEGO Millenium Falcon'.
               10 FILLER PIC X(80) VALUE
                  '- 3 face masks'.
               10 FILLER PIC X(80) VALUE
                  '- lots of Monster energy drink'.
               10 FILLER PIC X(80) VALUE
                  '- spray paint cans'.
               10 FILLER PIC X(80) VALUE
                  '- dog food'.
               10 FILLER PIC X(80) VALUE
                  '- snacks for in the get away car'.
               10 FILLER PIC X(80) VALUE
                  ' '.
               10 FILLER PIC X(80) VALUE
                  'I should make sure not to forget to encrypt this with
      -           ' my cert and key.'.
               10 FILLER PIC X(80) VALUE
                  'SHA-1 fingerprint: bbf681b9c4bf3f8b8dd05df5caf2fd2cac
      -           '075a79'.

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

           MOVE LENGTH OF W-TSQ-CONTENT2 TO W-TSQ-LEN
           MOVE 1 TO W-TSQ-ITEM

           EXEC CICS
              WRITEQ TS QNAME('LEGOROCKS') ITEM(W-TSQ-ITEM)
                        FROM(W-TSQ-CONTENT2) LENGTH(W-TSQ-LEN) NOHANDLE
           END-EXEC

           MOVE LENGTH OF W-TSQ-CONTENT3 TO W-TSQ-LEN
           MOVE 1 TO W-TSQ-ITEM

           EXEC CICS
              WRITEQ TS QNAME('ENCRYPTSHOPLIST') ITEM(W-TSQ-ITEM)
                        FROM(W-TSQ-CONTENT3) LENGTH(W-TSQ-LEN) NOHANDLE
           END-EXEC

           EXEC CICS
              RETURN
           END-EXEC
           .
       END PROGRAM CTFC901.
