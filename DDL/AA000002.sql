-- Create storage group for CTF2026 database.

-- Set SQLID
   SET CURRENT SQLID='CTF2026';

-- Create storage group
   CREATE STOGROUP SGCTF26
                   VOLUMES('*')
                   VCAT YINDB2
                   STORCLAS YINDATA;

   COMMIT;