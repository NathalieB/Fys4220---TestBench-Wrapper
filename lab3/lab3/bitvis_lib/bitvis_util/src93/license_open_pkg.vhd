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
-- VHDL unit     : Bitvis Utility Library : license_pkg
--
-- Description   : See library quick reference (under 'doc') and README-file(s)
------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

use work.types_pkg.all;
use work.string_methods_pkg.all;

package license_pkg is
  procedure show_license(
    constant dummy  : in t_void
    );

end package license_pkg;

package body license_pkg is
  procedure show_license(
    constant dummy  : in t_void
    ) is
    constant C_VERSION            : string  := "v2.1.0";
    constant C_SEPARATOR          : string  :=
      "=====================================================================================================";

    constant C_LICENSE_STR        : string :=
      LF & LF & LF &
      C_SEPARATOR                                                                                             & LF &
      C_SEPARATOR                                                                                             & LF &
      " Bitvis Utility Library " & C_VERSION & " is being used by this simulation."                                             & LF &
      " This is a *** LICENSED PRODUCT *** as given in the copyright notice of the VHDL code."                & LF &
      " The free license granted is subject to the conditions given in the VHDL copyright notice."            & LF &
      " -------"                                                                                              & LF &
      " - Bitvis (Asker, Norway) helps customers develop FPGA, ASIC and Embedded SW  (www.bitvis.no)"         & LF &
      " - We provide services, verification IP and tools - and may also help as a sparring partner or mentor" & LF &
      " - We also offer a 2-day course 'FPGA development Best Practices', which has received great feedback"  & LF &
      C_SEPARATOR                                                                                             & LF &
      C_SEPARATOR                                                                                             & LF & LF;

    variable v_line : line;
  begin
    report (C_LICENSE_STR);
    write(v_line, C_LICENSE_STR);
    writeline(LOG_FILE, v_line);
  end;

end package body license_pkg;
