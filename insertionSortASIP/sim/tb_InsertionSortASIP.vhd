--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_OneCycleCPU IS
END tb_OneCycleCPU;
 
ARCHITECTURE behavior OF tb_OneCycleCPU IS 
 
    -- Component Declaration for the Unit Under Test (UUT) 
    COMPONENT OneCycleCPU
    PORT(clk, rst: in std_logic);
    END COMPONENT;
    
   --Inputs
   signal clk : std_logic;
   signal rst : std_logic;
 	--Outputs

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: OneCycleCPU PORT MAP (
          clk => clk,
          rst => rst );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
      wait for clk_period;	
	  rst <= '0';
	  wait for clk_period*256;
   end process;

END;
