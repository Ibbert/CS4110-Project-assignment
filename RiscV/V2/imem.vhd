-- josemmf@usn.no | 2023.10
-- Single-port ROM w/ 8-bit addr bus, 24-bit data bus
-- (adapted from) Listing 11.5

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity imem is
   generic(
      IMADDR_WIDTH: integer:=5;
      IMDATA_WIDTH: integer:=24
   );
   port(
      im_addr: in std_logic_vector(IMADDR_WIDTH-1 downto 0);
      im_dout: out std_logic_vector(IMDATA_WIDTH-1 downto 0)
    );
end imem;

architecture arch of imem is
   type rom_type is array (0 to 2**IMADDR_WIDTH-1)
        of std_logic_vector(IMDATA_WIDTH-1 downto 0);
    
   constant instr_opcodes: rom_type:=(  
      x"000080",  -- addr 00:	LD   R1,0		# 00000000(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000 
      x"000111",  -- addr 01:   LD   R2,IN		# 00000000(imm) 000(rs2=  ) 000 (rs1=  ) 010(rd=R2) 0010001
	  x"064403",  -- addr 02:	ST   R2,0(R1)	# 00001010(imm) 010(rs2=R2) 001 (rs1=R1) 000(rd=  ) 0000011
	  x"000485",  -- addr 03:	INC  R1			# 00000000(imm) 000(rs2=  ) 001 (rs1=R1) 001(rd=R1) 0000101
	  x"000111",  -- addr 04:	LD   R2,IN 		# 00000000(imm) 000(rs2=  ) 000 (rs1=  ) 010(rd=R2) 0010001
	  x"FD080D",  -- addr 05:	JRNZ R2,-3  	# 11111101(imm) 000(rs2=  ) 010 (rs1=R2) 000(rd=  ) 0001101
	  x"010100",  -- addr 06: 	LD 	 R2,1  		# 00000001(imm) 000(rs2=  ) 000 (rs1=  ) 010(rd=R2) 0000000
	  x"010200",  -- addr 07: 	LD 	 R4,1		# 00000001(imm) 000(rs2=  ) 000 (rs1=  ) 100(rd=R4) 0000000
	  x"000D01",  -- addr 08: 	LD 	 R3,R2		# 00000000(imm) 000(rs2=  ) 011 (rs1=R3) 010(rd=R2) 0000001
	  x"098C10",  -- addr 09: 	BLT  R3,R4,9	# 00001001(imm) 100(rs2=R4) 011 (rs1=R3) 000(rd=  ) 0010000
	  x"082C0F",  -- addr 10: 	BGE  R3,R1,8	# 00001000(imm) 001(rs2=R1) 011 (rs1=R3) 000(rd=  ) 0001111
	  x"000E82",  -- addr 11: 	LD 	 R5,0(R3)	# 00000000(imm) 000(rs2=  ) 011 (rs1=R3) 101(rd=R5) 0000010
	  x"FF0F02",  -- addr 12: 	LD   R6,-1(R3)	# 11111111(imm) 000(rs2=  ) 011 (rs1=R3) 110(rd=R6) 0000010
	  x"05D40F",  -- addr 13: 	BGE  R5,R6,5	# 00000101(imm) 110(rs2=R6) 101 (rs1=R5) 000(rd=  ) 0001111
	  x"00CC03",  -- addr 14: 	ST   R6,0(R3)	# 00000000(imm) 110(rs2=R6) 011 (rs1=R3) 000(rd=  ) 0000011
	  x"FFAC03",  -- addr 15: 	ST   R5,-1(R3)	# 11111111(imm) 101(rs2=R5) 011 (rs1=R3) 000(rd=  ) 0000011
	  x"000D84",  -- addr 16: 	DEC  R3			# 00000000(imm) 000(rs2=  ) 011 (rs1=R3) 011(rd=R3) 0000100
	  x"F8000E",  -- addr 17: 	J    -8			# 11111000(imm) 000(rs2=  ) 000 (rs1=  ) 000(rd=  ) 0001110
	  x"000905",  -- addr 18: 	INC  R2			# 00000000(imm) 000(rs2=  ) 010 (rs1=R2) 010(rd=R2) 0000101
	  x"F52810",  -- addr 19: 	BLT  R2,R1,-11	# 11110101(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0010000
	  x"000100",  -- addr 20: 	LD   R2,0		# 00000000(imm) 000(rs2=  ) 000 (rs1=  ) 010(rd=R2) 0000000
	  x"000982",  -- addr 21: 	LD   R3,0(R2)	# 00000000(imm) 000(rs2=  ) 010 (rs1=R2) 011(rd=R3) 0000010
 	  x"006012",  -- addr 22: 	LD   R3,OUT		# 00000000(imm) 011(rs2=R3) 000 (rs1=  ) 000(rd=  ) 0010010
	  x"000905",  -- addr 23: 	INC  R2			# 00000000(imm) 000(rs2=  ) 010 (rs1=R2) 010(rd=R2) 0000101
	  x"FD2810",  -- addr 24:	BLT  R2,R1,-3	# 11111101(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0010000
	  --x"00000E",  -- addr 25:	J	 0			# 00000000(imm) 000(rs2=  ) 000 (rs1=  ) 000(rd=  ) 0001110
	  x"FFFFFF",  -- addr 26: (void)
	  x"FFFFFF",  -- addr 27: (void)
	  x"FFFFFF",  -- addr 28: (void)
	  x"FFFFFF",  -- addr 29: (void)
	  x"FFFFFF",  -- addr 30: (void)
	  x"FFFFFF"   -- addr 31: (void)
   );
begin
   im_dout <= instr_opcodes(to_integer(unsigned(im_addr)));
end arch;