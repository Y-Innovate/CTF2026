           EXEC SQL DECLARE DETECTIV TABLE
           ( USERID                         GRAPHIC(8) NOT NULL,
             NICKNAME                       VARGRAPHIC(128) NOT NULL,
             EMAIL                          VARGRAPHIC(128) NOT NULL,
             INTRODONE                      GRAPHIC(1) NOT NULL,
             CREATEDBY                      GRAPHIC(8) NOT NULL,
             CREATEDDATE                    TIMESTAMP NOT NULL,
             UPDATEDBY                      GRAPHIC(8) NOT NULL,
             UPDATEDDATE                    TIMESTAMP NOT NULL
           ) END-EXEC.
      *
       01 DCLDETECTIV.
          10 USERID                PIC N(8).
          10 NICKNAME.
             49 NICKNAME-LEN       PIC S9(4) USAGE COMP-5.
             49 NICKNAME-TEXT      PIC N(128).
          10 EMAIL.
             49 EMAIL-LEN          PIC S9(4) USAGE COMP-5.
             49 EMAIL-TEXT         PIC N(128).
          10 INTRODONE             PIC N.
          10 CREATEDBY             PIC N(8).
          10 CREATEDDATE           PIC X(26).
          10 UPDATEDBY             PIC N(8).
          10 UPDATEDDATE           PIC X(26).