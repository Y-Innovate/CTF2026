-- Grant permissions for creating stogroup and database,
-- use of bufferpools and execute on packages to sqlid.

   GRANT CREATESG,CREATEDBA TO CTF2026;
   GRANT USE OF ALL BUFFERPOOLS TO CTF2026;
   GRANT ALL ON PACKAGE CTF2026.* TO CTF2026;