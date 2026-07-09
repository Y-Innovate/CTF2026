           EXEC SQL DECLARE CTF2026.ACCLOG TABLE
           ( ACCTIME                        BIGINT NOT NULL,
             INOROUT                        GRAPHIC(1) NOT NULL,
             USERID                         GRAPHIC(8) NOT NULL
           ) END-EXEC.
      *
       01  DCLACCLOG.
           10 ACCTIME              PIC S9(18) USAGE COMP-5.
           10 INOROUT              PIC G(1) USAGE DISPLAY-1.
           10 USERID               PIC G(8) USAGE DISPLAY-1.
