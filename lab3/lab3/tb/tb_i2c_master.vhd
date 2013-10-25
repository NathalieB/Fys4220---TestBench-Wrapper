library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
--use work.tb_lab2_gx_pkg.all;

library modelsim_lib;
use modelsim_lib.util.all;


--Bivis utility library
library ieee_proposed;
use ieee_proposed.standard_additions.all;
use ieee_proposed.std_logic_1164_additions.all;

library bitvis_util;
use bitvis_util.types_pkg.all;
use bitvis_util.string_methods_pkg.all;
use bitvis_util.adaptations_pkg.all;
use bitvis_util.methods_pkg.all;


--use work.tb_pkg.all;

entity tb_i2c_master is
end tb_i2c_master;


architecture tb of tb_i2c_master is


-------------------------------------------------------------------------------
-- I2C master signals and constants
-------------------------------------------------------------------------------
  
  signal clk_tb          : std_logic;
  signal areset_n_tb     : std_logic;
  signal ena_tb          : std_logic;
  signal addr_tb         : std_logic_vector(6 downto 0);
  signal rnw_tb           : std_logic;
  signal data_wr_tb      : std_logic_vector(7 downto 0);
  signal busy_tb         : std_logic;
  signal data_rd_tb      : std_logic_vector(7 downto 0);
  signal ack_error_tb    : std_logic;
  signal sda_tb          : std_logic;
  signal scl_tb          : std_logic;
  constant system_clk_tb : integer := 50_000_000;
  constant bus_clk_tb    : integer := 200_000;

-------------------------------------------------------------------------------
-- TB signals and constants
-------------------------------------------------------------------------------
  --Clock related
  signal clk_ena_tb   : boolean := false;
  constant clk_period : time    := 20 ns;  --50 MHz
  constant clk_ratio  : integer := system_clk_tb/bus_clk_tb;

  --TMP175 address values
  constant tmp175_addr : std_logic_vector(6 downto 0) := "1001000";
  constant temp_addr   : std_logic_vector(7 downto 0) := "00000000";
  constant config_addr : std_logic_vector(7 downto 0) := "00000001";
  constant tlow_addr   : std_logic_vector(7 downto 0) := "00000010";
  constant thigh_addr  : std_logic_vector(7 downto 0) := "00000011";

  --Types and signals related to data handling in TB
  type t_byte_array is array (0 to 1) of std_logic_vector(7 downto 0);
  signal reg_data : t_byte_array;
  signal data     : std_logic_vector(7 downto 0);

  --Set scope value for TB (used to identify source of msg in log file)
  constant C_SCOPE : string := "TB seq.";

  
begin

-------------------------------------------------------------------------------
-- TB Clock generator
-------------------------------------------------------------------------------
  clk_tb <= not clk_tb after clk_period/2 when clk_ena_tb else '0';


-------------------------------------------------------------------------------
-- TB Component instantiation 
-------------------------------------------------------------------------------

  --TMP175 simulation model
  tmp175_simmodel_1 : entity work.tmp175_simmodel
    generic map (
      i2c_clk => bus_clk_tb)
    port map (
      sda => sda_tb,
      scl => scl_tb);

  --I2C master 
  uut : entity work.i2c_master
    generic map (
      system_clk => system_clk_tb,
      bus_clk    => bus_clk_tb)
    port map (
      --in
      clk       => clk_tb,
      areset_n  => areset_n_tb,
      ena       => ena_tb,
      addr      => addr_tb,
      rnw        => rnw_tb,
      data_wr   => data_wr_tb,
      --output
      busy      => busy_tb,
      data_rd   => data_rd_tb,
      ack_error => ack_error_tb,
      sda       => sda_tb,
      scl       => scl_tb);



  tb_test_sequencer : process


-------------------------------------------------------------------------------
-- Test sequencer support procedures
-------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- set_inputs_default
-- purpose: set start values of UUT input signals
-- parameters: 
--   dummy:    (t_void)     
------------------------------------------------------------------------------
    procedure set_inputs_default(dummy : t_void) is
    begin
      sda_tb     <= 'Z';
      rnw_tb      <= '0';
      ena_tb     <= '0';
      addr_tb    <= (others => '0');
      data_wr_tb <= X"00";
      scl_tb     <= 'Z';
    end procedure;


