          05 LCTFC100.
             10 USERID            PIC N(08).
             10 NICKNAME.
                15 NICKNAME-LEN   PIC S9(4) USAGE COMP-5.
                15 NICKNAME-TEXT  PIC N(128).
             10 FRAGMENT-COUNT    PIC S9(4) USAGE COMP-5.
             10 FRAGMENTS-RESOLVED OCCURS 1 TO 20
                                   DEPENDING ON FRAGMENT-COUNT.
                15 FRAGMENT       PIC N(8).
                15 POINTS         PIC S9(9) USAGE COMP-5.