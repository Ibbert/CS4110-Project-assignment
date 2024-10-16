-- josemmf@usn.no | 2023.10
-- 1 x 8 RAM with read always enabled
-- no address bus, single data out bus, single data in bus
-- Modified from XST 8.1i rams_07, adapted from listing 11.1

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity out_reg is
   generic(
      DRDATA_WIDTH: integer:=8
   );
   port(
      clk: in std_logic;
      out_reg_write: in std_logic;
      out_reg_in: in std_logic_vector(DRDATA_WIDTH-1 downto 0);
      dig_out: out std_logic_vector(DRDATA_WIDTH-1 downto 0)
    );
end out_reg;

architecture arch of out_reg is
   signal ram: std_logic_vector (DRDATA_WIDTH-1 downto 0);

begin
   process (clk)
   begin
      if rising_edge(clk) then
         if (out_reg_write='1') then
            ram(to_integer(unsigned('1'))) <= out_reg_in;
         end if;
      end if;
   end process;
   dig_out <= ram(to_integer(unsigned('1')));

end arch;