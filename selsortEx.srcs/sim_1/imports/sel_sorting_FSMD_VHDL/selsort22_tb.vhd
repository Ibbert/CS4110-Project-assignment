-- adapted from a test bench created by Erica Fegri

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity selsort_tb is
   -- Port ();
end selsort_tb;

architecture arch of selsort_tb is
constant clk_period : time := 10 ns;
constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us

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

Component selsort
Port ( reset, clk: in std_logic;
           rx:      in std_logic;
           tx:     out std_logic);
end Component;

signal clk, reset: std_logic;
signal srx, stx: std_logic;

begin

    uut: selsort
    Port Map(clk => clk, reset => reset, 
              rx => srx, tx => stx);
    
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
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_7(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
        
        -- address 1: 3
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_3(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;

        -- address 2: 5
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_5(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
 
         -- address 3: 6
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_6(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
        
        -- address 4: 1
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_1(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
        
        -- address 5: 3
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_3(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;

        -- address 6: 2
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_2(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
 
         -- address 7: 9
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_9(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
         
        -- address 8: 6
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_6(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
        
        -- address 9: 2
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_2(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;

        -- address 10: 5
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_5(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
 
         -- address 11: 7
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_7(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
 
         -- address 12: 1
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_1(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                wait for 200us;
                                               
         -- address 12: Enter
                srx <= '0'; -- start bit = 0
                wait for bit_period;
                for i in 0 to 7 loop
                    srx <= rx_data_ascii_enter(i);   -- 8 data bits
                    wait for bit_period;
                end loop;
                srx <= '1'; -- stop bit = 1
                
                wait for 8ms;
       
        end process;

end arch;
