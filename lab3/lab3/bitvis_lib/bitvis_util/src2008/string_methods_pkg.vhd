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
-- VHDL unit     : Bitvis Utility Library : string_methods_pkg
--
-- Description   : See library quick reference (under 'doc') and README-file(s)
------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;



use work.types_pkg.all;
use work.adaptations_pkg.all;

package string_methods_pkg is

  procedure bitvis_assert(
    val        : boolean;
    severeness : severity_level;
    name       : string;
    msg        : string
    );


  function justify(
    val       : string;
    width     : natural := 0;
    justified : side := RIGHT;
    format: t_format_string := AS_IS -- No defaults on 4 first param - to avoid ambiguity with std.textio
    ) return string;



  function find_leftmost(
    target              : character;
    vector              : string;
    result_if_not_found : natural := 1
    ) return natural;

  function find_leftmost_non_zero(
    vector              : string;
    result_if_not_found : natural := 1
    ) return natural;




  function return_string_if_true(
    val        : string;
    return_val : boolean
    ) return string;

  function to_upper(
    val  : in string
    ) return string;

  function fill_string(
    val       : character;
    width     : natural
    ) return string;

  function replace_backslash_n_with_lf(
    source : string
    ) return string;

  function wrap_lines(
    constant text_string     : string;
    constant alignment_pos1  : natural;  -- Line position of first aligned character in line 1
    constant alignment_pos2  : natural;  -- Line position of first aligned character in line 2, etc...
    constant line_width      : natural
    ) return string;

  procedure wrap_lines(
    variable text_lines      : inout line;
    constant alignment_pos1  : natural;  -- Line position prior to first aligned character (incl. Prefix)
    constant alignment_pos2  : natural;  --
    constant line_width      : natural
    );

  procedure prefix_lines(
    variable text_lines  : inout line;
    constant prefix      : string := C_LOG_PREFIX
    );

  function replace(
    val           : string;
    target_char   : character;
    exchange_char : character
    ) return string;


  --========================================================
  -- Handle missing overloads from 'standard_additions'
  --========================================================
  function to_string(
    val       : boolean;
    width     : natural;
    justified : side        := right;
    format: t_format_string := AS_IS
    ) return string;

  function to_string(
    val       : integer;
    width     : natural;
    justified : side            := right;
    format    : t_format_string := AS_IS
    ) return string;

  function to_string(
    val     : std_logic_vector;
    radix   : t_radix;
    format  : t_format_zeros := AS_IS;  -- | SKIP_LEADING_0
    prefix  : t_radix_prefix := EXCL_RADIX -- Insert radix prefix in string?
    ) return string;

  function to_string(
    val     : unsigned;
    radix   : t_radix;
    format  : t_format_zeros := AS_IS;  -- | SKIP_LEADING_0
    prefix  : t_radix_prefix := EXCL_RADIX -- Insert radix prefix in string?
    ) return string;

  function to_string(
    val     : signed;
    radix   : t_radix;
    format  : t_format_zeros := AS_IS;  -- | SKIP_LEADING_0
    prefix  : t_radix_prefix := EXCL_RADIX -- Insert radix prefix in string?
    ) return string;



  --========================================================
  -- Handle types defined at lower levels
  --========================================================
  function to_string(
    val       : t_alert_level;
    width     : natural := 0;
    justified : side    := right
    ) return string;

  function to_string(
    val       : t_msg_id;
    width     : natural := 0;
    justified : side    := right
    ) return string;

  function to_string(
      val : t_enabled
      ) return string;

  function to_string(
    val       : t_attention;
    width     : natural := 0;
    justified : side    := right
      ) return string;

  procedure to_string(
    val   : t_alert_attention_counters; 
    order : t_order := FINAL
    );

end package string_methods_pkg;