------------------------------------------------------------------------------
-- pulse
-- purpose: general purpose pulse generator
-- parameters: 
--   target: (std_logic) target signal to be operated on
--   pulse_value: (std_logic) value of pulse (1= high, 0=low)
--   clk:   (std_logic)  reference clk
--   num_periods: (natural) used to specify length of pulse
--   msg: (string)  log msg to be displayed at pulse generation      
------------------------------------------------------------------------------   
    procedure pulse(
      signal target        : inout std_logic;
      constant pulse_value : in    std_logic;
      signal clk           : in    std_logic;
      constant num_periods : in    natural;
      constant msg         : in    string)
    is
    begin
      if num_periods > 0 then
        wait until falling_edge(clk);
        target <= '0';                  --pulse_value;
        for i in 1 to num_periods loop
          wait until falling_edge(clk);
        end loop;
      else
        target <= pulse_value;
      end if;
      target <= not(pulse_value);       --not (pulse_value);
      log(ID_SEQUENCER_SUB, msg, C_SCOPE);
    end procedure;


------------------------------------------------------------------------------
-- write_byte
-- purpose: write byte of data to the I2C bus 
-- parameters: 
--   data: (std_logic_vector) data to be written to I2C bus
------------------------------------------------------------------------------   
    procedure write_byte(
      constant data : in std_logic_vector(7 downto 0))
    is
    begin
      --time out after some time if busy never goes low in order to stop simulations
      await_value(busy_tb, '0', 0 ns, clk_ratio*100*clk_period, error, "Busy low detected", C_SCOPE);
      wait until rising_edge(clk_tb);   --synchronize with clock
      rnw_tb      <= '0';                --set write condition
      data_wr_tb <= data;               --put data on data input of i2c master
      ena_tb     <= '1';                --activate enable
      await_value(busy_tb, '1', 0 ns, clk_ratio*100*clk_period, error, "Busy high detected (I2C command detected)", C_SCOPE);
		await_value(busy_tb, '0', 0 ns, clk_ratio*100*clk_period, error, "Busy low detected (I2C command complete)", C_SCOPE);
    end procedure;

------------------------------------------------------------------------------
-- read_byte
-- purpose: read byte of data from the I2C bus 
-- parameters: 
--   data: (std_logic_vector) data to returned from I2C bus
------------------------------------------------------------------------------       
    procedure read_byte(
      signal data : out std_logic_vector(7 downto 0)) is
    begin
      --time out after some time if busy never goes low in order to stop simulations
      await_value(busy_tb, '0', 0 ns, clk_ratio*100*clk_period, error, "Busy low detected", C_SCOPE);
      wait until rising_edge(clk_tb);
      rnw_tb  <= '1';                    --set read condition
      ena_tb <= '1';                    -- keep enable high
      await_value(busy_tb, '1', 0 ns, clk_ratio*100*clk_period, error, "Busy high detected (I2C command detected)", C_SCOPE);
      await_value(busy_tb, '0', 0 ns, clk_ratio*100*clk_period, error, "Busy low detected (I2C command complete)", C_SCOPE);
      --Convert Z values to 1
      for i in 0 to data_rd_tb'length-1
      loop
        if data_rd_tb(i) = 'Z' then
          data(i) <= '1';
        else
          data(i) <= '0';
        end if;
      end loop;
    end procedure;

------------------------------------------------------------------------------
-- write_reg
-- purpose: Write to the TMP175 registers
-- parameters: 
--   reg_addr: (std_logic_vector) address of register to be written to
--   byte_array: (t_byte_array) array of 8-bit slv vectors to be written
--  no_bytes: (natural) number of consequtive bytes to be written
------------------------------------------------------------------------------       
    procedure write_reg(
      constant reg_addr   : in std_logic_vector;
      constant byte_array : in t_byte_array;
      constant no_bytes   : in natural)
    is
    begin
      addr_tb <= tmp175_addr;  --put I2C device address on master input
      write_byte(reg_addr);
      --loop over number of bytes to be written
      for i in 0 to no_bytes-1
      loop
        write_byte(byte_array(i));
      end loop;
      ena_tb <= '0';                    --end transaction
      wait for clk_ratio*2*clk_period;  --two scl periods
    end procedure;


