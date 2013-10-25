--========================================================================================================================
-- Copyright (c) 2013 by Bitvis AS.  All rights reserved.
-- A free license is hereby granted, free of charge, to any person obtaining
-- a copy of this VHDL code and associated documentation files (for 'Bitvis Utility Library'),
-- to use, copy, modify, merge, publish and/or distribute - subject to the following conditions:
--  - This copyright notice shall be included as is in all copies or substantial portions of the code and documentation
--  - The files included in Bitvis Utility Library may only be used as a part of this library as a whole
--  - The License file may not be modified
--  - The calls in the code to the license file ('show_license') may not be removed or modified.
--  - No other conditions whatsoever may be added to those of this License

-- BITVIS UTILITY LIBRARY AND ANY PART THEREOF ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH BITVIS UTILITY LIBRARY.
--========================================================================================================================

------------------------------------------------------------------------------------------
-- VHDL unit     : Bitvis VIP SPI Library : spi_bfm_pkg
--
-- Description   : See library quick reference (under 'doc') and README-file(s)
------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library bitvis_util;
use bitvis_util.types_pkg.all;
use bitvis_util.string_methods_pkg.all;
use bitvis_util.adaptations_pkg.all;
use bitvis_util.methods_pkg.all;
use bitvis_util.bfm_common_pkg.all;

--=================================================================================================
package sbi_bfm_pkg is

  ----------------------------------------------------
  -- Types for SBI BFMs
  ----------------------------------------------------

  constant C_SCOPE : string := "SBI BFM";

  -- Configuration record to be assigned in the test harness.
  type t_sbi_config is
  record
    max_wait_cycles          : integer;
    max_wait_cycles_severity : t_alert_level;
  end record;

  constant C_SBI_CONFIG_DEFAULT : t_sbi_config := (
    max_wait_cycles          => 10,
    max_wait_cycles_severity => failure
    );


  -- Put ports between BFM and DUT in records:
  -- Note: Altera Modelsim 10.0d doesn't support unconstrained field types in records,
  -- so for now we need to pass data_width and addr_width to the BFM
  type t_sbi_core_in is record
    cs         : std_logic;
    rd         : std_logic;
    wr         : std_logic;
    addr       : unsigned(31 downto 0);
    din        : std_logic_vector(127 downto 0);
  end record;

  type t_sbi_core_out is record
    rdy        : std_logic;
    addr_width : natural;
    data_width : natural;
    dout : std_logic_vector(127 downto 0);
  end record;

  constant C_SBI_CORE_IN_DEFAULT : t_sbi_core_in := (
    cs    => '0',
    rd    => '0',
    wr    => '0',
    addr  => (others => '0'),
    din   => (others => '0')
  );

  ----------------------------------------------------
  -- BFM procedures
  ----------------------------------------------------
  procedure write (
    constant addr_value          : in unsigned;
    constant data_value          : in std_logic_vector;
    constant msg           : in string;
    signal   clk           : in std_logic;
    signal   cs            : inout std_logic;
    signal   addr          : inout unsigned;
    signal   rd            : inout std_logic;
    signal   wr            : inout std_logic;
    signal   rdy           : in  std_logic;
    signal   din           : inout std_logic_vector;
    constant clk_period    : in time;
    constant scope         : in string := C_SCOPE;
    constant msg_id_panel  : in t_msg_id_panel  := shared_msg_id_panel;
-- Bør rekkefølge byttes?
    constant config        : in t_sbi_config    := C_SBI_CONFIG_DEFAULT
    );

  procedure check (
    constant addr_value    : in unsigned;
    constant data_exp      : in std_logic_vector;
    constant alert_level   : in t_alert_level := ERROR;
    constant msg           : in string;
    signal   clk           : in std_logic;
    signal   cs            : inout std_logic;
    signal   addr          : inout unsigned;
    signal   rd            : inout std_logic;
    signal   wr            : inout std_logic;
    signal   rdy           : in  std_logic;
    signal   dout          : in  std_logic_vector;
    constant clk_period    : in time;
    constant scope         : in string := C_SCOPE;
    constant msg_id_panel  : in t_msg_id_panel  := shared_msg_id_panel;
    constant config        : in t_sbi_config    := C_SBI_CONFIG_DEFAULT
    );

end package sbi_bfm_pkg;


--=================================================================================================
--=================================================================================================

