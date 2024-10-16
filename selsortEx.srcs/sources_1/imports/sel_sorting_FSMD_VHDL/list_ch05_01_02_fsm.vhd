-- (adapted from) Listing 5.1
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctr_path is
   generic(
      N: integer := 13;     -- size of array
      M: integer := 8       -- size of RAM address bus
   );
   port(
      clk, reset: in std_logic;
      rx_done, tx_done: in std_logic;
	  ascii_r, data_out, rer_value, ler_value: in std_logic_vector(7 downto 0);
	  rec_value, lec_value, ec_value : in std_logic_vector(M-1 downto 0);
      tx_start, ld_ler, clr_lec, inc_lec, dec_lec, dec_rec, ld_lec: out std_logic;
      clr_rec, inc_rec, ld_rec,ld_rer, dec_ec, wr: out std_logic;
      clr_ec, inc_ec, ld_ec: out std_logic;
      ctr_addr_mux, ctr_data_mux: out std_logic_vector(1 downto 0)
   );
end ctr_path;

architecture arch of ctr_path is
   type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8a, S8b, S9, S10);
   signal state_reg, state_nxt: state_type;
   
begin

   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= s0;
      elsif rising_edge(clk) then
         state_reg <= state_nxt;
      end if;
   end process;
   
   -- next-state and outputs logic
   process(state_reg, rx_done, tx_done, ascii_r, data_out, lec_value, rec_value, ler_value, rer_value, ec_value)
   begin
   clr_lec <= '0';
   inc_lec <= '0';
   clr_rec <= '0';
   inc_rec <= '0';
   ld_rec <= '0';
   clr_ec <= '0';
   inc_ec <= '0';
   ld_ec <= '0';
   ld_ler <= '0';
   clr_lec <= '0';
   dec_ec <='0';
   dec_lec <='0';
   dec_rec<='0';
   wr <= '0';
   tx_start <= '0';
   ctr_addr_mux <= "00"; -- 00: bottom (ec); 01 or 10: middle (lec); 11: top (rec)
   ctr_data_mux <= "00"; -- 00: bottom (UART R); 01 or 10: middle (rer); 11: top (ler)
   state_nxt <= state_reg;
   
      case state_reg is
         when s0 =>
            clr_lec <= '1';
			clr_rec <= '1';
			clr_ec <= '1';
            state_nxt <= s1;
            
         when S1 =>
                                  -- sel addr from left elements cnt, data from UART R (muxs ctr = "00")
            if (rx_done='1') then
               wr <= '1';
 			   if (ascii_r=x"0D") then  -- Enter key?
				   clr_ec <= '1';
				   inc_ec <= '1';
				   ld_rec <= '1';
				   state_nxt <= S2;
			   else
			       inc_ec <= '1';
			       state_nxt <= S1;
 			   end if;
 			else
 			    state_nxt <= S1;
			end if;
			
         when S2 =>
                                  -- sel addr from left elements cnt
            ld_lec <= '1';
            dec_lec <= '1';
            state_nxt <= S3;

		 when S3 =>
		    ctr_addr_mux <= "01";
		    if (data_out=x"0D") then  -- Enter key?
		      state_nxt <= S7;
		    else
		      state_nxt <= S4;
		    end if;
            

         when S4 =>
            ld_ler <= '1';
            ctr_addr_mux <= "11";
            ld_rec <= '1';
            if (ler_value<rer_value) then
                state_nxt <= S5;
            else
                state_nxt <= S7;
            end if;
            

		 when S5 =>  
		    ctr_addr_mux <= "11"; -- sel addr from right elements cnt
		    ctr_data_mux <= "11";
		    wr <= '1';
		    state_nxt<=S6;
		    
		  when S6 =>  
		    ctr_addr_mux <= "01"; -- sel addr from right elements cnt
		    ctr_data_mux <= "01";
		    wr <= '1';
		    dec_rec <= '1';
		    state_nxt<=S2;
		
             
         when S7 =>
            inc_ec <='1';
            ctr_addr_mux <= "00";
		    if (data_out=x"0D") then  -- Enter key?
		      state_nxt <= S8b;
		    else
		      state_nxt <= S8a;
		    end if;
           
            

		 when S8a =>
		    ld_rec <='1';
		    state_nxt <= S2;

         when S8b =>
                                  -- sel addr from left elements cnt
		    clr_ec <='1';
		    state_nxt <= S9;

		 when S9 =>
	        ctr_addr_mux<="00";
	        if (data_out=x"0D") then
		        state_nxt <= S0;
		    else
		        tx_start <= '1';
		        state_nxt <= S10;
		    end if;

		 
		 when S10 =>
             ctr_addr_mux<="00";       -- sel addr from left elements cnt
             if (tx_done='1') then
                 inc_ec <= '1';
                 state_nxt <= S10;
             end if;
                 
      end case;
   end process;

end arch;