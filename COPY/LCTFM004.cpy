          05 LCTFM004.
             10 USERID            PIC X(08).
             10 RETURNCODE        PIC X(02).
             10 REASONCODE        PIC X(02).
             10 INFOMESSAGE       PIC X(72).
             10 FRAGMENT-COUNT    PIC S9(4) USAGE COMP-5.
             10 FRAGMENTS-RESOLVED OCCURS 1 TO 20
                                   DEPENDING ON FRAGMENT-COUNT OF
                                                LCTFM004.
                15 FRAGMENT       PIC X(8).
                15 POINTS         PIC S9(9) USAGE COMP-5.
