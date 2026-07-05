-- Create CTF2026 database.

-- Set SQLID
   SET CURRENT SQLID='CTF2026';

-- Create CTF2026 database
   CREATE DATABASE DBCTF26
                     BUFFERPOOL BP0
                     INDEXBP    BP3
                     CCSID      UNICODE
                     STOGROUP   SGCTF26;

   COMMIT;