package body sbi_bfm_pkg is

  ---------------------------------------------------------------------------------
  -- write
  ---------------------------------------------------------------------------------
  procedure write (
    constant addr_value          : in unsigned;
    constant data_value          : in std_logic_vector;
    constant msg           : in string;
    signal   clk           : in std_logic;
    signal   cs            : inout std_logic;
    signal   addr          : inout unsigned;
    signal   rd            : inout std_logic;
    signal   wr            : inout std_logic;
    signal   rdy           : in  std_logic;
    signal   din           : inout std_logic_vector;
    constant clk_period    : in time;
    constant scope         : in string := C_SCOPE;
    constant msg_id_panel  : in t_msg_id_panel  := shared_msg_id_panel;
    constant config        : in t_sbi_config    := C_SBI_CONFIG_DEFAULT
  ) is
    constant name   : string := "SBI write(A:" & to_string(addr_value, HEX, AS_IS, INCL_RADIX) &
                                    ", " & to_string(data_value, HEX, AS_IS, INCL_RADIX) & ")";
    -- Normalise to the DUT addr/data widths
    variable v_normalised_addr  : unsigned(addr'length-1 downto 0) :=
        normalise(addr_value, addr, ALLOW_WIDER_NARROWER, "addr_value", "sbi_core_in.addr", msg);
    variable v_normalised_data  : std_logic_vector(din'length-1 downto 0) :=
        normalise(data_value, din, ALLOW_NARROWER, "data_value", "sbi_core_in.din", msg);
    variable v_clk_cycles_waited : natural := 0;
  begin
    wait_until_given_time_after_rising_edge(clk, clk_period/4);
    cs   <= '1';
    wr   <= '1';
    rd   <= '0';
    addr <= v_normalised_addr;
    din  <= v_normalised_data;

    wait for clk_period;
    while (rdy = '0') loop
      wait for clk_period;
      v_clk_cycles_waited := v_clk_cycles_waited + 1;
      check_value(v_clk_cycles_waited <= config.max_wait_cycles, config.max_wait_cycles_severity,
          ": Timeout while waiting for sbi ready", scope, ID_NEVER, msg_id_panel, name);
    end loop;

    cs  <= '0';
    wr  <= '0';
    log(ID_BFM, name & " completed. " & msg, scope, msg_id_panel);
  end procedure;

  ---------------------------------------------------------------------------------
  -- check()
  ---------------------------------------------------------------------------------
  -- Perform a read operation, then compare the read value to the expected value.
  procedure check (
    constant addr_value    : in unsigned;
    constant data_exp      : in std_logic_vector;
    constant alert_level   : in t_alert_level := ERROR;
    constant msg           : in string;
    signal   clk           : in std_logic;
    signal   cs            : inout std_logic;
    signal   addr          : inout unsigned;
    signal   rd            : inout std_logic;
    signal   wr            : inout std_logic;
    signal   rdy           : in  std_logic;
    signal   dout          : in  std_logic_vector;
    constant clk_period    : in time;
    constant scope         : in string := C_SCOPE;
    constant msg_id_panel  : in t_msg_id_panel  := shared_msg_id_panel;
    constant config        : in t_sbi_config    := C_SBI_CONFIG_DEFAULT
  ) is
    -- TODO: Add info about instance in log
    constant name        : string := "SBI check(A:" & to_string(addr_value, HEX, AS_IS, INCL_RADIX) &
                                      ", "  & to_string(data_exp, HEX, AS_IS, INCL_RADIX) & ")";
    -- Normalise to the DUT addr/data widths
    variable v_normalised_addr  : unsigned(addr'length-1 downto 0) :=
      normalise(addr_value, addr, ALLOW_WIDER_NARROWER, "addr_value", "sbi_core_in.addr", msg);
    -- Helper variables
    variable v_rd_data : std_logic_vector(dout'length - 1 downto 0);
    variable v_check_ok : boolean;
    variable v_clk_cycles_waited : natural := 0;
  begin
    wait_until_given_time_after_rising_edge(clk, clk_period/4);
    cs   <= '1';
    wr   <= '0';
    rd   <= '1';
    addr <= v_normalised_addr;
    wait for clk_period;
    while (rdy = '0') loop
      wait for clk_period;
      v_clk_cycles_waited := v_clk_cycles_waited + 1;
      check_value(v_clk_cycles_waited <= config.max_wait_cycles, config.max_wait_cycles_severity,
          ": Timeout while waiting for sbi ready", scope, ID_NEVER, msg_id_panel, name);
    end loop;

    cs  <= '0';
    wr  <= '0';
    v_rd_data  := dout;
    -- Compare values, but ignore any leading zero's if widths are different.
    -- Use ID_NEVER so that check_value method does not log when check is OK,
    -- log it here instead.
    v_check_ok := check_value(v_rd_data, data_exp, alert_level, msg, scope, HEX_BIN_IF_INVALID, SKIP_LEADING_0, ID_NEVER, msg_id_panel, name);
    if v_check_ok then
      log(ID_BFM, name & "=> OK, read data = " & to_string(v_rd_data, HEX, SKIP_LEADING_0, INCL_RADIX) & ". " & msg, scope, msg_id_panel);
    end if;
  end procedure;


end package body sbi_bfm_pkg;



