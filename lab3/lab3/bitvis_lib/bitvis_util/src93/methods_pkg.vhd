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
-- VHDL unit     : Bitvis Utility Library : methods_pkg
--
-- Description   : See library quick reference (under 'doc') and README-file(s)
------------------------------------------------------------------------------------------


--NOTE*** This version intended to remove ALL protected variables that need not functionally be protected

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.types_pkg.all;
use work.string_methods_pkg.all;
use work.adaptations_pkg.all;
--use work.protected_types_pkg.all;
use work.vhdl_version_layer_pkg.all;
use work.license_pkg.all;


library ieee_proposed;
use ieee_proposed.standard_additions.all;
use ieee_proposed.std_logic_1164_additions.all;
use ieee_proposed.standard_textio_additions.all;

package methods_pkg is



  -- Shared variables)
  shared variable shared_initialised_util        : boolean  := false;
  shared variable shared_msg_id_panel            : t_msg_id_panel   := C_DEFAULT_MSG_ID_PANEL;
  shared variable shared_log_file_name_is_set    : boolean  := false;
  shared variable shared_alert_file_name_is_set  : boolean  := false;
  shared variable shared_warned_time_stamp_trunc : boolean  := false;
  shared variable shared_alert_attention         : t_alert_attention:= C_DEFAULT_ALERT_ATTENTION;
  shared variable shared_stop_limit              : t_alert_counters := C_DEFAULT_STOP_LIMIT;
  shared variable shared_log_hdr_for_waveview    : string(1 to C_LOG_HDR_FOR_WAVEVIEW_WIDTH);
  shared variable shared_seed1                   : positive;
  shared variable shared_seed2                   : positive;


-- -- ============================================================================
-- -- Initialisation and license
-- -- ============================================================================
--   procedure initialise_util(
--     constant dummy  : in t_void
--     );
--

-- ============================================================================
-- File handling (that needs to use other utility methods)
-- ============================================================================
  procedure check_file_open_status(
    constant status      : in file_open_status;
    constant file_name   : in string
    );

  procedure set_alert_file_name(
    constant file_name   : in string := C_ALERT_FILE_NAME;
    constant msg_id      : t_msg_id  := ID_UTIL_SETUP
    );

  procedure set_log_file_name(
    constant file_name   : in string := C_LOG_FILE_NAME;
    constant msg_id      : t_msg_id  := ID_UTIL_SETUP
    );


-- ============================================================================
-- Log-related
-- ============================================================================
  procedure log(
    msg_id         : t_msg_id;
    msg            : string;
    scope          : string         := C_TB_SCOPE_DEFAULT;
    msg_id_panel   : t_msg_id_panel := shared_msg_id_panel
    );

  -- Enable and Disable do not have a Scope parameter as they are only allowed from main test sequencer
  procedure enable_log_msg(
    constant msg_id         : t_msg_id;
    variable msg_id_panel   : inout t_msg_id_panel;
    constant msg            : string := ""
    );

  procedure enable_log_msg(
    msg_id         : t_msg_id;
    msg            : string  := ""
    ) ;
  procedure disable_log_msg(
    constant msg_id         : t_msg_id;
    variable msg_id_panel   : inout t_msg_id_panel;
    constant msg            : string  := ""
    );

  procedure disable_log_msg(
    msg_id         : t_msg_id;
    msg            : string  := ""
    );


