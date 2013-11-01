library ieee;
library work;
use ieee.std_logic_1164.all;
use work.i2c_master_Copie.all;

entity lab3_g11 is
  
 generic (
	system_clk	: integer := 50_000_000;--20;
	bus_clk		: integer :=  200_000
);


port
(
	clk 		 : in std_logic; -- System clock
	areset_n	 : in std_logic; -- Async. active low reset
	ena_wr_n	 : in std_logic; -- Write Enable
	ena_rd_n	 : in std_logic; -- Read Enable
	LEDR		 : out std_logic_vector(15 downto 0); -- Data read from slave
	SW			 : in std_logic_vector(1 downto 0); -- Input data
	sda 		 : inout std_logic; -- IC2 data line
	scl		 : inout std_logic -- I2C clock line 
);

end entity lab3_g11;


architecture top_level of lab3_g11 is
	signal local_Y       : std_ulogic;    -- Local version of Y
	signal I, J, K, L, M : std_ulogic;    -- Internal signals
begin  
 -- We need to do two things here : catch the data from 
 -- SW and give it as a resolution when KEY1 is pressed
 --
 -- Then Read after a press on KEY2 the MSB and LSB from 
 --temp Register 
 
 change_remp_resolution : process(clk,SW)
	 begin
		  
		if  ena_wr_n = '1' then
		  output_proc(clk,SW(1 downto 0));
		   end if;
 end process;
end architecture top_level;


