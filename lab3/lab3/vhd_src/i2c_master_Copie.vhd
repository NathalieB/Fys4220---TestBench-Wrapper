library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


package i2c_master is

constant system_clk : integer := 50000000;
constant bus_clk : integer := 400000;

type statetype is (sSTART,sACK1,sACK2,sIDLE,sWRITE,sREAD,sADDR,sMACK,sSTOP);
	
--port
--(
--	clk 		 : in std_logic;
--	areset_n	 : in std_logic;
--	ena		 : in std_logic;
--	addr		 : in std_logic_vector(6 downto 0);
--	rnw		 : in std_logic;
--	data_wr	 : in std_logic_vector(7 downto 0);
--	data_rd	 : out std_logic_vector(7 downto 0);
--	busy		 : out std_logic;
--	ack_error : inout std_logic;
--	sda 		 : inout std_logic;
--	scl		 : inout std_logic
--);

									
	procedure state_proc (clk,areset_n,ena,rnw: in std_logic;
									state: inout statetype);
			
	procedure output_proc (clk,ena,rnw,sda: in std_logic;
									busy,sda_int : inout std_logic;
									ack_error,scl_oe: out std_logic;
									addr : in std_logic_vector(6 downto 0);
									data_wr: in std_logic_vector(7 downto 0);
									data_tx,addr_rnw: inout std_logic_vector(7 downto 0);
									data_rx: out std_logic_vector(7 downto 0);
									state: in statetype;
									bit_count: inout integer );
									
									
	procedure sda_scl_proc(scl_oe,scl_clk,sda_int : in std_logic;
			data_rd: in std_logic_vector;
			data_rx : out std_logic_vector;
			rnw_i,scl,sda : out std_logic;
			rnw: in std_logic);
			
	procedure clk_proc (clk,areset_n: in std_logic;
									state_ena,scl_high_ena: inout std_logic;
									scl_clk: out std_logic;
									counter : inout integer);
									
									
		
	signal state 		: 	statetype := sIDLE;
	signal state_ena	:	std_logic := '1';
	signal scl_high_ena	:	std_logic := 'Z';
	signal scl_clk		:	std_logic := '0';
	signal scl_oe		:	std_logic := '0';
	signal ack_error_i:	std_logic := 'Z';
	signal rnw_i		:	std_logic := '0';	
	signal sda_int		:	std_logic := '0';
	signal addr_rnw	:	std_logic_vector(7 downto 0) := (others => '0');
	signal data_tx		:	std_logic_vector(7 downto 0) := (others => '0'); -- latched data to slave
	signal data_rx		:	std_logic_vector(7 downto 0) := (others => '0'); -- latched data from slave
	signal bit_count	:	integer range 0 to 7 := 0;
	signal counter 	: 	integer range 0 to 2000 := 0;

	end;
	
	package body i2c_master is
	
	--type statetype is (sSTART,sACK1,sACK2,sIDLE,sWRITE,sREAD,sADDR,sMACK,sSTOP);
	-- Internal signal declaration

	
	--begin

	-- This process triggers the state change
		procedure state_proc (clk,areset_n,ena,rnw: in std_logic;
									state: inout statetype) is
		begin
		if areset_n = '0' then
			state := sIDLE;
		elsif clk = '1'  then
			case state is			
				when sSTART =>
					if state_ena = '1' then	
						state := sADDR;
					end if;
				when sADDR =>
					if state_ena = '1' and bit_count = 0 then
						state := sACK1;
					end if;
				when sACK1 =>
					if state_ena = '1' and rnw_i = '0' then
						state := sWRITE;
					elsif state_ena = '1' and rnw_i = '1' then	
						state := sREAD;
					end if;
				when sWRITE =>
					if state_ena = '1' and bit_count = 0 then 
						state := sACK2;
					end if;
				when sACK2 => 
					if state_ena = '1' and ena = '0' then
						state := sSTOP;
					elsif state_ena = '1' and ena = '1' and rnw = '0' then	
						state := sWRITE;
					elsif state_ena = '1' and ena = '1' and rnw = '1' then	
							state := sSTART;
					end if;
					
				when sREAD =>
					if state_ena = '1' and bit_count = 0 then 
						state := sMACK;
					end if;
				when sMACK =>
					if state_ena = '1' and ena = '0' then
						state := sSTOP;
					elsif state_ena = '1' and ena = '1' and rnw = '0' then	
						state := sSTART;
					elsif state_ena = '1' and ena = '1' and rnw = '1' then	
							state := sREAD;
					end if;
				when sSTOP =>
					if state_ena = '1' then	
						state := sIDLE;
					end if;
				when sIDLE =>
					if state_ena = '1' and ena = '1' then
						state := sSTART;
					end if;
				end case;
			end if;
		end state_proc;
		
		
		-- This process modifies variables according to the state value
		procedure output_proc (clk,ena,rnw,sda: in std_logic;
										busy,sda_int : inout std_logic;
										ack_error,scl_oe: out std_logic;
										addr : in std_logic_vector(6 downto 0);
										data_wr: in std_logic_vector(7 downto 0);
										data_tx,addr_rnw: inout std_logic_vector(7 downto 0);
										data_rx: out std_logic_vector(7 downto 0);
										state: in statetype;
									 bit_count: inout integer ) is
		--,state,ena,scl_high_ena,rnw,state_ena,data_wr,addr,bit_count,data_tx,addr_rnw)
		begin
		if clk = '1' then 
			case state is 
				when sIDLE => 
					busy := '0';
					scl_oe := '0';
					if ena = '1' then	
						addr_rnw := addr & rnw;
					end if;
					sda_int := '1';
				when sSTART => -- Ok
					busy := '1';
					scl_oe := '1';
					sda_int := '1';
					if scl_high_ena = '1' then
						sda_int := '0';
					end if;
					
				when sADDR => -- Ok
					busy := '1';
					scl_oe := '1';
					sda_int := addr_rnw(bit_count) ;
					if bit_count = 0 then	
						bit_count := 7;
					else 
						bit_count := (bit_count -1);
					end if;
				when sACK1 => -- Ok
					busy := '0';
					scl_oe := '1';
					sda_int := '1';
					if scl_high_ena = '1' then		
						if sda_int = '1' then
							ack_error := '1';
						end if;
					end if;
				when sWRITE => -- Ok
					busy := '1';
					scl_oe := '1';
					sda_int := data_tx(bit_count);
					if bit_count = 0 then	
						bit_count := 7;
					else 
						bit_count := (bit_count -1);
					end if;
				when sREAD =>
					busy := '1';
					scl_oe := '1';
					sda_int := '1';
					if scl_high_ena = '1' then
						data_rx(bit_count):= sda;
					end if;
					if bit_count = 0 then	
						bit_count := 7;
					else 
						bit_count := (bit_count -1);
					end if;
				when sACK2 => -- Eventuellement a reprendre
					sda_int := '1';
					scl_oe := '1';
					busy := '0';
					if ena = '1' and rnw = '0' then	
						data_tx := data_wr;
						--addr_rnw <= addr & rnw;
					elsif ena = '1'  and rnw = '1' then
						addr_rnw := addr & rnw;
						--data_tx <= data_wr;
					end if;
					if scl_high_ena = '1' then
						if sda = '1' then
							ack_error := '1';
						end if;
				end if;
				when sMACK =>
					sda_int := '1';
					scl_oe := '1';
					busy := '0';
					if ena = '1' and rnw = '0' then -- restart condition
						sda_int := '1';
						if scl_high_ena = '1' then
							sda_int := '0';
						end if;
						elsif ena = '0' and state_ena = '1' then
							sda_int := '0';
					end if;
				when sSTOP =>
					busy := '1';
					scl_oe := '1';
					if scl_high_ena = '1' then	
						sda_int := '1';
					end if;
			end case;
			end if;
		end procedure;
		
	
		-- This process creates a clock divider used by our bus
		procedure clk_proc (clk,areset_n: in std_logic;
									state_ena,scl_high_ena: inout std_logic;
									scl_clk: out std_logic;
									counter : inout integer) is
			variable divider : integer := 5;
		
		begin
			--divider := system_clk/bus_clk;
			if areset_n = '0'  then
				scl_clk := '0';
				counter := 0;
				scl_high_ena := '0';
			elsif state_ena = 'U' and scl_high_ena = '0' then	
				counter := 0;
				scl_clk := '0';		
			elsif clk = '1' then
				state_ena:= 'Z';
				counter := (counter + 1);
					
					if counter = ((divider /2 )-1) then
						scl_clk := '1';
			
					elsif counter = (divider -1) then	
						state_ena := '1';
						scl_clk := '0';
						counter := 0;					
					end if;	

			end if;		
		end clk_proc;
	
		
		-- This process controls the SDA and SCL lines
		procedure sda_scl_proc(scl_oe,scl_clk,sda_int : in std_logic;
			data_rd: in std_logic_vector;
			data_rx : out std_logic_vector;
			rnw_i,scl,sda : out std_logic;
			rnw: in std_logic) is
		begin
		data_rx(bit_count) :=	data_rd(bit_count)  ;
		rnw_i := rnw ;
			-- Set the clock of the I2C bus
			if scl_oe = '1' then
				scl := scl_clk;
			else
				scl := 'Z';
			end if;
			-- Set the data line of the I2C bus
			if sda_int = '1' then
				sda := 'Z';
			else
				sda := '0';
			end if;
		end sda_scl_proc;
		
	end package body i2c_master;
	
