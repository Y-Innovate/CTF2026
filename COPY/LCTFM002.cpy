          05 LCTFM001.
             10 SQLQUERY.
                15 SQLQUERY-LEN   PIC S9(4) USAGE COMP-5.
                15 SQLQUERY-TEXT  PIC X(256).
             10 SQLCODE-C         PIC -9(5).
             10 RESULT-LINECT     PIC S9(4) USAGE COMP-5.
             10 SQLRESULTS        OCCURS 300 TIMES
                                  DEPENDING ON RESULT-LINECT.
                15 SQLRESLINE     PIC X(80).