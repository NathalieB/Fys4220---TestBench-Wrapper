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
-- VHDL unit     : Bitvis IRQC Library : irqc
--
-- Description   : See dedicated powerpoint presentation and README-file(s)
------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.irqc_pif_pkg.all;

entity irqc is
  port(
    -- DSP interface and general control signals
    clk                   : in  std_logic;
    arst                  : in  std_logic;
    -- CPU interface
    cs  : in  std_logic;
    addr: in  unsigned(2 downto 0);
    wr  : in  std_logic;
    rd  : in  std_logic;
    din : in  std_logic_vector(7 downto 0);
    dout: out std_logic_vector(7 downto 0) := (others => '0');
    -- Interrupt related signals
    irq_source            : in  std_logic_vector(C_NUM_SOURCES-1 downto 0);
    irq2cpu               : out std_logic;
    irq2cpu_ack           : in  std_logic
  );
end irqc;

architecture rtl of irqc is

  -- PIF-core interface
  signal p2c      :  t_p2c;                 --
  signal c2p      :  t_c2p;                 --


begin

  i_irqc_pif: entity work.irqc_pif
    port map (
        arst           => arst,           --
        clk            => clk,            --
    -- CPU interface
        cs             => cs,             --
        addr           => addr,           --
        wr             => wr,             --
        rd             => rd,             --
        din            => din,            --
        dout           => dout,           --
    --
        p2c            => p2c,            --
        c2p            => c2p             --
        );



  i_irqc_core: entity work.irqc_core
    port map (
        clk            => clk,            --
        arst           => arst,           --
    -- PIF-core interface
        p2c            => p2c,            --
        c2p            => c2p,            --
    -- Interrupt related signals
        irq_source     => irq_source,     --
        irq2cpu        => irq2cpu,        --
        irq2cpu_ack    => irq2cpu_ack    --
        );




end rtl;
