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
      rx_done, tx_done, new_min: in std_logic;
	  ascii_r, data_out, rer_value, ler_value: in std_logic_vector(7 downto 0);
	  rec_value, lec_value, ec_value : in std_logic_vector(M-1 downto 0);
      tx_start, ld_ler, clr_lec, inc_lec, dec_lec, dec_rec, ld_lec: out std_logic;
      clr_rec, inc_rec, ld_rec,ld_rer, dec_ec, wr: out std_logic;
      clr_ec, inc_ec, ld_ec: out std_logic;
      ctr_addr_mux, ctr_data_mux: out std_logic_vector(1 downto 0)
   );
end ctr_path;

architecture arch of ctr_path is
   type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15a, s15b, s16, s17);
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
   process(state_reg, rx_done, tx_done, ascii_r,new_min, data_out, lec_value, rec_value, ler_value, rer_value, ec_value)
   begin
   clr_lec <= '0';
   inc_lec <= '0';
   clr_rec <= '0';
   inc_rec <= '0';
   ld_rec <= '0';
   ld_lec <='0';
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
            
         when s1 =>
            if (rx_done='1') then
               wr <= '1';
 			   if (ascii_r=x"0D") then  -- Enter key?
				   clr_ec <= '1';
				   state_nxt <= s2;
			   else
			       inc_ec <= '1';
			       state_nxt <= s1;
 			   end if;
 			else
 			    state_nxt <= s1;
			end if;
			
	     when s2 =>
	       inc_ec <= '1';
	       state_nxt <= s3;
	       
	     when s3 =>
		   ld_rec <= '1';
		   state_nxt <= s4;
			
         when s4 =>
            ld_lec <= '1';
            state_nxt <=s5;
            
         when s5 =>   
            dec_lec <= '1';
            state_nxt <= s6;

		 when s6 =>
		    ctr_addr_mux <= "01";
		    if (data_out=x"0B") then  -- Enter key?
		      state_nxt <= s13;
		    else
		      state_nxt <= s7;
		    end if;
            

         when s7 =>
            ctr_addr_mux <= "01";
            ld_ler <= '1';
            state_nxt <= s8;

            
         when s8 =>
            ctr_addr_mux <= "11";
            ld_rer <= '1';
            state_nxt <= s9;
            
         when s9 =>
            if (new_min= '1') then
                state_nxt <= s10;
            else
                state_nxt <= s13;
            end if;
            

		 when s10 =>  
		    ctr_addr_mux <= "11"; -- sel addr from right elements cnt
		    ctr_data_mux <= "11";
		    wr <= '1';
		    state_nxt<=s11;
		    
		  when s11 =>  
		    ctr_addr_mux <= "01"; -- sel addr from right elements cnt
		    ctr_data_mux <= "01";
		    wr <= '1';
		    state_nxt <= s12;
		    
		  when s12 =>
		    dec_rec <= '1';
		    state_nxt<=s4;
		
             
         when s13 =>
            inc_ec <='1';
            
            state_nxt <= s14;
            
         when s14 =>
            ctr_addr_mux <= "00";
		    if (data_out=x"0D") then  -- Enter key?
		      state_nxt <= s15b;
		    else
		      state_nxt <= s15a;
		    end if;
           
            

		 when s15a =>
		    ld_rec <='1';
		    state_nxt <= s4;

         when s15b =>
                               
		    clr_ec <='1';
		    state_nxt <= s16;

		 when s16 =>
	        ctr_addr_mux<="00";
	        if (data_out=x"0D") then
		        state_nxt <= s0;
		    else
		        tx_start <= '1';
		        state_nxt <= s17;
		    end if;

		 
		 when s17 =>
             ctr_addr_mux<="00";       
             if (tx_done='1') then
                 inc_ec <= '1';
                 state_nxt <= s16;
              else
                state_nxt <= s17;
             end if;
                 
      end case;
   end process;

end arch;