------------------------------------------------------------------------------
-- check_reg_value
-- purpose: read from TMP175 registers and check for expected value
-- parameters: 
--   reg_addr: (std_logic_vector) address of register to be written to
--   exp_byte_array: (t_byte_array) array of expected byte values
--   read_data: (t_byte_array) array of data read
--  no_bytes: (natural) number of consequtive bytes to be read
------------------------------------------------------------------------------       
    procedure check_reg_value(
      constant reg_addr       : in  std_logic_vector;
      constant exp_byte_array : in  t_byte_array;
      signal read_data        : inout std_logic_vector;
      constant no_bytes       : in  natural)
    is

    begin
      addr_tb <= tmp175_addr;
      write_byte(reg_addr);
      for i in 0 to no_bytes-1
      loop
        read_byte(read_data);
        wait for 0 ns;  --wait for delta cycle to allow for output data to be updated
        check_value(read_data, exp_byte_array(i), warning, "Read from reg.: " & to_string(reg_addr));
      end loop;
      ena_tb <= '0';                    --end transactions
      wait for clk_ratio*2*clk_period;  --two scl periods
    end procedure;
    

  begin

    ----------------------------------------------------------------------------------
    -- Set and report init conditions
    ----------------------------------------------------------------------------------
    -- Increment alert counter as two warning is expected when testing writing
    -- to temperature register
    increment_expected_alerts(warning, 2);
    -- report/enable logging/alert conditions
    report_global_ctrl(VOID);
    report_msg_id_panel(VOID);
    enable_log_msg(ALL_MESSAGES);
    disable_log_msg(ID_POS_ACK);        --make output a bit cleaner


    --Start simulation
    log(ID_LOG_HDR, "Start Simulation of TB for I2C master", C_SCOPE);
    log(ID_LOG_HDR, "Setting and checking default values of I2C master I/O", C_SCOPE);
    set_inputs_default(VOID);
    clk_ena_tb <= true;
    pulse(areset_n_tb, '0', clk_tb, 5, "Activate reset");

   
    --Preform check of config.register (1 byte)
    log(ID_LOG_HDR, "Setting and check TMP175 resolution bits", C_SCOPE);
    reg_data(0) <= "01100000";
    write_reg(config_addr, reg_data, 1);
    check_reg_value(config_addr, reg_data, data, 1);

    --Preform check of tlow register (2 bytes)
    log(ID_LOG_HDR, "Setting and check TMP175 TLOW register", C_SCOPE);
    reg_data(0) <= "01010101";          --MSB
    reg_data(1) <= "11001100";          --LSB
    write_reg(tlow_addr, reg_data, 2);
    check_reg_value(tlow_addr, reg_data, data, 2);
	 
    --Preform check of thigh register (2 bytes)
    log(ID_LOG_HDR, "Setting and check TMP175 THIGH register", C_SCOPE);
    reg_data(0) <= "00010001";          --MSB
    reg_data(1) <= "00110011";          --LSB
    write_reg(thigh_addr, reg_data, 2);
    check_reg_value(thigh_addr, reg_data, data, 2);



    --Preform write and check of temp reg. (1 byte)
    --Warning is expexted as the temp. reg is read only.
    log(ID_LOG_HDR, "Preforming write and read of temperature reg.", C_SCOPE);
    reg_data(0) <= "00010010";
    reg_data(1) <= "11110000";
    write_reg(temp_addr, reg_data, 2);
    reg_data(0) <= "00000000";          --Expect zero as temp. is read only
    reg_data(1) <= "00000000";          --Expect zero as temp. is read only
    check_reg_value(temp_addr, reg_data, data, 2);

	log(ID_LOG_HDR, "TRUC", C_SCOPE);

    wait for 100*clk_period;
    report_alert_counters(FINAL);

    clk_ena_tb <= false;
    wait;


  end process;
  
end architecture;