package body string_methods_pkg is


  -- Need a low level "alert" in the form of a simple assertion (as string handling may also fail)
  procedure bitvis_assert(
    val        : boolean;
    severeness : severity_level;
    name       : string;
    msg        : string
    ) is
  begin
    assert val
      report LF & C_LOG_PREFIX & " *** FAILURE *** caused by Bitvis Util > string handling > " & name & LF &
             C_LOG_PREFIX & " " & msg & LF
      severity FAILURE;  -- As it will otherwise fail on next statement.
   end;



  function to_upper(
    val  : string
    ) return string is
    variable v_result : string (val'range) := val;
    variable char     : character;
    begin
      for i in val'range loop
        -- NOTE: Illegal characters are allowed and will pass through (check Mentor's std_developers_kit)
        if ( v_result(i) >= 'a' and v_result(i) <= 'z') then
          v_result(i) := character'val( character'pos(v_result(i)) - character'pos('a') + character'pos('A') );
        end if;
      end loop;
      return v_result;
    end to_upper;

  function fill_string(
    val    : character;
    width  : natural
    ) return string is
    variable v_result : string (1 to maximum(1, width));
    begin
      if (width = 0) then
        return "";
      else
        for i in 1 to width loop
          v_result(i) := val;
        end loop;
      end if;
      return v_result;
    end fill_string;

  function justify(
    val       : string;
    width     : natural         := 0;
    justified : side            := RIGHT;
    format    : t_format_string := AS_IS -- No defaults on 4 first param - to avoid ambiguity with std.textio
    ) return string is
    constant val_length : natural  := val'length;
    variable result       : string(1 to width) := (others => ' ');
  begin
    -- return val if width is too small
    if val_length >= width then
      if (format = TRUNCATE) then
        return val(1 to width);
      else
        return val;
      end if;
    end if;
    if justified = left then
      result(1 to val_length) := val;
    elsif justified = right then
      result(width - val_length + 1 to width) := val;
    end if;
    return result;
  end function;



  function find_leftmost(
    target              : character;
    vector              : string;
    result_if_not_found : natural := 1
    ) return natural is
    alias a_vector : string(1 to vector'length) is vector;
  begin
    bitvis_assert(vector'length > 0, FAILURE, "find_leftmost()", "String input is empty");
    for i in a_vector'left to a_vector'right loop
      if (a_vector(i) = target) then
        return i;
      end if;
    end loop;
    return result_if_not_found;
  end;

  function find_leftmost_non_zero(
    vector              : string;
    result_if_not_found : natural := 1
    ) return natural is
    alias a_vector : string(1 to vector'length) is vector;
  begin
    bitvis_assert(vector'length > 0, FAILURE, "find_leftmost()", "String input is empty");
    for i in a_vector'left to a_vector'right loop
      if (a_vector(i) /= '0' and a_vector(i) /= ' ') then
        return i;
      end if;
    end loop;
    return result_if_not_found;
  end;

  function adjust_leading_0(
    val     : string;
    format  : t_format_zeros := SKIP_LEADING_0
    ) return string is
    alias    a_val      :  string(1 to val'length) is val;
    constant leftmost_non_zero : natural  := find_leftmost_non_zero(a_val, 1);
  begin
    if val'length <= 1 then
      return val;
    end if;
    if format = SKIP_LEADING_0 then
      return a_val(leftmost_non_zero to val'length);
    else
      return a_val;
    end if;
  end function;

  function return_string_if_true(
    val        : string;
    return_val : boolean
    ) return string is
  begin
    if return_val then
      return val;
    else
      return "";
    end if;
  end function;

  function replace_backslash_n_with_lf(
    source : string
    ) return string is
    variable v_source_idx : natural := 0;
    variable v_dest_idx   : natural := 0;
    variable v_dest       : string(1 to source'length);
  begin
    if source'length = 0 then
      return "";
    else
      if C_USE_BACKSLASH_N_AS_LF then
        loop
          v_source_idx := v_source_idx + 1;
          v_dest_idx   := v_dest_idx + 1;
          if (v_source_idx < source'length) then
            if (source(v_source_idx to v_source_idx +1) /= "\n") then
              v_dest(v_dest_idx) := source(v_source_idx);
            else
              v_dest(v_dest_idx) := LF;
              v_source_idx       := v_source_idx + 1;  -- Additional increment as two chars (\n) are consumed
              if (v_source_idx = source'length) then
                exit;
              end if;
            end if;
          else
            -- Final character in string
            v_dest(v_dest_idx) := source(v_source_idx);
            exit;
          end if;
        end loop;
      else
        v_dest     := source;
        v_dest_idx := source'length;
      end if;
      return v_dest(1 to v_dest_idx);
    end if;
  end;

  function wrap_lines(
    constant text_string     : string;
    constant alignment_pos1  : natural;  -- Line position of first aligned character in line 1
    constant alignment_pos2  : natural;  -- Line position of first aligned character in line 2
    constant line_width      : natural
    ) return string is
    variable v_text_lines   : line;
    variable v_result       : string(1 to 2 * text_string'length + alignment_pos1 + 100); -- Margin for aligns and LF insertions
    variable v_result_width : natural;
  begin
    write(v_text_lines, text_string);
    wrap_lines(v_text_lines, alignment_pos1, alignment_pos2, line_width);
    v_result_width := v_text_lines'length;
    bitvis_assert(v_result_width <= v_result'length, FAILURE, "wrap_lines()",
        " String is too long after wrapping. Increase v_result string size.");
    v_result(1 to v_result_width) := v_text_lines.all;
    deallocate(v_text_lines);
    return v_result(1 to v_result_width);
  end;


  procedure wrap_lines(
    variable text_lines      : inout line;
    constant alignment_pos1  : natural;  -- Line position of first aligned character in line 1
    constant alignment_pos2  : natural;  -- Line position of first aligned character in line 2
    constant line_width      : natural
    ) is
    variable v_string       : string(1 to text_lines'length)  := text_lines.all;
    variable v_string_width : natural := text_lines'length;
    variable v_line_no      : natural := 0;
    variable v_last_string_wrap    : natural := 0;
    variable v_min_string_wrap     : natural;
    variable v_max_string_wrap     : natural;
  begin
    deallocate(text_lines); -- empty the line prior to filling it up again
    l_line: loop  -- For every tekstline found in text_lines
      v_line_no    := v_line_no + 1;
      -- Find position to wrap in v_string
      if (v_line_no = 1) then
        v_min_string_wrap := 1;                -- Minimum 1 character of input line
        v_max_string_wrap := minimum(line_width - alignment_pos1 + 1, v_string_width);
        write(text_lines, fill_string(' ', alignment_pos1 - 1));
      else
        v_min_string_wrap := v_last_string_wrap + 1;   -- Minimum 1 character further into the inpit line
        v_max_string_wrap := minimum(v_last_string_wrap + (line_width - alignment_pos2 + 1), v_string_width);
        write(text_lines, fill_string(' ', alignment_pos2 - 1));
      end if;

      -- 1. First handle any potential explicit line feed in the current maximum text line
      -- Search forward for potential LF
      for i in (v_last_string_wrap + 1) to minimum(v_max_string_wrap + 1, v_string_width) loop
        if (character(v_string(i)) = LF) then
          write(text_lines, v_string((v_last_string_wrap + 1) to i));  -- LF now terminates this part
          v_last_string_wrap := i;
          next l_line;  -- next line
        end if;
      end loop;

      -- 2. Then check if remaining text fits into a single text line
      if (v_string_width <= v_max_string_wrap) then
        -- No (more) wrapping required
        write(text_lines, v_string((v_last_string_wrap + 1) to v_string_width));
        exit;  -- No more lines
      end if;

      -- 3. Search for blanks from char after max msg width and downwards (in the left direction)
      for i in v_max_string_wrap + 1 downto (v_last_string_wrap + 1) loop
        if (character(v_string(i)) = ' ') then
          write(text_lines, v_string((v_last_string_wrap + 1) to i-1)); -- Exchange last blank with LF
          v_last_string_wrap := i;
          if (i = v_string_width ) then
            exit l_line;
          end if;
          -- Skip any potential extra blanks in the string
          for j in (i+1) to v_string_width loop
            if (v_string(j) = ' ') then
              v_last_string_wrap := j;
              if (j = v_string_width ) then
                exit l_line;
              end if;
            else
              write(text_lines, LF); -- Exchange last blanks with LF, provided not at the end of the string
              exit;
            end if;
          end loop;
          next l_line;  -- next line
        end if;
      end loop;

      -- 4. At this point no LF or blank is found in the searched section of the string.
      --    Hence just break the string - and continue.
      write(text_lines, v_string((v_last_string_wrap + 1) to v_max_string_wrap) & LF); -- Added LF termination
      v_last_string_wrap := v_max_string_wrap;
    end loop;
  end;

  procedure prefix_lines(
    variable text_lines   : inout line;
    constant prefix       : string := C_LOG_PREFIX
    ) is
    variable v_string           : string(1 to text_lines'length)  := text_lines.all;
    variable v_string_width     : natural := text_lines'length;
    constant prefix_width       : natural := prefix'length;
    variable v_last_string_wrap : natural := 0;
    variable i                  : natural := 0; -- for indexing v_string
  begin
    deallocate(text_lines); -- empty the line prior to filling it up again
    l_line : loop
      -- 1. Write prefix
      write(text_lines, prefix);
      -- 2. Write rest of text line (or rest of input line if no LF)
      l_char: loop
        i := i + 1;
        if (i < v_string_width) then
          if (character(v_string(i)) = LF) then
            write(text_lines, v_string((v_last_string_wrap + 1) to i));
            v_last_string_wrap := i;
            exit l_char;
          end if;
        else
          -- 3. Reached end of string. Hence just write the rest.
          write(text_lines, v_string((v_last_string_wrap + 1) to v_string_width));
          --    But ensure new line with prefix if ending with LF
          if (v_string(i) = LF) then
            write(text_lines, prefix);
          end if;
          exit l_char;
        end if;
      end loop;
      if (i = v_string_width) then
        exit;
      end if;
    end loop;
  end;

  function replace(
    val           : string;
    target_char   : character;
    exchange_char : character
    ) return string is
    variable result : string(1 to val'length) := val;
  begin
    for i in val'range loop
      if val(i) = target_char then
        result(i) := exchange_char;
      end if;
    end loop;
    return result;
  end;




  --========================================================
  -- Handle missing overloads from 'standard_additions' + advanced overloads
  --========================================================
  function to_string(
    val       : boolean;
    width     : natural;
    justified : side            := right;
    format    : t_format_string := AS_IS
    ) return string is
  begin
    return justify(to_string(val), width, justified, format);
  end;

  function to_string(
    val       : integer;
    width     : natural;
    justified : side            := right;
    format    : t_format_string := AS_IS
    ) return string is
  begin
    return justify(to_string(val), width, justified, format);
  end;

  function to_string(
    val     : std_logic_vector;
    radix   : t_radix;
    format  : t_format_zeros := AS_IS;  -- | SKIP_LEADING_0
    prefix  : t_radix_prefix := EXCL_RADIX -- Insert radix prefix in string?
    ) return string is
    variable v_line         : line;
    alias    a_val          : std_logic_vector(val'length - 1 downto 0) is val;
    variable v_result       : string(1 to 5 + 2 * val'length); --
    variable v_width        : natural;
    variable v_use_end_char : boolean := false;
  begin

    if radix = BIN then
      if prefix = INCL_RADIX then
        write(v_line, string'("b"""));
        v_use_end_char := true;
      end if;
      write(v_line, adjust_leading_0(to_string(val), format));
    elsif radix = HEX then
      if prefix = INCL_RADIX then
        write(v_line, string'("x"""));
        v_use_end_char := true;
      end if;
      write(v_line, adjust_leading_0(to_hstring(val), format));
    elsif radix = DEC then
      if prefix = INCL_RADIX then
        write(v_line, string'("d"""));
        v_use_end_char := true;
      end if;
      -- Assuming that val is not signed
      if (val'length > 31) then
        write(v_line, to_hstring(val) & " (too wide to be converted to integer)" );
      else
        write(v_line, adjust_leading_0(to_string(to_integer(unsigned(val))), format));
      end if;
    elsif radix = HEX_BIN_IF_INVALID then
      if prefix = INCL_RADIX then
        write(v_line, string'("x"""));
      end if;
      if is_x(val) then
        write(v_line, adjust_leading_0(to_hstring(val), format));
        if prefix = INCL_RADIX then
          write(v_line, string'(""""));  -- terminate hex value
        end if;
        write(v_line, string'(" (b"""));
        write(v_line, adjust_leading_0(to_string(val), format));
        write(v_line, string'(""""));
        write(v_line, string'(")"));
      else
        write(v_line, adjust_leading_0(to_hstring(val), format));
        if prefix = INCL_RADIX then
          write(v_line, string'(""""));
        end if;
      end if;
    end if;
    if  v_use_end_char then
      write(v_line, string'(""""));
    end if;

    v_width := v_line'length;
    v_result(1 to v_width) := v_line.all;
    deallocate(v_line);
    return v_result(1 to v_width);
  end;

  function to_string(
    val     : unsigned;
    radix   : t_radix;
    format  : t_format_zeros := AS_IS;  -- | SKIP_LEADING_0
    prefix  : t_radix_prefix := EXCL_RADIX -- Insert radix prefix in string?
    ) return string is
  begin
    return to_string(std_logic_vector(val), radix, format, prefix);
  end;

  function to_string(
    val     : signed;
    radix   : t_radix;
    format  : t_format_zeros := AS_IS;  -- | SKIP_LEADING_0
    prefix  : t_radix_prefix := EXCL_RADIX -- Insert radix prefix in string?
    ) return string is
  begin
    return to_string(std_logic_vector(val), radix, format, prefix);
  end;

  --========================================================
  -- Handle types defined at lower levels
  --========================================================

  function to_string(
    val       : t_alert_level;
    width     : natural := 0;
    justified : side    := right
    ) return string is
    constant inner_string : string  := t_alert_level'image(val);
  begin
    return to_upper(justify(inner_string, width, justified));
  end function;

  function to_string(
    val       : t_msg_id;
    width     : natural := 0;
    justified : side    := right
  ) return string is
  constant inner_string : string  := t_msg_id'image(val);
  begin
    return to_upper(justify(inner_string, width, justified));
  end function;

  function to_string(
      val : t_enabled
      ) return string is
    begin
      return to_upper(t_enabled'image(val));
    end;

  function to_string(
    val       : t_attention;
    width     : natural := 0;
    justified : side    := right
      ) return string is
    begin
      return to_upper(justify(t_attention'image(val), width, justified));
    end;


  procedure to_string(
    val   : t_alert_attention_counters; 
    order : t_order := FINAL
    ) is
    variable v_line          : line;
    variable v_line_copy     : line;
    variable v_all_ok        : boolean := true;
    variable v_header        : string(1 to 42); 
    constant prefix          : string := C_LOG_PREFIX & "     ";
  begin
    if order = INTERMEDIATE then 
      v_header := "*** INTERMEDIATE SUMMARY OF ALL ALERTS ***";
    else -- order=FINAL
      v_header := "*** FINAL SUMMARY OF ALL ALERTS  ***      "; 
    end if; 

    write(v_line,
        LF &
        fill_string('=', (C_LOG_LINE_WIDTH - prefix'length)) & LF &
        v_header & LF &
        fill_string('=', (C_LOG_LINE_WIDTH - prefix'length)) & LF &
        "                          REGARDED   EXPECTED  IGNORED      Comment?" & LF);
    for i in t_alert_level'left to t_alert_level'right loop
      write(v_line, "          " & to_upper(to_string(i, 13, LEFT)) & ": ");  -- Severity
      for j in t_attention'left to t_attention'right loop
        write(v_line, to_string(integer'(val(i)(j)), 6, RIGHT) & "    ");
      end loop;
      if (val(i)(REGARD) = val(i)(EXPECT)) then
        write(v_line, "     ok      " & LF);
      else
        write(v_line, "     *** " & to_string(i,0) & " *** " & LF);
        if (i > MANUAL_CHECK) then
          v_all_ok  := false;
        end if;
      end if;
    end loop;
    write(v_line, fill_string('=', (C_LOG_LINE_WIDTH - prefix'length)) & LF);
    -- Print a conclusion when called from the FINAL part of the test sequncer
    -- but not when called from in the middle of the test sequence (order=INTERMEDIATE) 
    if order = FINAL then 
      if v_all_ok then
          write(v_line, ">> Simulation SUCCESS: No mismatch between counted and expected serious alerts" & LF);
      else
        write(v_line, ">> Simulation FAILED, with unexpected serious alert(s)" & LF);
      end if;
      write(v_line, fill_string('=', (C_LOG_LINE_WIDTH - prefix'length)) & LF & LF);
    end if; 

    wrap_lines(v_line, 1, 1, C_LOG_LINE_WIDTH-prefix'length);
    prefix_lines(v_line, prefix);

    -- Write the info string to the target file
    write (v_line_copy, v_line.all & lf);  -- copy line
    writeline(OUTPUT, v_line);
    writeline(LOG_FILE, v_line_copy);
  end;




end package body string_methods_pkg;
