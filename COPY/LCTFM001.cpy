          05 LCTFM001.
             10 OPCODE            PIC N.
             10 RETURNCODE        PIC N(02).
             10 REASONCODE        PIC N(02).
             10 INFOMESSAGE       PIC N(72).
             10 USERID            PIC N(08).
             10 NICKNAME.
                49 NICKNAME-LEN   PIC S9(4) USAGE COMP-5.
                49 NICKNAME-TEXT  PIC N(128).
             10 EMAIL.
                49 EMAIL-LEN      PIC S9(4) USAGE COMP-5.
                49 EMAIL-TEXT     PIC N(128).
             10 CREATEDBY         PIC N(08).
             10 CREATEDDATE       PIC N(26).
             10 UPDATEDBY         PIC N(08).
             10 UPDATEDDATE       PIC N(26).