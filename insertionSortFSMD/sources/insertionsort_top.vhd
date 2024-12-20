-- (adapted from) Listing 7.4
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity inssort is
   generic(
     -- Default setting:
     -- 19,200 baud, 8 data bis, 1 stop bits
      DBIT: integer:=8;     -- # data bits
      SB_TICK: integer:=16; -- # ticks for stop bits, 16/24/32: for 1/1.5/2 stop bits
      DVSR: integer:= 326;  -- baud rate divisor: DVSR = 100M/(16*baud rate)
      DVSR_BIT: integer:=9; -- # bits of DVSR
	  RAM_ADDR_WIDTH: integer:=8;  -- # maximum size of the RAM: 2^10 (1024)
	  RAM_DATA_WIDTH: integer:=8   -- # 8-bit data words
   );
   port(
      clk, reset: in std_logic;
      rx: in std_logic;
      tx: out std_logic
   );
end inssort;

architecture str_arch of inssort is
   signal tick: std_logic;
   signal rx_done: std_logic;
   signal ascii_r, ascii_t: std_logic_vector(7 downto 0);
   signal tx_start, tx_done: std_logic;
   signal clr_lec, inc_lec, ld_lec, dec_lec, clr_rec, inc_rec, ld_rec, dec_rec: std_logic;
   signal clr_ec, inc_ec, ld_ec, dec_ec: std_logic;
   signal  new_min, ld_rer , ld_ler: std_logic;
   signal min_value_addr, rer_value, ler_value: std_logic_vector(7 downto 0);
   signal lec_value, rec_value, ec_value: std_logic_vector(7 downto 0);
   signal ctr_addr_mux, ctr_data_mux: std_logic_vector(1 downto 0);
   signal addr_ram, data_ram, data_in, data_out: std_logic_vector(7 downto 0);
   signal wr: std_logic;

begin

   baud_gen_unit: entity work.mod_m_counter(arch)
      generic map(M=>DVSR, N=>DVSR_BIT)
      port map(
	  clk=>clk, reset=>reset,
      q=>open, max_tick=>tick
	  );

   uart_rx_unit: entity work.uart_rx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(
	  clk=>clk, reset=>reset, rx=>rx,
      s_tick=>tick, rx_done_tick=>rx_done,
      dout=>ascii_r
	  );

   uart_tx_unit: entity work.uart_tx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(
	  clk=>clk, reset=>reset,
      tx_start=>tx_start,
      s_tick=>tick, din=>data_out,
      tx_done_tick=> tx_done, tx=>tx
	  );

   ec_cnt_unit: entity work.xec_cnt(arch)
      generic map(N=>RAM_ADDR_WIDTH)
      port map(
      clk=>clk, reset=>reset,
      clr=>clr_ec, ld=>'0', inc=>inc_ec, dec=>dec_ec,
      d=>(others=>'0'),
      q=>ec_value   
	  );
   lec_cnt_unit: entity work.xec_cnt(arch)
      generic map(N=>RAM_ADDR_WIDTH)
      port map(
      clk=>clk, reset=>reset,
      clr=>clr_lec, ld=>ld_lec, inc=>inc_lec, dec=>dec_lec,
      d=>rec_value ,
      q=>lec_value   
	  );

   rec_cnt_unit: entity work.xec_cnt(arch)
      generic map(N=>RAM_ADDR_WIDTH)
      port map(
      clk=>clk, reset=>reset,
      clr=>clr_rec, ld=>ld_rec, inc=>inc_rec, dec=>dec_rec,
      d=>ec_value,
      q=>rec_value   
	  );

	  
   ram_unit: entity work.xilinx_one_port_ram_sync(arch)
      generic map(ADDR_WIDTH=>RAM_ADDR_WIDTH, DATA_WIDTH=>RAM_DATA_WIDTH)
      port map(
      clk=>clk, wr=>wr,
      addr=>addr_ram,
      din=>data_in, dout=>data_out	  
	  );

   ler_unit: entity work.xreg(arch)
      port map(
      clk=>clk, reset=>reset,
      clr=>'0', load=>ld_ler, 
      d=>data_out,
      q=>ler_value   
	  );
	  
	rer_unit: entity work.xreg(arch)
      port map(
      clk=>clk, reset=>reset,
      clr=>'0', load=>ld_rer, 
      d=>data_out,
      q=>rer_value   
	  );

 
   ctr_path_unit: entity work.ctr_path(arch)
      port map(
      clk=>clk, reset=>reset,
      clr_lec=>clr_lec, inc_lec=>inc_lec, dec_lec =>dec_lec, ld_lec =>ld_lec,
      lec_value=>lec_value, 
      rer_value=>rer_value, ld_rer=>ld_rer,
      ler_value=>ler_value, ld_ler=>ld_ler,
      clr_rec=>clr_rec, ld_rec=>ld_rec, inc_rec=>inc_rec, dec_rec =>dec_rec,
      rx_done=>rx_done, 
      rec_value=>rec_value, 
      clr_ec =>clr_ec, ld_ec=>ld_ec, inc_ec=>inc_ec, ec_value => ec_value, dec_ec =>dec_ec,
      ascii_r=>ascii_r,
      new_min => new_min,
      --ld_mvar=>mvar_ld, 
      ctr_addr_mux=>ctr_addr_mux, ctr_data_mux=>ctr_data_mux,
      wr=>wr,
      data_out=>data_out,
      tx_done=>tx_done, tx_start=>tx_start
	  );
	  
-- glue logic at the top level (two muxes and one magnitude comparator)

	addr_ram <= ec_value when (ctr_addr_mux="00") else 
	            rec_value when (ctr_addr_mux="11") else
	            lec_value;
	data_in <=  ascii_r when (ctr_data_mux="00") else
	            ler_value when (ctr_data_mux="11") else
	            rer_value;  
	new_min <= '1' when unsigned(ler_value) > unsigned(rer_value) else '0';
			   
end str_arch;
