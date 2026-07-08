-- Create access log table in CTF2026 database.

-- Set SQLID
   SET CURRENT SQLID='CTF2026';

-- Create accesslog tablespace
   CREATE TABLESPACE TSACCLOG
                       IN DBCTF26
                       USING STOGROUP SGCTF26
                       PRIQTY 40 SECQTY 40
                       ERASE  NO
                       FREEPAGE 0 PCTFREE 5 FOR UPDATE 0
                       GBPCACHE CHANGED
                       TRACKMOD YES
                       MAXPARTITIONS 254
                       LOGGED
                       DSSIZE 4 G
                       SEGSIZE 4
                       BUFFERPOOL BP0
                       LOCKSIZE ANY
                       LOCKMAX SYSTEM
                       CLOSE YES
                       COMPRESS NO
                       CCSID      UNICODE
                       DEFINE YES
                       MAXROWS 255
                       INSERT ALGORITHM 0;

-- Create access log table
   CREATE TABLE CTF2026.ACCLOG
      (ACCTIME     BIGINT          NOT NULL,
       INOROUT     GRAPHIC(1)      NOT NULL,
       USERID      GRAPHIC(8)      NOT NULL,
       CONSTRAINT ACCTIMEKEY
       PRIMARY KEY (ACCTIME))
      IN DBCTF26.TSACCLOG
      PARTITION BY SIZE
      AUDIT NONE
      DATA CAPTURE NONE
      CCSID      UNICODE
      NOT VOLATILE
      APPEND NO;

-- Create access log index for primary key
   CREATE UNIQUE INDEX CTF2026.IXACCLG1
     ON CTF2026.ACCLOG
      (ACCTIME ASC)
     USING STOGROUP SGCTF26
     PRIQTY -1 SECQTY -1
     ERASE  NO
     FREEPAGE 0 PCTFREE 10
     GBPCACHE CHANGED
     NOT CLUSTER
     COMPRESS NO
     INCLUDE NULL KEYS
     BUFFERPOOL BP0
     CLOSE NO
     COPY NO
     DEFER NO
     DEFINE YES
     PIECESIZE 2 G;

   COMMIT;