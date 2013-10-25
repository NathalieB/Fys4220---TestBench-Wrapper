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
-- VHDL unit     : Bitvis Utility Library : adaptations_pkg
--
-- Description   : See library quick reference (under 'doc') and README-file(s)
------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;


use work.types_pkg.all;

package adaptations_pkg is
  constant C_ALERT_FILE_NAME : string := "_Alert.txt";
  constant C_LOG_FILE_NAME   : string := "_Log.txt";

  -------------------------------------------------------------------------------
  -- Log format
  -------------------------------------------------------------------------------
  --Bitvis: [<ID>]  <time>  <Scope>        Msg
  --PPPPPPPPIIIIII TTTTTTTT  SSSSSSSSSSSSSS MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  constant C_LOG_PREFIX : string := "Bitvis: "; -- Note: ': ' is recommended as final characters

  constant C_LOG_PREFIX_WIDTH  : natural := C_LOG_PREFIX'length;
  constant C_LOG_MSG_ID_WIDTH  : natural := 16;
  constant C_LOG_TIME_WIDTH    : natural := 16; -- 3 chars used for unit eg. " ns"
  constant C_LOG_TIME_BASE     : time    := ns; -- Unit in which time is shown in log (ns | ps)
  constant C_LOG_TIME_DECIMALS : natural := 1; -- Decimals to show for given C_LOG_TIME_BASE
  constant C_LOG_SCOPE_WIDTH   : natural := 16;
  constant C_LOG_LINE_WIDTH    : natural := 130;
  constant C_LOG_INFO_WIDTH    : natural := C_LOG_LINE_WIDTH - C_LOG_PREFIX_WIDTH;

  constant C_LOG_HDR_FOR_WAVEVIEW_WIDTH : natural := 50; -- For string in waveview indicating last log header

  constant C_USE_BACKSLASH_N_AS_LF : boolean := true; -- If true interprets '\n' as Line feed

  constant C_TB_SCOPE_DEFAULT : string := "TB seq."; -- Default scope in test sequencer

  constant C_LOG_TIME_TRUNC_WARNING : boolean := true; -- Yields a single TB_WARNING if time stamp truncated. Otherwise none
  signal global_show_log_id         : boolean := true;
  signal global_show_log_scope      : boolean := true;

  -------------------------------------------------------------------------------
  -- Verbosity control
  -- NOTE: Do not enter new IDs without proper evaluation:
  --       1. Is it - or could it be covered by an existing ID
  --       2. Could it be combined with other needs for a more general new ID
  --       Feel free to suggest new ID for future versions of Bitvis Utility Library (info@bitvis.no)
  -------------------------------------------------------------------------------
  type t_msg_id is (
    -- Bitvis utility methods
    ID_UTIL_BURRIED,      -- Used for burried log messages where msg and scope cannot be modified from outside
    ID_UTIL_SETUP,        -- Used for Utility setup
    ID_LOG_MSG_CTRL,      -- Used inside Utility library only - when enabling/disabling msg IDs.
    ID_NEVER,             -- Used for avoiding log entry. Cannot be enabled.
    -- General
    ID_POS_ACK,           -- To write a positive acknowledge on a check
    -- Directly inside test sequencers
    ID_LOG_HDR,           -- ONLY allowed in test sequencer, Log section headers
    ID_SEQUENCER,         -- ONLY allowed in test sequencer, Normal log (not log headers)
    ID_SEQUENCER_SUB,     -- ONLY allowed in test sequencer, Subprograms defined in sequencer
    -- BFMs
    ID_BFM,               -- Used inside a BFM (to log BFM access)
    ID_BFM_WAIT,          -- Used inside a BFM to indicate that it is waiting for something (e.g. for ready)
    ID_PACKET_INITIATE,   -- Notify that a packet is about to be transmitted or received
    ID_PACKET_COMPLETE,   -- Notify that a packet has been transmitted or received
    ID_PACKET_HDR,        -- AS ID_PACKET_COMPLETED, but also writes header info
    ID_PACKET_DATA,       -- AS ID_PACKET_COMPLETED, but also writes packet data (could be huge)
    -- Distributed command systems
    ID_TLM,               -- Do not use. Intended for transaction level commands. May be changed
    ID_TLM_WAIT,          -- Do not use. Intended for transaction level commands. May be changed
    ID_EXECUTOR,          -- Used inside process/entity executing a distributed command
    ID_EXECUTOR_WAIT,     --
    -- VVC system
    ID_VVC_CONSTRUCTOR,   -- Constructor message from VVCs
    -- Special purpose - Not really IDs
    ALL_MESSAGES          -- Applies to ALL message ID apart from ID_NEVER
    );
  type  t_msg_id_panel is array (t_msg_id'left to t_msg_id'right) of t_enabled;

  constant C_DEFAULT_MSG_ID_PANEL : t_msg_id_panel := (
    ID_NEVER         => DISABLED,
    ID_UTIL_BURRIED  => DISABLED,
    others           => ENABLED
  );

  -------------------------------------------------------------------------
  -- Alert counters
  -------------------------------------------------------------------------
  -- Default values. These can be overwritten in each sequencer by using
  -- set_alert_attention or set_alert_stop_limit (see quick ref).
  constant C_DEFAULT_ALERT_ATTENTION : t_alert_attention := (others => REGARD);

  -- 0 = Never stop
  constant C_DEFAULT_STOP_LIMIT : t_alert_counters := (note to manual_check => 0,
                                                       others               => 1);

end package adaptations_pkg;

package body adaptations_pkg is
end package body adaptations_pkg;
