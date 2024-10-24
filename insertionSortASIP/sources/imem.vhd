-- josemmf@usn.no | 2023.10
-- Single-port ROM w/ 8-bit addr bus, 24-bit data bus
-- (adapted from) Listing 11.5

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity imem is
   generic(
      IMADDR_WIDTH: integer:=6;
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
    --  x"060380",  -- addr 00:     LD   R7,6      # 00000110(imm) 000(rs2=  ) 000 (rs1=  ) 111(rd=R7) 0000000 
   --   x"001D01",  -- addr 01:     LD   R2,R7     # 00000000(imm) 000(rs2=  ) 111 (rs1=R7) 010(rd=R2) 0000001 
	--  x"0A5C03",  -- addr 02:     ST   R2,10(R7) # 00001010(imm) 010(rs2=R2) 111 (rs1=R7) 000(rd=  ) 0000011
--	  x"001F85",  -- addr 03:     INC  R7        # 00000000(imm) 000(rs2=  ) 111 (rs1=R7) 111(rd=R7) 0000101
--	  x"00E886",  -- addr 04: L1: ADD  R1,R2,R7  # 00000000(imm) 111(rs2=R7) 010 (rs1=R2) 001(rd=R1) 0000110
--	  x"002487",  -- addr 05:     SUB  R1,R1,R1  # 00000000(imm) 001(rs2=R1) 001 (rs1=R1) 001(rd=R1) 0000111
--	  x"004888",  -- addr 06:     ORR  R1,R2,R2  # 00000000(imm) 010(rs2=R2) 010 (rs1=R2) 001(rd=R1) 0001000
--	  x"FF0489",  -- addr 07:     ORI  R1,R1,xFF # 11111111(imm) 000(rs2=  ) 001 (rs1=R1) 001(rd=R1) 0001001
--	  x"00448A",  -- addr 08:     ANR  R1,R1,R2  # 00000000(imm) 010(rs2=R2) 001 (rs1=R1) 001(rd=R1) 0001010
--	  x"00088B",  -- addr 09:     ANI  R1,R2,x00 # 00000000(imm) 000(rs2=  ) 010 (rs1=R2) 001(rd=R1) 0001011
--	  x"001F84",  -- addr 10:     DEC  R7        # 00000000(imm) 000(rs2=  ) 111 (rs1=R7) 111(rd=R7) 0000100
--	  x"F91C0D",  -- addr 11:     JRNZ R7,L1     # 11111001(imm) 000(rs2=  ) 111 (rs1=R7) 000(rd=  ) 0001101
--	  x"01080C",  -- addr 12:     JRZ  R7,L2     # 00000001(imm) 000(rs2=  ) 010 (rs1=R7) 000(rd=  ) 0001100
--	  x"0A0B82",  -- addr 13: L2: LD   R7,10(R2) # 00001010(imm) 000(rs2=  ) 010 (rs1=R2) 111(rd=R7) 0000010
--	  x"00000E",  -- addr 14: L3: J    L3        # 00000000(imm) 000(rs2=  ) 000 (rs1=  ) 000(rd=  ) 0001110


	  x"050080",  -- addr 00:	LD   R1,5		# 00000101(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000 
	  x"010100",  -- addr 01:	LD   R2,1		# 00000001(imm) 000(rs2=  ) 000 (rs1=  ) 010(rd=R2) 0000000
	  x"FF2803",  -- addr 02: 	ST   R1,-1(R2)	# 11111111(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0000011
	  x"020080",  -- addr 03:	LD   R1,2		# 00000010(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000 
      x"002803",  -- addr 04: 	ST   R1,0(R2)	# 00000000(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0000011
	  x"030080",  -- addr 05:	LD   R1,3		# 00000011(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000 
      x"012803",  -- addr 06: 	ST   R1,1(R2)	# 00000001(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0000011	  
	  x"010080",  -- addr 07:	LD   R1,1		# 00000001(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000 
	  x"022803",  -- addr 08: 	ST   R1,2(R2)	# 00000010(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0000011  
	  x"040080",  -- addr 09:	LD   R1,4		# 00000001(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000 
	  x"032803",  -- addr 0a: 	ST   R1,3(R2)	# 00000010(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0000011 
	  x"080080",  -- addr 0b:	LD   R1,8		# 00000111(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000 
	  x"042803",  -- addr 0c: 	ST   R1,4(R2)	# 00000100(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0000011 
	  x"070080",  -- addr 0d:	LD   R1,7		# 00001000(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000 
	  x"052803",  -- addr 0e: 	ST   R1,5(R2)	# 00000101(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0000011 
	  x"060080",  -- addr 0f:	LD   R1,6		# 00000110(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000 
	  x"062803",  -- addr 10: 	ST   R1,6(R2)	# 00000110(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0000011 
	  x"070080",  -- addr 11:	LD   R1,8		# 00001000(imm) 000(rs2=  ) 000 (rs1=  ) 001(rd=R1) 0000000
	  
	  x"010100",  -- addr 12: 	LD 	 R2,1  		# 00000001(imm) 000(rs2=  ) 000 (rs1=  ) 010(rd=R2) 0000000
	  x"010200",  -- addr 13: 	LD 	 R4,1		# 00000001(imm) 000(rs2=  ) 000 (rs1=  ) 100(rd=R4) 0000000
	  x"000981",  -- addr 14: 	LD 	 R3,R2		# 00000000(imm) 000(rs2=  ) 010 (rs1=R2) 011(rd=R3) 0000001 
	  x"098C10",  -- addr 15: 	BLT  R3,R4,9	# 00001001(imm) 100(rs2=R4) 011 (rs1=R3) 000(rd=  ) 0010000
	  x"082C0F",  -- addr 16: 	BGE  R3,R1,8	# 00001000(imm) 001(rs2=R1) 011 (rs1=R3) 000(rd=  ) 0001111 
	  x"000E82",  -- addr 17: 	LD 	 R5,0(R3)	# 00000000(imm) 000(rs2=  ) 011 (rs1=R3) 101(rd=R5) 0000010 
	  x"FF0F02",  -- addr 18: 	LD   R6,-1(R3)	# 11111111(imm) 000(rs2=  ) 011 (rs1=R3) 110(rd=R6) 0000010
	  x"05D40F",  -- addr 19: 	BGE  R5,R6,5	# 00000101(imm) 110(rs2=R6) 101 (rs1=R5) 000(rd=  ) 0001111
	  x"00CC03",  -- addr 1a: 	ST   R6,0(R3)	# 00000000(imm) 110(rs2=R6) 011 (rs1=R3) 000(rd=  ) 0000011
	  x"FFAC03",  -- addr 1b: 	ST   R5,-1(R3)	# 11111111(imm) 101(rs2=R5) 011 (rs1=R3) 000(rd=  ) 0000011
	  x"000D84",  -- addr 1c: 	DEC  R3			# 00000000(imm) 000(rs2=  ) 011 (rs1=R3) 011(rd=R3) 0000100
	  x"F8000E",  -- addr 1d: 	J    -8			# 11111000(imm) 000(rs2=  ) 000 (rs1=  ) 000(rd=  ) 0001110
	  x"000905",  -- addr 1e: 	INC  R2			# 00000000(imm) 000(rs2=  ) 010 (rs1=R2) 010(rd=R2) 0000101
	  x"F52810",  -- addr 1f: 	BLT  R2,R1,-11	# 11110101(imm) 001(rs2=R1) 010 (rs1=R2) 000(rd=  ) 0010000
	  x"000100",  -- addr 20: 	LD   R2,0		# 00000000(imm) 000(rs2=  ) 000 (rs1=  ) 010(rd=R2) 0000000
	  x"000982",  -- addr 21: 	LD   R3,0(R2)	# 00000000(imm) 000(rs2=  ) 010 (rs1=R2) 011(rd=R3) 0000010
	  --x"00000E",  -- addr 25:	J	 0			# 00000000(imm) 000(rs2=  ) 000 (rs1=  ) 000(rd=  ) 0001110
      

	  
	  x"FFFFFF",  -- addr 15: (void)
	  x"FFFFFF",  -- addr 16: (void)
	  x"FFFFFF",  -- addr 17: (void)
	  x"FFFFFF",  -- addr 18: (void)
	  x"FFFFFF",  -- addr 19: (void)
	  x"FFFFFF",  -- addr 20: (void)
	  x"FFFFFF",  -- addr 21: (void)
	  x"FFFFFF",  -- addr 22: (void)
	  x"FFFFFF",  -- addr 23: (void)
	  x"FFFFFF",  -- addr 24: (void)
	  x"FFFFFF",  -- addr 25: (void)
	  x"FFFFFF",  -- addr 26: (void)
	  x"FFFFFF",  -- addr 27: (void)
	  x"FFFFFF",  -- addr 28: (void)
	  x"FFFFFF",  -- addr 29: (void)
	  x"FFFFFF",  -- addr 15: (void)
	  x"FFFFFF",  -- addr 16: (void)
	  x"FFFFFF",  -- addr 17: (void)
	  x"FFFFFF",  -- addr 18: (void)
	  x"FFFFFF",  -- addr 19: (void)
	  x"FFFFFF",  -- addr 20: (void)
	  x"FFFFFF",  -- addr 21: (void)
	  x"FFFFFF",  -- addr 22: (void)
	  x"FFFFFF",  -- addr 23: (void)
	  x"FFFFFF",  -- addr 24: (void)
	  x"FFFFFF",  -- addr 25: (void)
	  x"FFFFFF",  -- addr 26: (void)
	  x"FFFFFF",  -- addr 27: (void)
	  x"FFFFFF",  -- addr 28: (void)
	  x"FFFFFF"  -- addr 29: (void)


	  
   );
begin
   im_dout <= instr_opcodes(to_integer(unsigned(im_addr)));
end arch;