-- ============================================================================
-- Alert-related
-- ============================================================================
  procedure alert(
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  -- Dedicated alert-procedures all alert levels (less verbose - as 2 rather than 3 parameters...)
  procedure note(
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  procedure tb_note(
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  procedure warning(
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  procedure tb_warning(
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  procedure manual_check(
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  procedure error(
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  procedure tb_error(
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  procedure failure(
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  procedure tb_failure(
    constant msg         : string;
    constant scope       : string    := C_TB_SCOPE_DEFAULT
    );

  procedure increment_expected_alerts(
    constant alert_level  : t_alert_level;
    constant number       : natural := 1
  );

  procedure report_alert_counters(
    constant order  : in t_order
  );

  procedure report_alert_counters(
    constant dummy  : in t_void
  );

  procedure report_global_ctrl(
    constant dummy  : in t_void
  );

  procedure report_msg_id_panel(
    constant dummy  : in t_void
  );

  procedure set_alert_attention(
      alert_level : t_alert_level;
      attention   : t_attention
  );

  impure function get_alert_attention(
      alert_level : t_alert_level
  ) return t_attention;

  procedure set_alert_stop_limit(
      alert_level : t_alert_level;
      value       : natural
  );

  impure function get_alert_stop_limit(
      alert_level : t_alert_level
  ) return natural;

-- ============================================================================
-- Non time consuming checks
-- ============================================================================

  -- Matching if same width or only zeros in "extended width"
  function matching_widths(
    value1: std_logic_vector;
    value2: std_logic_vector
    ) return boolean;

  function matching_widths(
    value1: unsigned;
    value2: unsigned
    ) return boolean;

  function matching_widths(
    value1: signed;
    value2: signed
    ) return boolean;

  -- function version of check_value (with return value)
  impure function check_value(
    constant value       : boolean;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) return boolean ;

  impure function check_value(
    constant value       : std_logic;
    constant exp         : std_logic;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) return boolean ;

  impure function check_value(
    constant value       : std_logic_vector;
    constant exp         : std_logic_vector;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "slv"
    ) return boolean ;

  impure function check_value(
    constant value       : unsigned;
    constant exp         : unsigned;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "unsigned"
    ) return boolean ;

  impure function check_value(
    constant value       : signed;
    constant exp         : signed;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "signed"
    ) return boolean ;


  impure function check_value(
    constant value       : integer;
    constant exp         : integer;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) return boolean ;

  impure function check_value(
    constant value       : time;
    constant exp         : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) return boolean ;

  impure function check_value(
    constant value       : string;
    constant exp         : string;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) return boolean ;

  -- procedure version of check_value (no return value)
  procedure check_value(
    constant value     : boolean;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    );

  procedure check_value(
    constant value       : std_logic_vector;
    constant exp         : std_logic_vector;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "slv"
    );

  procedure check_value(
    constant value       : unsigned;
    constant exp         : unsigned;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "unsigned"
    );

  procedure check_value(
    constant value       : signed;
    constant exp         : signed;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "signed"
    );


  procedure check_value(
    constant value       : std_logic;
    constant exp         : std_logic;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    );

  procedure check_value(
    constant value       : integer;
    constant exp         : integer;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    );

  procedure check_value(
    constant value       : time;
    constant exp         : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    );

  procedure check_value(
    constant value       : string;
    constant exp         : string;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    );

  -- Check_value_in_range
  impure function check_value_in_range (
    constant value        : integer;
    constant min_value    : integer;
    constant max_value    : integer;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()";
    constant value_type   : string         := "integer"
    ) return boolean;

  impure function check_value_in_range (
    constant value        : unsigned;
    constant min_value    : unsigned;
    constant max_value    : unsigned;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()";
    constant value_type   : string         := "unsigned"
    ) return boolean;

  impure function check_value_in_range (
    constant value        : signed;
    constant min_value    : signed;
    constant max_value    : signed;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()";
    constant value_type   : string         := "signed"
    ) return boolean;

  impure function check_value_in_range (
    constant value        : time;
    constant min_value    : time;
    constant max_value    : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()"
    ) return boolean;

  impure function check_value_in_range (
    constant value        : real;
    constant min_value    : real;
    constant max_value    : real;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()"
    ) return boolean;

  -- Procedure overloads for check_value_in_range
  procedure check_value_in_range (
    constant value       : integer;
    constant min_value   : integer;
    constant max_value   : integer;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()"
  );

  procedure check_value_in_range (
    constant value       : unsigned;
    constant min_value   : unsigned;
    constant max_value   : unsigned;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value_in_range()"
  );

  procedure check_value_in_range (
    constant value       : signed;
    constant min_value   : signed;
    constant max_value   : signed;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value_in_range()"
  );

  procedure check_value_in_range (
    constant value       : time;
    constant min_value   : time;
    constant max_value   : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value_in_range()"
  );

  procedure check_value_in_range (
    constant value       : real;
    constant min_value   : real;
    constant max_value   : real;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value_in_range()"
  );

  -- Check_stable
  procedure check_stable(
    signal   target      : boolean;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "boolean"
    );

  procedure check_stable(
    signal   target      : std_logic_vector;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "slv"
    );

  procedure check_stable(
    signal   target      : unsigned;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "unsigned"
    );

  procedure check_stable(
    signal   target      : signed;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "signed"
    );

  procedure check_stable(
    signal   target      : std_logic;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "std_logic"
    );

  procedure check_stable(
    signal   target      : integer;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "integer"
    );

  impure function random (
    constant length : integer
  )  return std_logic_vector;

  impure function random (
    constant VOID : t_void
  )  return std_logic;

  impure function random (
    constant min_value : integer;
    constant max_value : integer
  ) return integer;

  impure function random (
    constant min_value : real;
    constant max_value : real
  ) return real;

  impure function random (
    constant min_value : time;
    constant max_value : time
  ) return time;

  procedure random (
    variable v_seed1       : inout positive;
    variable v_seed2       : inout positive;
    variable v_target      : inout std_logic_vector
  );

  procedure random (
    variable v_seed1       : inout positive;
    variable v_seed2       : inout positive;
    variable v_target      : inout std_logic
  );

  procedure random (
    constant min_value : integer;
    constant max_value : integer;
    variable v_seed1   : inout positive;
    variable v_seed2   : inout positive;
    variable v_target  : inout integer
  );

  procedure random (
    constant min_value : real;
    constant max_value : real;
    variable v_seed1   : inout positive;
    variable v_seed2   : inout positive;
    variable v_target  : inout real
  );

  procedure random (
    constant min_value : time;
    constant max_value : time;
    variable v_seed1   : inout positive;
    variable v_seed2   : inout positive;
    variable v_target  : inout time
  );


  procedure randomise (
    constant seed1 : positive;
    constant seed2 : positive
  );


-- ============================================================================
-- Time consuming checks
-- ============================================================================

  procedure await_change(
    signal   target      : boolean;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant value_type  : string          := "boolean"
    );

  procedure await_change(
    signal   target      : std_logic;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant value_type  : string          := "std_logic"
    );

  procedure await_change(
    signal   target      : std_logic_vector;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant value_type  : string          := "slv"
    );

  procedure await_change(
    signal   target      : unsigned;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant value_type  : string          := "unsigned"
    );

  procedure await_change(
    signal   target      : signed;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant value_type  : string          := "signed"
    );

  procedure await_change(
    signal   target      : integer;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant value_type  : string          := "integer"
    );

  procedure await_value (
    signal   target       : boolean;
    constant exp          : boolean;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    );

  procedure await_value (
    signal   target       : std_logic;
    constant exp          : std_logic;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    );

  procedure await_value (
    signal   target       : std_logic_vector;
    constant exp          : std_logic_vector;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant radix        : t_radix         := HEX_BIN_IF_INVALID;
    constant format       : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    );

  procedure await_value (
    signal   target       : unsigned;
    constant exp          : unsigned;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant radix        : t_radix         := HEX_BIN_IF_INVALID;
    constant format       : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    );

  procedure await_value (
    signal   target       : signed;
    constant exp          : signed;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant radix        : t_radix         := HEX_BIN_IF_INVALID;
    constant format       : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    );

  procedure await_value (
    signal   target       : integer;
    constant exp          : integer;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    );


end package methods_pkg;


--=================================================================================================
--=================================================================================================
--=================================================================================================

package body methods_pkg is

  constant C_BURRIED_SCOPE : string := "(Util burried)";


-- ============================================================================
-- Initialisation and license
-- ============================================================================

--   -- Executed a single time ONLY
--   procedure pot_show_license(
--     constant dummy  : in t_void
--     ) is
--   begin
--     if not shared_license_shown then
--       show_license(v_trial_license);
--       shared_license_shown := true;
--     end if;
--   end;

--   -- Executed a single time ONLY
--   procedure initialise_util(
--     constant dummy  : in t_void
--     ) is
--   begin
--     set_log_file_name(C_LOG_FILE_NAME);
--     set_alert_file_name(C_ALERT_FILE_NAME);
--     shared_license_shown.set(1);
--     shared_initialised_util.set(true);
--   end;

  procedure pot_initialise_util(
    constant dummy  : in t_void
    ) is
  begin
    if not shared_initialised_util then
      shared_initialised_util := true;
      if not shared_log_file_name_is_set then
        set_log_file_name(C_LOG_FILE_NAME, ID_NEVER);
      end if;
      if not shared_alert_file_name_is_set then
        set_alert_file_name(C_ALERT_FILE_NAME, ID_NEVER);
      end if;
      show_license(VOID);
    end if;
  end;



-- ============================================================================
-- File handling (that needs to use other utility methods)
-- ============================================================================
  procedure check_file_open_status(
    constant status      : in file_open_status;
    constant file_name   : in string
    ) is
  begin
    case status is
      when open_ok =>
        null;  --**** logmsg (if log is open for write)
      when status_error =>
        alert(tb_warning, "File: " & file_name & " is already open", "SCOPE_TBD");
      when name_error =>
        alert(tb_error, "Cannot create file: " & file_name, "SCOPE TBD");
      when mode_error =>
        alert(tb_error, "File: " & file_name & " exists, but cannot be opened in write mode", "SCOPE TBD");
    end case;
  end;

  procedure set_alert_file_name(
    constant file_name   : string    := C_ALERT_FILE_NAME;
    constant msg_id      : t_msg_id  := ID_UTIL_SETUP
    ) is
    variable v_file_open_status: file_open_status;
  begin
    if not shared_alert_file_name_is_set then
      shared_alert_file_name_is_set := true;
      file_close(ALERT_FILE);
      file_open(v_file_open_status, ALERT_FILE, file_name, write_mode);
      check_file_open_status(v_file_open_status, file_name);
      log(msg_id, "alert file name set: " & file_name);
    else
      warning("alert file name already set - or set too late");
    end if;
  end;

  procedure set_log_file_name(
    constant file_name   : in string := C_LOG_FILE_NAME;
    constant msg_id      : t_msg_id  := ID_UTIL_SETUP
    ) is
    variable v_file_open_status: file_open_status;
  begin
    if not shared_log_file_name_is_set then
      shared_log_file_name_is_set := true;
      file_close(LOG_FILE);
      file_open(v_file_open_status, LOG_FILE, file_name, write_mode);
      check_file_open_status(v_file_open_status, file_name);
      log(msg_id, "log file name set: " & file_name);
    else
      warning("log file name already set - or set too late");
    end if;
  end;


-- ============================================================================
-- Log-related
-- ============================================================================
  impure function align_log_time(
    value   : time
    ) return string is
    variable v_line                : line;
    variable v_value_width         : natural;
    variable v_result              : string(1 to 50); -- sufficient for any relevant time value
    variable v_result_width        : natural;
    variable v_delimeter_pos       : natural;
    variable v_time_number_width   : natural;
    variable v_time_width          : natural;
    variable v_num_initial_blanks  : integer;
    variable v_found_decimal_point : boolean;
  begin
    -- 1. Store normal write (to string) and note width
    write(v_line, value, LEFT, 0, C_LOG_TIME_BASE);  -- required as width is unknown
    v_value_width := v_line'length;
    v_result(1 to v_value_width) := v_line.all;
    deallocate(v_line);

    -- 2. Search for decimal point or space between number and unit
    v_found_decimal_point := true;  -- default
    v_delimeter_pos := find_leftmost('.', v_result(1 to v_value_width), 0);
    if v_delimeter_pos = 0 then  -- No decimal point found
      v_found_decimal_point := false;
      v_delimeter_pos := find_leftmost(' ', v_result(1 to v_value_width), 0);
    end if;

    -- Potentially alert if time stamp is truncated.
    if C_LOG_TIME_TRUNC_WARNING then
      if not shared_warned_time_stamp_trunc then
        if (C_LOG_TIME_DECIMALS < (v_value_width - 3 - v_delimeter_pos)) THEN
          alert(TB_WARNING, "Time stamp has been truncated to " & to_string(C_LOG_TIME_DECIMALS) &
              " decimal(s) in the next log message - settable in adaptations_pkg." &
              " (Actual time stamp has more decimals than displayed) " &
              "\nThis alert is shown once only.",
              C_BURRIED_SCOPE);
          shared_warned_time_stamp_trunc := true;
        end if;
      end if;
    end if;

    -- 3. Derive Time number (integer or real)
    if C_LOG_TIME_DECIMALS = 0 then
      v_time_number_width := v_delimeter_pos - 1;
      -- v_result as is
    else  -- i.e. a decimal value is required
      if v_found_decimal_point then
        v_result(v_value_width - 2 to v_result'right) := (others => '0'); -- Zero extend
      else  -- Shift right after integer part and add point
        v_result(v_delimeter_pos + 1 to v_result'right) := v_result(v_delimeter_pos to v_result'right - 1);
        v_result(v_delimeter_pos) := '.';
        v_result(v_value_width - 1 to v_result'right) := (others => '0'); -- Zero extend
      end if;
      v_time_number_width := v_delimeter_pos + C_LOG_TIME_DECIMALS;
    end if;

    -- 4. Add time unit for full time specification
    v_time_width := v_time_number_width + 3;
    if C_LOG_TIME_BASE = ns then
      v_result(v_time_number_width + 1 to v_time_width) := " ns";
    else
      v_result(v_time_number_width + 1 to v_time_width) := " ps";
    end if;

    -- 5. Prefix
    v_num_initial_blanks := maximum(0, (C_LOG_TIME_WIDTH - v_time_width));
    if v_num_initial_blanks > 0 then
      v_result(v_num_initial_blanks + 1 to v_result'right) := v_result(1 to v_result'right - v_num_initial_blanks);
      v_result(1 to v_num_initial_blanks) := fill_string(' ', v_num_initial_blanks);
      v_result_width := C_LOG_TIME_WIDTH;
    else
      -- v_result as is
      v_result_width := v_time_width;
    end if;
    return v_result(1 to v_result_width);
  end function align_log_time;

  -- Writes Line to a file without modifying the contents of the line
  -- Not yet available in VHDL
  procedure tee (
    file     file_handle  : text;
    variable my_line      : inout line
    ) is
    variable v_line : line;
  begin
    write (v_line, my_line.all & lf);
    writeline(file_handle, v_line);
  end procedure tee;



  procedure log(
    msg_id         : t_msg_id;
    msg            : string;
    scope          : string         := C_TB_SCOPE_DEFAULT;
    msg_id_panel   : t_msg_id_panel := shared_msg_id_panel -- compatible with old code
    ) is
    variable v_info              : line;
    variable v_info_final        : line;
    variable v_log_msg_id        : string(1 to C_LOG_MSG_ID_WIDTH);
    variable v_log_scope         : string(1 to C_LOG_SCOPE_WIDTH);
    variable v_log_pre_msg_width : natural;
  begin
    -- Check if message ID is enabled
    if (msg_id_panel(msg_id) = ENABLED) then
      pot_initialise_util(VOID);  -- Only executed the first time called

      -- Prepare strings for msg_id and scope
      v_log_msg_id := to_upper(justify(to_string(msg_id), C_LOG_MSG_ID_WIDTH, LEFT, TRUNCATE));
      if (scope = "") then
        v_log_scope  := justify("(non scoped)", C_LOG_SCOPE_WIDTH, LEFT, TRUNCATE);
      else
        v_log_scope  := justify(scope, C_LOG_SCOPE_WIDTH, LEFT, TRUNCATE);
      end if;

      -- Handle actual log info line
      -- First write all fields preceeding the actual message - in order to measure their width
      -- (Prefix is taken care of later)
      write(v_info,
          return_string_if_true(v_log_msg_id, global_show_log_id) &           -- Optional
          " " & align_log_time(now) & "  " &
          return_string_if_true(v_log_scope, global_show_log_scope) & " ");   -- Optional
      v_log_pre_msg_width := v_info'length;      -- Width of string preceeding the actual message
      -- Then add the message it self (after replacing \n with LF
      write(v_info, replace_backslash_n_with_lf(msg));

      -- Modify and align info-string if additional lines are required (after wrapping lines)
      wrap_lines(v_info, 1, v_log_pre_msg_width + 1, C_LOG_LINE_WIDTH-C_LOG_PREFIX_WIDTH);

      -- Handle potential log header by including info-lines inside the log header format.
      if (msg_id = ID_LOG_HDR) then
        write(v_info_final, LF & LF);
        -- also update the Log header string
        shared_log_hdr_for_waveview := justify(msg, C_LOG_HDR_FOR_WAVEVIEW_WIDTH, LEFT, TRUNCATE);
      end if;
      write(v_info_final, v_info.all);  -- include actual info
      deallocate(v_info);
      -- Handle rest of potential log header
      if (msg_id = ID_LOG_HDR) then
        write(v_info_final, LF & fill_string('-', (C_LOG_LINE_WIDTH - C_LOG_PREFIX_WIDTH)));
      end if;

      -- Add prefix to all lines
      prefix_lines(v_info_final);

      -- Write the info string to the target file
      tee(OUTPUT, v_info_final);            -- write to transcript, while keeping the line contents
      writeline(LOG_FILE, v_info_final);
    end if;
  end;

  procedure enable_log_msg(
    constant msg_id         : t_msg_id;
    variable msg_id_panel   : inout t_msg_id_panel;
    constant msg            : string := ""
    ) is
  begin
    case msg_id is
      when ID_NEVER =>
        null;  -- Shall not be possible to enable
        log(ID_LOG_MSG_CTRL, "enable_log_msg() ignored for " & to_string(msg_id) & ". " & msg, C_BURRIED_SCOPE);
      when ALL_MESSAGES =>
        for i in t_msg_id'left to t_msg_id'right loop
          msg_id_panel(i)        := ENABLED;
          msg_id_panel(ID_NEVER) := DISABLED;
        end loop;
        log(ID_LOG_MSG_CTRL, "Log messages enabled for " & to_string(msg_id) & ". " & msg, C_BURRIED_SCOPE);
      when others =>
        msg_id_panel(msg_id) := ENABLED;
        log(ID_LOG_MSG_CTRL, "Log messages enabled for " & to_string(msg_id) & ". " & msg, C_BURRIED_SCOPE);
    end case;
  end;

  procedure enable_log_msg(
    msg_id         : t_msg_id;
    msg            : string  := ""
    ) is
  begin
    enable_log_msg(msg_id, shared_msg_id_panel, msg);
  end;

  procedure disable_log_msg(
    constant msg_id         : t_msg_id;
    variable msg_id_panel   : inout t_msg_id_panel;
    constant msg            : string  := ""
    ) is
  begin
    case msg_id is
      when ALL_MESSAGES =>
        log(ID_LOG_MSG_CTRL, "Log messages disabled for " & to_string(msg_id) & ". " & msg, C_BURRIED_SCOPE);
        for i in t_msg_id'left to t_msg_id'right loop
          msg_id_panel(i) := DISABLED;
        end loop;
      when others =>
        msg_id_panel(msg_id) := DISABLED;
        log(ID_LOG_MSG_CTRL, "Log messages disabled for " & to_string(msg_id) & ". " & msg, C_BURRIED_SCOPE);
    end case;
  end;

  procedure disable_log_msg(
    msg_id         : t_msg_id;
    msg            : string  := ""
    ) is
  begin
    disable_log_msg(msg_id, shared_msg_id_panel, msg);
  end;

-- ============================================================================
-- Alert-related
-- ============================================================================
  procedure alert(
    constant alert_level : t_alert_level;  -- ***ET: Only sensible name?
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
    variable v_msg       : line; -- msg after pot. replacement of \n
    variable v_info      : line;
   begin
      pot_initialise_util(VOID);  -- Only executed the first time called

      write(v_msg, replace_backslash_n_with_lf(msg));

     -- 1. Increase relevant alert counter. Exit if ignore is set for this alert type.
     if get_alert_attention(alert_level) = IGNORE then
--       protected_alert_counters.increment(alert_level, IGNORE);
       increment_alert_counter(alert_level, IGNORE);
     else
       --protected_alert_counters.increment(alert_level, REGARD);
       increment_alert_counter(alert_level, REGARD);

       -- 2. Write first part of alert message
       --    Serious alerts need more attention - thus more space and lines
       if (alert_level > MANUAL_CHECK) then
         write(v_info, LF & fill_string('=', C_LOG_INFO_WIDTH) & LF & "***  " &
           to_upper(to_string(alert_level)) & " #" & to_string(get_alert_counter(alert_level)) & "  ***" & LF &
           justify( to_string(now, C_LOG_TIME_BASE), C_LOG_TIME_WIDTH, RIGHT) & "   " & scope & LF &
           wrap_lines(v_msg.all, C_LOG_TIME_WIDTH + 4, C_LOG_TIME_WIDTH + 4, C_LOG_INFO_WIDTH));
       else
         write(v_info, LF & "***  " & to_upper(to_string(alert_level)) & " #" &
           to_string(get_alert_counter(alert_level)) & "  ***" & LF &
           justify( to_string(now, C_LOG_TIME_BASE), C_LOG_TIME_WIDTH, RIGHT) & "   " & scope & LF &
           wrap_lines(v_msg.all, C_LOG_TIME_WIDTH + 4, C_LOG_TIME_WIDTH + 4, C_LOG_INFO_WIDTH));
       end if;

       --3. Write stop message if stop-limit is reached for number of this alert
       if (get_alert_stop_limit(alert_level) /= 0) and
          (get_alert_counter(alert_level) >= get_alert_stop_limit(alert_level)) then
         write(v_info, LF & LF & "Simulator has been paused as requested after " &
             to_string(get_alert_counter(alert_level)) & " " &
             to_string(alert_level) & LF);
         if (alert_level = MANUAL_CHECK) then
           write(v_info, "Carry out above check." & LF &
               "Then continue simulation from within simulator." & LF);
         else
           write(v_info, string'("*** To see the root cause of this alert, " &
               "step out the HDL calling stack in your simulator ***"));
         end if;
       end if;

       -- 4. Write last part of alert message
       if (alert_level > MANUAL_CHECK) then
         write(v_info, LF & fill_string('=', C_LOG_INFO_WIDTH) & LF & LF);
       else
         write(v_info, LF);
       end if;

       prefix_lines(v_info);
       tee(OUTPUT, v_info);
       tee(ALERT_FILE, v_info);
       writeline(LOG_FILE, v_info);

       --5. Stop simulation if stop-limit is reached for number of this alert
       if (get_alert_stop_limit(alert_level) /= 0) then
         if (get_alert_counter(alert_level) >= get_alert_stop_limit(alert_level)) then
           assert false
             report "This single Failure line has been provoked to stop the simulation. See alert-message above"
             severity failure;
         end if;
       end if;
     end if;
   end;

  -- Dedicated alert-procedures all alert levels (less verbose - as 2 rather than 3 parameters...)
  procedure note(
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
  begin
    alert(note, msg, scope);
  end;

  procedure tb_note(
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
  begin
    alert(tb_note, msg, scope);
  end;

  procedure warning(
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
  begin
    alert(warning, msg, scope);
  end;

  procedure tb_warning(
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
  begin
    alert(tb_warning, msg, scope);
  end;

  procedure manual_check(
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
  begin
    alert(manual_check, msg, scope);
  end;

  procedure error(
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
  begin
    alert(error, msg, scope);
  end;

  procedure tb_error(
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
  begin
    alert(tb_error, msg, scope);
  end;

  procedure failure(
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
  begin
    alert(failure, msg, scope);
  end;

  procedure tb_failure(
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT
    ) is
  begin
    alert(tb_failure, msg, scope);
  end;

  procedure increment_expected_alerts(
    constant alert_level  : t_alert_level;
    constant number       : natural := 1
  ) is
  begin
    increment_alert_counter(alert_level, EXPECT, number);
  end;

  -- Arguments: 
  -- - order = FINAL : print out Simulation Success/Fail
  procedure report_alert_counters(
    constant order  : in t_order
  ) is
  begin
    work.vhdl_version_layer_pkg.report_alert_counters(order);
    pot_initialise_util(VOID);  -- Only executed the first time called
  end;

  -- This version (with the t_void argument) is kept for backwards compatibility
  procedure report_alert_counters(
    constant dummy  : in t_void
  ) is
  begin
    work.vhdl_version_layer_pkg.report_alert_counters(FINAL); -- Default when calling this old method is order=FINAL
    pot_initialise_util(VOID);  -- Only executed the first time called
  end;

  procedure report_global_ctrl(
    constant dummy  : in t_void
  ) is
    constant prefix          : string := C_LOG_PREFIX & "     ";
    variable v_line          : line;
  begin
    pot_initialise_util(VOID);  -- Only executed the first time called
    write(v_line,
        LF &
        fill_string('-', (C_LOG_LINE_WIDTH - prefix'length)) & LF &
        "***  REPORT OF GLOBAL CTRL ***" & LF &
        fill_string('-', (C_LOG_LINE_WIDTH - prefix'length)) & LF &
        "                          IGNORE    STOP_LIMIT                      " & LF);
    for i in t_alert_level'left to t_alert_level'right loop
      write(v_line, "          " & to_upper(to_string(i, 13, LEFT)) & ": ");          -- Severity

      write(v_line, to_string(get_alert_attention(i),      7, RIGHT) & "    ");       -- column 1
      write(v_line, to_string(integer'(get_alert_stop_limit(i)), 6, RIGHT) & "    " & LF);  -- column 2
    end loop;
    write(v_line, fill_string('-', (C_LOG_LINE_WIDTH - prefix'length)) & LF);

    wrap_lines(v_line, 1, 1, C_LOG_LINE_WIDTH-prefix'length);
    prefix_lines(v_line, prefix);

    -- Write the info string to the target file
    tee(OUTPUT, v_line);
    writeline(LOG_FILE, v_line);

  end;

  procedure report_msg_id_panel(
    constant dummy  : in t_void
  ) is
    constant prefix          : string := C_LOG_PREFIX & "     ";
    variable v_line          : line;
  begin
      write(v_line,
          LF &
          fill_string('-', (C_LOG_LINE_WIDTH - prefix'length)) & LF &
          "***  REPORT OF MSG ID PANEL ***" & LF &
          fill_string('-', (C_LOG_LINE_WIDTH - prefix'length)) & LF &
          "          " & justify("ID", C_LOG_MSG_ID_WIDTH, LEFT) & "       Status" &  LF &
          "          " & fill_string('-', C_LOG_MSG_ID_WIDTH)    & "       ------" & LF);
      for i in t_msg_id'left to t_msg_id'right loop
        write(v_line, "          " & to_upper(to_string(i, C_LOG_MSG_ID_WIDTH+5, LEFT)) & ": ");  -- MSG_ID
        write(v_line,to_string(shared_msg_id_panel(i)) & "    " & LF); -- Enabled/disabled
      end loop;
      write(v_line, fill_string('-', (C_LOG_LINE_WIDTH - prefix'length)) & LF);

      wrap_lines(v_line, 1, 1, C_LOG_LINE_WIDTH-prefix'length);
      prefix_lines(v_line, prefix);

      -- Write the info string to the target file
      tee(OUTPUT, v_line);
      writeline(LOG_FILE, v_line);

  end;

  procedure set_alert_attention(
      alert_level : t_alert_level;
      attention   : t_attention
  ) is
  begin
    check_value(attention = IGNORE or attention = REGARD, TB_WARNING,
        "set_alert_attention only supported for IGNORE and REGARD", C_BURRIED_SCOPE, ID_NEVER);
    shared_alert_attention(alert_level) := attention;
  end;

  impure function get_alert_attention(
      alert_level : t_alert_level
  ) return t_attention is
  begin
    return shared_alert_attention(alert_level);
  end;

  procedure set_alert_stop_limit(
      alert_level : t_alert_level;
      value       : natural
  ) is
  begin
    shared_stop_limit(alert_level) := value;
  end;

  impure function get_alert_stop_limit(
      alert_level : t_alert_level
  ) return natural is
  begin
    return shared_stop_limit(alert_level);
  end;



-- ============================================================================
-- Non time consuming checks
-- ============================================================================

  -- NOTE: Index in range N downto 0, with -1 meaning not found
  function idx_leftmost_p1_in_p2(
    target              : std_logic;
    vector              : std_logic_vector
    --result_if_not_found : integer := -1   -- To indicate not found
    ) return integer is
    alias a_vector : std_logic_vector(vector'length - 1 downto 0) is vector;
    constant result_if_not_found : integer := -1;   -- To indicate not found
  begin
    bitvis_assert(vector'length > 0, ERROR, "idx_leftmost_p1_in_p2()", "String input is empty");
    for i in a_vector'left downto a_vector'right loop
      if (a_vector(i) = target) then
        return i;
      end if;
    end loop;
    return result_if_not_found;
  end;

  -- Matching if same width or only zeros in "extended width"
  function matching_widths(
    value1: std_logic_vector;
    value2: std_logic_vector
    ) return boolean is
    -- Normalize vectors to (N downto 0)
    alias    a_value1: std_logic_vector(value1'length - 1 downto 0) is value1;
    alias    a_value2: std_logic_vector(value2'length - 1 downto 0) is value2;

  begin
    if (a_value1'left >= maximum( idx_leftmost_p1_in_p2('1', a_value2), 0)) and
       (a_value2'left >= maximum( idx_leftmost_p1_in_p2('1', a_value1), 0)) then
      return true;
    else
      return false;
    end if;
  end;

  function matching_widths(
    value1: unsigned;
    value2: unsigned
    ) return boolean is
  begin
    return matching_widths(std_logic_vector(value1), std_logic_vector(value2));
  end;

  function matching_widths(
    value1: signed;
    value2: signed
    ) return boolean is
  begin
    return matching_widths(std_logic_vector(value1), std_logic_vector(value2));
  end;


  -- Compare values, but ignore any leading zero's at higher indexes than v_min_length-1.
  function matching_values(
    value1: std_logic_vector;
    value2: std_logic_vector
    ) return boolean is
    -- Normalize vectors to (N downto 0)
    alias    a_value1  : std_logic_vector(value1'length - 1 downto 0) is value1;
    alias    a_value2  : std_logic_vector(value2'length - 1 downto 0) is value2;
    variable v_min_length : natural := minimum(a_value1'length, a_value2'length);
    variable v_match      : boolean := true;  -- as default prior to checking
  begin
    if matching_widths(a_value1, a_value2) then
      if not std_match( a_value1(v_min_length-1 downto 0), a_value2(v_min_length-1 downto 0) ) then
          v_match := false;
      end if;
    else
      v_match := false;
    end if;
    return v_match;
  end;

  function matching_values(
    value1: unsigned;
    value2: unsigned
    ) return boolean is
  begin
    return matching_values(std_logic_vector(value1),std_logic_vector(value2));
  end;

  function matching_values(
    value1: signed;
    value2: signed
    ) return boolean is
  begin
    return matching_values(std_logic_vector(value1),std_logic_vector(value2));
  end;

  -- Function check_value,
  -- returning 'true' if OK
  impure function check_value(
    constant value     : boolean;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name : string := "check_value()"
    ) return boolean is
  begin
    if value then
      log(msg_id, name & " => OK, for boolean true. " & msg, scope, msg_id_panel);
    else
      alert(alert_level, name & " => Failed, for boolean false. " & msg, scope);
    end if;
    return value;
  end;

  impure function check_value(
    constant value       : std_logic;
    constant exp         : std_logic;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) return boolean is
    constant value_type  : string          := "std_logic";
    constant v_value_str : string := to_string(value);
    constant v_exp_str   : string := to_string(exp);
  begin
    if std_match(value, exp) then
      if value = exp then
        log(msg_id, name & " => OK, for " & value_type & " " & v_value_str & ". " & msg, scope, msg_id_panel);
      else
        log(msg_id, name & " => OK, for " & value_type & " " & v_value_str & " (exp: " & v_exp_str & "). " & msg, scope, msg_id_panel);
      end if;
      return true;
    else
      alert(alert_level, name & " => Failed, for " & value_type & " " & v_value_str & ". Expected " & v_exp_str & LF & msg, scope);
      return false;
    end if;
  end;

  impure function check_value(
    constant value       : std_logic_vector;
    constant exp         : std_logic_vector;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "slv"
    ) return boolean is
    -- Normalise vectors to (N downto 0)
    alias    a_value     : std_logic_vector(value'length - 1 downto 0) is value;
    alias    a_exp       : std_logic_vector(exp'length - 1 downto 0) is exp;
    constant v_value_str : string := to_string(a_value, radix, format);
    constant v_exp_str   : string := to_string(a_exp, radix, format);
    variable v_check_ok  : boolean := true;  -- as default prior to checking
  begin
    v_check_ok := matching_values(a_value, a_exp);

    if v_check_ok then
      if v_value_str = v_exp_str then
        log(msg_id, name & " => OK, for " & value_type & " x" & v_value_str & ". " & msg, scope, msg_id_panel);
      else
        -- H,L or - is present in v_exp_str
        log(msg_id, name & " => OK, for " & value_type & " x" & v_value_str & " (exp: x" & v_exp_str & "). " & msg,
            scope, msg_id_panel);
      end if;
    else
      alert(alert_level, name & " => Failed, for " & value_type & " x" & v_value_str & ". Expected x" & v_exp_str & LF & msg, scope);
    end if;

    return v_check_ok;
  end;

  impure function check_value(
    constant value       : unsigned;
    constant exp         : unsigned;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "unsigned"
    ) return boolean is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(std_logic_vector(value), std_logic_vector(exp), alert_level, msg, scope,
                              radix, format, msg_id, msg_id_panel, name, value_type);
    return v_check_ok;
  end;

  impure function check_value(
    constant value       : signed;
    constant exp         : signed;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "signed"
    ) return boolean is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(std_logic_vector(value), std_logic_vector(exp), alert_level, msg, scope,
                              radix, format, msg_id, msg_id_panel, name, value_type);
    return v_check_ok;
  end;

  impure function check_value(
    constant value       : integer;
    constant exp         : integer;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) return boolean is
    constant value_type  : string          := "int";
    constant v_value_str : string := to_string(value);
    constant v_exp_str   : string := to_string(exp);
  begin
    if value = exp then
      log(msg_id, name & " => OK, for " & value_type & " " & v_value_str & ". " & msg, scope, msg_id_panel);
      return true;
    else
      alert(alert_level, name & " => Failed, for " & value_type & " " & v_value_str & ". Expected " & v_exp_str & LF & msg, scope);
      return false;
    end if;
  end;

  impure function check_value(
    constant value       : time;
    constant exp         : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) return boolean is
    constant value_type  : string          := "time";
    constant v_value_str : string := to_string(value);
    constant v_exp_str   : string := to_string(exp);
  begin
    if value = exp then
        log(msg_id, name & " => OK, for " & value_type & " " & v_value_str & ". " & msg, scope, msg_id_panel);
        return true;
    else
      alert(alert_level, name & " => Failed, for " & value_type & " " & v_value_str & ". Expected " & v_exp_str & LF & msg, scope);
      return false;
    end if;
  end;

  impure function check_value(
    constant value       : string;
    constant exp         : string;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) return boolean is
    constant value_type  : string          := "string";
  begin
    if value = exp then
        log(msg_id, name & " => OK, for " & value_type & " " & value & ". " & msg, scope, msg_id_panel);
        return true;
    else
      alert(alert_level, name & " => Failed, for " & value_type & " " & value & ". Expected " & exp & LF & msg, scope);
      return false;
    end if;
  end;

  ----------------------------------------------------------------------
  -- Overloads for check_value functions,
  -- to allow for no return value
  ----------------------------------------------------------------------
  procedure check_value(
    constant value     : boolean;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
      ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(value, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;

  procedure check_value(
    constant value       : std_logic;
    constant exp         : std_logic;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(value, exp, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;

  procedure check_value(
    constant value       : std_logic_vector;
    constant exp         : std_logic_vector;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "slv"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(value, exp, alert_level, msg, scope, radix, format, msg_id, msg_id_panel, name, value_type);
  end;

  procedure check_value(
    constant value       : unsigned;
    constant exp         : unsigned;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "unsigned"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(value, exp, alert_level, msg, scope, radix, format, msg_id, msg_id_panel, name, value_type);
  end;

  procedure check_value(
    constant value       : signed;
    constant exp         : signed;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant radix       : t_radix         := HEX_BIN_IF_INVALID;
    constant format      : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()";
    constant value_type  : string          := "signed"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(value, exp, alert_level, msg, scope, radix, format, msg_id, msg_id_panel, name, value_type);
  end;

  procedure check_value(
    constant value       : integer;
    constant exp         : integer;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(value, exp, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;

  procedure check_value(
    constant value       : time;
    constant exp         : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(value, exp, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;

  procedure check_value(
    constant value       : string;
    constant exp         : string;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value()"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value(value, exp, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;

  ------------------------------------------------------------------------
  -- check_value_in_range
  ------------------------------------------------------------------------
  impure function check_value_in_range (
    constant value        : integer;
    constant min_value    : integer;
    constant max_value    : integer;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()";
    constant value_type   : string         := "integer"
    ) return boolean is
    constant v_value_str     : string   := to_string(value);
    constant v_min_value_str : string   := to_string(min_value);
    constant v_max_value_str : string   := to_string(max_value);
    variable v_check_ok      : boolean;
  begin
    -- Sanity check
    check_value(max_value >= min_value, TB_ERROR, scope,
      " => min_value (" & v_min_value_str & ") must be less than max_value("& v_max_value_str & ")" & LF & msg, ID_NEVER, msg_id_panel, name);

    if (value >= min_value and value <= max_value) then
        log(msg_id, name & " => OK, for " & value_type & " " & v_value_str & ". " & msg, scope, msg_id_panel);
        return true;
    else
      alert(alert_level, name & " => Failed, for " & value_type & " " & v_value_str & ". Expected between " & v_min_value_str & " and " & v_max_value_str & LF & msg, scope);
      return false;
    end if;
  end;

  impure function check_value_in_range (
    constant value        : unsigned;
    constant min_value    : unsigned;
    constant max_value    : unsigned;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()";
    constant value_type   : string         := "unsigned"
    ) return boolean is
  begin
    return check_value_in_range(to_integer(value), to_integer(min_value), to_integer(max_value), alert_level, msg, scope, msg_id, msg_id_panel, name, value_type);
  end;

  impure function check_value_in_range (
    constant value        : signed;
    constant min_value    : signed;
    constant max_value    : signed;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()";
    constant value_type   : string         := "signed"
    ) return boolean is
  begin
    return check_value_in_range(to_integer(value), to_integer(min_value), to_integer(max_value), alert_level, msg, scope, msg_id, msg_id_panel, name, value_type);
  end;

  impure function check_value_in_range (
    constant value        : time;
    constant min_value    : time;
    constant max_value    : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()"
    ) return boolean is
    constant value_type      : string   := "time";
    constant v_value_str     : string   := to_string(value);
    constant v_min_value_str : string   := to_string(min_value);
    constant v_max_value_str : string   := to_string(max_value);
    variable v_check_ok      : boolean;
  begin
    -- Sanity check
    check_value(max_value >= min_value, TB_ERROR, scope,
      " => min_value (" & v_min_value_str & ") must be less than max_value("& v_max_value_str & ")" & LF & msg, ID_NEVER, msg_id_panel, name);

    if (value >= min_value and value <= max_value) then
        log(msg_id, name & " => OK, for " & value_type & " " & v_value_str & ". " & msg, scope, msg_id_panel);
        return true;
    else
      alert(alert_level, name & " => Failed, for " & value_type & " " & v_value_str & ". Expected between " & v_min_value_str & " and " & v_max_value_str & LF & msg, scope);
      return false;
    end if;
  end;

  impure function check_value_in_range (
    constant value        : real;
    constant min_value    : real;
    constant max_value    : real;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel := shared_msg_id_panel;
    constant name         : string         := "check_value_in_range()"
    ) return boolean is
    constant value_type      : string   := "real";
    constant v_value_str     : string   := to_string(value);
    constant v_min_value_str : string   := to_string(min_value);
    constant v_max_value_str : string   := to_string(max_value);
    variable v_check_ok      : boolean;
  begin
    -- Sanity check
    check_value(max_value >= min_value, TB_ERROR,
      " => min_value (" & v_min_value_str & ") must be less than max_value("& v_max_value_str & ")" & LF & msg, scope,
      ID_NEVER, msg_id_panel, name);

    if (value >= min_value and value <= max_value) then
        log(msg_id, name & " => OK, for " & value_type & " " & v_value_str & ". " & msg, scope, msg_id_panel);
        return true;
    else
      alert(alert_level, name & " => Failed, for " & value_type & " " & v_value_str & ". Expected between " & v_min_value_str & " and " & v_max_value_str & LF & msg, scope);
      return false;
    end if;
  end;
  --------------------------------------------------------------------------------
  -- check_value_in_range procedures :
  -- Call the corresponding function and discard the return value
  --------------------------------------------------------------------------------
  procedure check_value_in_range (
    constant value       : integer;
    constant min_value   : integer;
    constant max_value   : integer;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value_in_range()"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value_in_range(value, min_value, max_value, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;
  procedure check_value_in_range (
    constant value       : unsigned;
    constant min_value   : unsigned;
    constant max_value   : unsigned;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value_in_range()"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value_in_range(value, min_value, max_value, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;
  procedure check_value_in_range (
    constant value       : signed;
    constant min_value   : signed;
    constant max_value   : signed;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value_in_range()"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value_in_range(value, min_value, max_value, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;

  procedure check_value_in_range (
    constant value       : time;
    constant min_value   : time;
    constant max_value   : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value_in_range()"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value_in_range(value, min_value, max_value, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;

  procedure check_value_in_range (
    constant value       : real;
    constant min_value   : real;
    constant max_value   : real;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_value_in_range()"
    ) is
    variable v_check_ok  : boolean;
  begin
    v_check_ok := check_value_in_range(value, min_value, max_value, alert_level, msg, scope, msg_id, msg_id_panel, name);
  end;

  --------------------------------------------------------------------------------
  -- check_stable
  --------------------------------------------------------------------------------
  procedure check_stable(
    signal   target      : boolean;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "boolean"
    ) is
    constant value_string       : string := to_string(target);
    constant last_value_string  : string := to_string(target'last_value);
    constant last_change        : time   := target'last_event;
    constant last_change_string : string := to_string(last_change, ns);
  begin
    if (last_change >= stable_req) then
      log(msg_id, name & " => OK. Stable at " & value_string & ". " & msg, scope, msg_id_panel);
    else
      alert(alert_level, name & " => Failed. Switched from " & last_value_string & " to " &
            value_string & " " & last_change_string & " ago. Expected stable for " & to_string(stable_req) & LF & msg, scope);
    end if;
  end;

  procedure check_stable(
    signal   target      : std_logic_vector;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "slv"
    ) is
    constant value_string       : string := 'x' & to_string(target, HEX);
    constant last_value_string  : string := 'x' & to_string(target'last_value, HEX);
    constant last_change        : time   := target'last_event;
    constant last_change_string : string := to_string(last_change, ns);
  begin
    if (last_change >= stable_req) then
      log(msg_id, name & " => OK. Stable at " & value_string & ". " & msg, scope, msg_id_panel);
    else
      alert(alert_level, name & " => Failed. Switched from " & last_value_string & " to " &
            value_string & " " & last_change_string & " ago. Expected stable for " & to_string(stable_req) & LF & msg, scope);
    end if;
  end;

  procedure check_stable(
    signal   target      : unsigned;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "unsigned"
    ) is
    constant value_string       : string := 'x' & to_string(target, HEX);
    constant last_value_string  : string := 'x' & to_string(target'last_value, HEX);
    constant last_change        : time   := target'last_event;
    constant last_change_string : string := to_string(last_change, ns);
  begin
    if (last_change >= stable_req) then
      log(msg_id, name & " => OK. Stable at " & value_string & ". " & msg, scope, msg_id_panel);
    else
      alert(alert_level, name & " => Failed. Switched from " & last_value_string & " to " &
            value_string & " " & last_change_string & " ago. Expected stable for " & to_string(stable_req) & LF & msg, scope);
    end if;
  end;

  procedure check_stable(
    signal   target      : signed;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "signed"
    ) is
    constant value_string       : string := 'x' & to_string(target, HEX);
    constant last_value_string  : string := 'x' & to_string(target'last_value, HEX);
    constant last_change        : time   := target'last_event;
    constant last_change_string : string := to_string(last_change, ns);
  begin
    if (last_change >= stable_req) then
      log(msg_id, name & " => OK. Stable at " & value_string & ". " & msg, scope, msg_id_panel);
    else
      alert(alert_level, name & " => Failed. Switched from " & last_value_string & " to " &
            value_string & " " & last_change_string & " ago. Expected stable for " & to_string(stable_req) & LF & msg, scope);
    end if;
  end;

  procedure check_stable(
    signal   target      : std_logic;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "std_logic"
    ) is
    constant value_string       : string := to_string(target);
    constant last_value_string  : string := to_string(target'last_value);
    constant last_change        : time   := target'last_event;
    constant last_change_string : string := to_string(last_change, ns);
  begin
    if (last_change >= stable_req) then
      log(msg_id, name & " => OK. Stable at " & value_string & ". " & msg, scope, msg_id_panel);
    else
      alert(alert_level, name & " => Failed. Switched from " & last_value_string & " to " &
            value_string & " " & last_change_string & " ago. Expected stable for " & to_string(stable_req) & LF & msg, scope);
    end if;
  end;

  procedure check_stable(
    signal   target      : integer;
    constant stable_req  : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel  := shared_msg_id_panel;
    constant name        : string          := "check_stable()";
    constant value_type  : string          := "integer"
    ) is
    constant value_string       : string := to_string(target);
    constant last_value_string  : string := to_string(target'last_value);
    constant last_change        : time   := target'last_event;
    constant last_change_string : string := to_string(last_change, ns);
  begin
    if (last_change >= stable_req) then
      log(msg_id, name & " => OK." & value_string & " stable at " & value_string & ". " & msg, scope, msg_id_panel);
    else
      alert(alert_level, name & " => Failed. Switched from " & last_value_string & " to " &
            value_string & " " & last_change_string & " ago. Expected stable for " & to_string(stable_req) & LF & msg, scope);
    end if;
  end;


  -- check_time_window is used to check if a given condition occurred between
  -- min_time and max_time
  -- Usage: wait for requested condition until max_time is reached, then call check_time_window().
  -- The input 'success' is needed to distinguish between the following cases:
  --      - the signal reached success condition at max_time,
  --      - max_time was reached with no success condition
  procedure check_time_window(
    constant success          : boolean; -- F.ex target'event, or target=exp
    constant elapsed_time     : time;
    constant min_time         : time;
    constant max_time         : time;
    constant alert_level      : t_alert_level;
    constant name             : string;
    constant msg              : string;
    constant scope            : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id           : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel     : t_msg_id_panel := shared_msg_id_panel
    ) is
  begin
    -- Sanity check
    check_value(max_time >= min_time, TB_ERROR, name & " => min_time must be less than max_time." & LF & msg, scope, ID_NEVER, msg_id_panel, name);

    if elapsed_time < min_time then
      alert(alert_level, name & " => Failed. Condition occurred too early, after " &
          to_string(elapsed_time, C_LOG_TIME_BASE) & ". " & msg, scope);
    elsif success then
      log(msg_id, name & " => OK. Condition occurred after " &
          to_string(elapsed_time, C_LOG_TIME_BASE) & ". " & msg, scope, msg_id_panel);
    else -- max_time reached with no success
      alert(alert_level, name & " => Failed. Timed out after " &
          to_string(max_time, C_LOG_TIME_BASE) & ". " & msg, scope);
    end if;
  end;

  ----------------------------------------------------------------------------
  -- Random functions
  ----------------------------------------------------------------------------
  -- Return a random std_logic_vector, using overload for the integer version of random()
  impure function random (
    constant length : integer
  )  return std_logic_vector is
    variable random_vec : std_logic_vector(length-1 downto 0);
  begin
    -- Iterate through each bit and randomly set to 0 or 1
    for i in 0 to length-1 loop
      random_vec(i downto i) := std_logic_vector(to_unsigned(random(0,1), 1));
    end loop;
    return random_vec;
  end;

  -- Return a random std_logic, using overload for the SLV version of random()
  impure function random (
    constant VOID : t_void
  ) return std_logic is
    variable v_random_bit : std_logic_vector(0 downto 0);
  begin
    -- randomly set bit to 0 or 1
    v_random_bit := random(1); 
    return v_random_bit(0);  
  end;

  -- Return a random integer between min_value and max_value
  -- Use global seeds
  impure function random (
    constant min_value : integer;
    constant max_value : integer
  ) return integer is
    variable v_rand_scaled : integer;
    variable v_seed1       : positive := shared_seed1;
    variable v_seed2       : positive := shared_seed2;
  begin
      random(min_value, max_value, v_seed1, v_seed2, v_rand_scaled);
      -- Write back seeds
      shared_seed1 := v_seed1;
      shared_seed2 := v_seed2;
    return v_rand_scaled;
  end;

  -- Return a random real between min_value and max_value
  -- Use global seeds
  impure function random (
    constant min_value : real;
    constant max_value : real
  ) return real is
    variable v_rand_scaled : real;
    variable v_seed1       : positive := shared_seed1;
    variable v_seed2       : positive := shared_seed2;
  begin
      random(min_value, max_value, v_seed1, v_seed2, v_rand_scaled);
      -- Write back seeds
      shared_seed1 := v_seed1;
      shared_seed2 := v_seed2;
    return v_rand_scaled;
  end;

  -- Return a random time between min time and max time, using overload for the integer version of random()
  impure function random (
    constant min_value : time;
    constant max_value : time
  ) return time is
  begin
     return random(min_value/1 ns, max_value/1 ns) * 1 ns;
  end;

  --
  -- Procedure versions of random(), where seeds can be specified
  --
  -- Set target to a random SLV, using overload for the integer version of random().
  procedure random (
    variable v_seed1       : inout positive;
    variable v_seed2       : inout positive;
    variable v_target      : inout std_logic_vector
  ) is
    variable v_length      : integer  := v_target'length;
  begin
    -- Iterate through each bit and randomly set to 0 or 1
    for i in 0 to v_length-1 loop
      v_target(i downto i) := std_logic_vector(to_unsigned(random(0,1),1));
    end loop;
  end;

  -- Set target to a random SL, using overload for the integer version of random().
  procedure random (
    variable v_seed1       : inout positive;
    variable v_seed2       : inout positive;
    variable v_target      : inout std_logic
  ) is
    variable v_random_slv      : std_logic_vector(0 downto 0); 
  begin
    v_random_slv := std_logic_vector(to_unsigned(random(0,1),1));
    v_target := v_random_slv(0); 
  end;


  -- Set target to a random integer between min_value and max_value
  procedure random (
    constant min_value : integer;
    constant max_value : integer;
    variable v_seed1   : inout positive;
    variable v_seed2   : inout positive;
    variable v_target  : inout integer
  ) is
    variable v_rand    : real;
  begin
      -- Random real-number value in range 0 to 1.0
      uniform(v_seed1, v_seed2, v_rand);
      -- Scale to a random integer between min_value and max_value
      v_target := min_value + integer(trunc(v_rand*real(1+max_value-min_value)));
  end;

  -- Set target to a random integer between min_value and max_value
  procedure random (
    constant min_value : real;
    constant max_value : real;
    variable v_seed1   : inout positive;
    variable v_seed2   : inout positive;
    variable v_target  : inout real
  ) is
    variable v_rand    : real;
  begin
      -- Random real-number value in range 0 to 1.0
      uniform(v_seed1, v_seed2, v_rand);

      -- Scale to a random integer between min_value and max_value
      v_target := min_value + v_rand*(max_value-min_value);
  end;

  -- Set target to a random integer between min_value and max_value
  procedure random (
    constant min_value : time;
    constant max_value : time;
    variable v_seed1   : inout positive;
    variable v_seed2   : inout positive;
    variable v_target  : inout time
  ) is
    variable v_rand        : real;
    variable v_rand_int    : integer;
  begin
      -- Random real-number value in range 0 to 1.0
      uniform(v_seed1, v_seed2, v_rand);
      -- Scale to a random integer between min_value and max_value
      v_rand_int := min_value/1 ns + integer(trunc(v_rand*real(1 + max_value/1 ns - min_value / 1 ns)));
      v_target   := v_rand_int * 1 ns; 
  end;


  -- Set global seeds
  procedure randomise (
    constant seed1 : positive;
    constant seed2 : positive
  ) is
  begin
      log(ID_UTIL_BURRIED, "Setting global seeds to " & to_string(seed1) & ", " & to_string(seed2), C_BURRIED_SCOPE);
      shared_seed1 := seed1;
      shared_seed2 := seed2;
  end;

-- ============================================================================
-- Time consuming checks
-- ============================================================================

  --------------------------------------------------------------------------------
  -- await_change
  -- A signal change is required, but may happen already after 1 delta if min_time = 0 ns
  --------------------------------------------------------------------------------
  procedure await_change(
    signal   target      : boolean;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel := shared_msg_id_panel;
    constant value_type  : string         := "boolean"
    ) is
    constant name           : string := "await_change(" & value_type & ", " &
                                        to_string(min_time, ns) & ", " &
                                        to_string(max_time, ns) & ")";
    constant start_time     : time   := now;
  begin
    wait on target for max_time;
    check_time_window(target'event, now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
  end;

  procedure await_change(
    signal   target      : std_logic;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel := shared_msg_id_panel;
    constant value_type  : string         := "std_logic"
    ) is
    constant name           : string := "await_change(" & value_type & ", " &
                                        to_string(min_time, ns) & ", " &
                                        to_string(max_time, ns) & ")";
    constant start_time     : time   := now;
  begin
    wait on target for max_time;
    check_time_window(target'event, now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
  end;

  procedure await_change(
    signal   target      : std_logic_vector;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel := shared_msg_id_panel;
    constant value_type  : string         := "slv"
    ) is
    constant name           : string := "await_change(" & value_type & ", " &
                                        to_string(min_time, ns) & ", " &
                                        to_string(max_time, ns) & ")";
    constant start_time     : time   := now;
  begin
    wait on target for max_time;
    check_time_window(target'event, now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
  end;

  procedure await_change(
    signal   target      : unsigned;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel := shared_msg_id_panel;
    constant value_type  : string         := "unsigned"
    ) is
    constant name           : string := "await_change(" & value_type & ", " &
                                        to_string(min_time, ns) & ", " &
                                        to_string(max_time, ns) & ")";
    constant start_time     : time   := now;
  begin
    -- Note that overloading by casting target to slv without creating a new signal doesn't work
    wait on target for max_time;
    check_time_window(target'event, now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
  end;

  procedure await_change(
    signal   target      : signed;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel := shared_msg_id_panel;
    constant value_type  : string         := "signed"
    ) is
    constant name           : string := "await_change(" & value_type & ", " &
                                        to_string(min_time, ns) & ", " &
                                        to_string(max_time, ns) & ")";
    constant start_time     : time   := now;
  begin
    wait on target for max_time;
    check_time_window(target'event, now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
  end;

  procedure await_change(
    signal   target      : integer;
    constant min_time    : time;
    constant max_time    : time;
    constant alert_level : t_alert_level;
    constant msg         : string;
    constant scope       : string         := C_TB_SCOPE_DEFAULT;
    constant msg_id      : t_msg_id       := ID_POS_ACK;
    constant msg_id_panel: t_msg_id_panel := shared_msg_id_panel;
    constant value_type  : string         := "integer"
    ) is
    constant name        : string := "await_change(" & value_type & ", " &
        to_string(min_time, ns) & ", " & to_string(max_time, ns) & ")";
    constant start_time  : time   := now;
  begin
    wait on target for max_time;
    check_time_window(target'event, now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
  end;

  --------------------------------------------------------------------------------
  -- await_value
  --------------------------------------------------------------------------------
  -- Potential improvements
  --  - Adding an option that the signal must last for more than one delta cycle
  --    or a specified time
  --  - Adding an "AS_IS" option that does not allow the signal to change to other values
  --    before it changes to the expected value
  --
  -- The input signal is allowed to change to other values before ending up on the expected value,
  -- as long as it changes to the expected value within the time window (min_time to max_time).

  -- Wait for target = expected or timeout after max_time.
  -- Then check if (and when) the value changed to the expected
  procedure await_value (
    signal   target       : boolean;
    constant exp          : boolean;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    ) is
    constant value_type   : string := "boolean";
    constant start_time   : time   := now;
    constant v_exp_str    : string := to_string(exp);
    constant name         : string := "await_value(" & value_type & " " & v_exp_str & ", " &
        to_string(min_time, ns) & ", " & to_string(max_time, ns) & ")";
  begin
    if (target /= exp) then
      wait until (target = exp) for max_time;
    end if;
    check_time_window((target = exp), now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
  end;

  procedure await_value (
    signal   target       : std_logic;
    constant exp          : std_logic;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    ) is
    constant value_type   : string := "std_logic";
    constant start_time   : time   := now;
    constant v_exp_str    : string := to_string(exp);
    constant name         : string := "await_value(" & value_type & " " & v_exp_str & ", " &
        to_string(min_time, ns) & ", " & to_string(max_time, ns) & ")";
  begin
    if (target /= exp) then
      wait until (target = exp) for max_time;
    end if;
    check_time_window((target = exp), now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
  end;

  procedure await_value (
    signal   target       : std_logic_vector;
    constant exp          : std_logic_vector;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant radix        : t_radix         := HEX_BIN_IF_INVALID;
    constant format       : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    ) is
    constant value_type   : string := "slv";
    constant start_time   : time   := now;
    constant v_exp_str    : string := to_string(exp, radix, format, INCL_RADIX);
    constant name         : string := "await_value(" & value_type & " " & v_exp_str & ", " &
        to_string(min_time, ns) & ", " & to_string(max_time, ns) & ")";
  begin
    if matching_widths(target, exp) then
      if not matching_values(target, exp) then
        wait until matching_values(target, exp) for max_time;
      end if;
      check_time_window(matching_values(target, exp), now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
    else
      alert(alert_level, name & " => Failed. Widths did not match. " & msg, scope);
    end if;
  end;

  procedure await_value (
    signal   target       : unsigned;
    constant exp          : unsigned;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant radix        : t_radix         := HEX_BIN_IF_INVALID;
    constant format       : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    ) is
    constant value_type   : string := "unsigned";
    constant start_time   : time   := now;
    constant v_exp_str    : string := to_string(exp, radix, format, INCL_RADIX);
    constant name         : string := "await_value(" & value_type & " " & v_exp_str & ", " &
        to_string(min_time, ns) & ", " & to_string(max_time, ns) & ")";
  begin
    if matching_widths(target, exp) then
      if not matching_values(target, exp) then
        wait until matching_values(target, exp) for max_time;
      end if;
      check_time_window(matching_values(target, exp), now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
    else
      alert(alert_level, name & " => Failed. Widths did not match. " & msg, scope);
    end if;
  end;

  procedure await_value (
    signal   target       : signed;
    constant exp          : signed;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant radix        : t_radix         := HEX_BIN_IF_INVALID;
    constant format       : t_format_zeros  := SKIP_LEADING_0;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    ) is
    constant value_type   : string          := "signed";
    constant start_time   : time   := now;
    constant v_exp_str    : string := to_string(exp, radix, format, INCL_RADIX);
    constant name         : string := "await_value(" & value_type & " " & v_exp_str & ", " &
        to_string(min_time, ns) & ", " & to_string(max_time, ns) & ")";
  begin
    if matching_widths(target, exp) then
      if not matching_values(target, exp) then
        wait until matching_values(target, exp) for max_time;
      end if;
      check_time_window(matching_values(target, exp), now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
    else
      alert(alert_level, name & " => Failed. Widths did not match. " & msg, scope);
    end if;
  end;

  procedure await_value (
    signal   target       : integer;
    constant exp          : integer;
    constant min_time     : time;
    constant max_time     : time;
    constant alert_level  : t_alert_level;
    constant msg          : string;
    constant scope        : string          := C_TB_SCOPE_DEFAULT;
    constant msg_id       : t_msg_id        := ID_POS_ACK;
    constant msg_id_panel : t_msg_id_panel  := shared_msg_id_panel
    ) is
    constant value_type   : string := "integer";
    constant start_time   : time   := now;
    constant v_exp_str    : string := to_string(exp);
    constant name         : string := "await_value(" & value_type & " " & v_exp_str & ", " &
        to_string(min_time, ns) & ", " & to_string(max_time, ns) & ")";
  begin
    if (target /= exp) then
      wait until (target = exp) for max_time;
    end if;
    check_time_window((target = exp), now-start_time, min_time, max_time, alert_level, name, msg, scope, msg_id, msg_id_panel);
  end;


end package body methods_pkg;

