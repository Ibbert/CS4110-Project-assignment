-- adapted from a test bench created by Erica Fegri

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_inssort is
   -- Port ();
end tb_inssort;

architecture arch of tb_inssort is
constant clk_period : time := 10 ns;
constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us

constant DRDATA_WIDTH: integer:=8;

constant rx_data_ascii_0: std_logic_vector(7 downto 0) := x"30"; -- receive 0
constant rx_data_ascii_1: std_logic_vector(7 downto 0) := x"31"; -- receive 1
constant rx_data_ascii_2: std_logic_vector(7 downto 0) := x"32"; -- receive 2
constant rx_data_ascii_3: std_logic_vector(7 downto 0) := x"33"; -- receive 3
constant rx_data_ascii_4: std_logic_vector(7 downto 0) := x"34"; -- receive 4
constant rx_data_ascii_5: std_logic_vector(7 downto 0) := x"35"; -- receive 5
constant rx_data_ascii_6: std_logic_vector(7 downto 0) := x"36"; -- receive 6
constant rx_data_ascii_7: std_logic_vector(7 downto 0) := x"37"; -- receive 7
constant rx_data_ascii_8: std_logic_vector(7 downto 0) := x"38"; -- receive 8
constant rx_data_ascii_9: std_logic_vector(7 downto 0) := x"39"; -- receive 9
constant rx_data_ascii_enter: std_logic_vector(7 downto 0) := x"0D"; -- receive Enter
constant rx_data_ascii_null: std_logic_vector(7 downto 0) := x"00"; -- receive Null

Component inssort
Port ( reset, clk: in std_logic;
           srx:      in std_logic;
           stx:     out std_logic);
end Component;

signal clk, reset: std_logic;
signal srx, stx: std_logic_vector(DRDATA_WIDTH-1 downto 0);

begin

    uut: InsSort
    Port Map(clk => clk, reset => reset, 
              rx => srx, tx => stx, );
    
    clk_process: process 
            begin
               clk <= '0';
               wait for clk_period/2;
               clk <= '1';
               wait for clk_period/2;
            end process; 
        
     stim: process
        begin
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';
        wait for clk_period*2;
        -- unordered: 7, 3, 5, 6, 1, 3, 2, 9, 6, 2, 5, 7, 1 
        -- ordered:   1, 1, 2, 2, 3, 3, 5, 5, 6, 6, 7, 7, 9
        -- address 0: 7
                wait for bit_period;
                srx <= rx_data_ascii_7;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
        
        -- address 1: 3
                wait for bit_period;               
                srx <= rx_data_ascii_3;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;

        -- address 2: 5
                wait for bit_period;
                srx <= rx_data_ascii_5;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
 
         -- address 3: 6
                wait for bit_period;
                srx <= rx_data_ascii_6;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
        
        -- address 4: 1
                wait for bit_period;
                srx <= rx_data_ascii_1;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
        
        -- address 5: 3
                wait for bit_period;
                srx <= rx_data_ascii_3;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;

        -- address 6: 2
                wait for bit_period;
                srx <= rx_data_ascii_2;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
 
         -- address 7: 9
                wait for bit_period;
                srx <= rx_data_ascii_9;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
         
        -- address 8: 6
                wait for bit_period;
                srx <= rx_data_ascii_6(i);   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
        
        -- address 9: 2
                wait for bit_period;
                srx <= rx_data_ascii_2;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;

        -- address 10: 5
                wait for bit_period;
                srx <= rx_data_ascii_5;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
 
         -- address 11: 7
                wait for bit_period;
                srx <= rx_data_ascii_7;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
 
         -- address 12: 1
                wait for bit_period;
                srx <= rx_data_ascii_1;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                wait for 200us;
                                               
         -- address 13: Null
                wait for bit_period;
                srx <= rx_data_ascii_null;   -- 8 data bits
                wait until in_done;
                wait for bit_period;
                
                wait for 8ms;
       
        end process;

end arch;
