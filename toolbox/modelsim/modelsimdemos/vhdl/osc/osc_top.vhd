----------------------------------------------------------------
-- Module: osc_top
-- This module is the top level and instantiates the simple_osc
-- module to generate a sine wave plus the empty wrapper for the
-- MATLAB component that filters the sine wave with a high-quality
-- filter in MATLAB.
--
--
--  Copyright 2003 The MathWorks, Inc.
--  $Revision $  $Date: 2003/11/03 19:32:24 $
----------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

ENTITY osc_top IS
   PORT( clk                             :   IN    std_logic;
         clk_enable                      :   IN    std_logic;
         reset                           :   IN    std_logic;
         sine_out                        :   OUT   std_logic_vector(21 DOWNTO 0)
         );
END osc_top;

ARCHITECTURE rtl OF osc_top IS
  COMPONENT simple_osc
    PORT (
      clk        : IN  std_logic;
      clk_enable : IN  std_logic;
      reset      : IN  std_logic;
      Out1       : OUT std_logic_vector(21 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT osc_filter
    PORT (
      clk          : IN  std_logic;
      clk_enable   : IN  std_logic;
      reset        : IN  std_logic;
      osc_in       : IN  std_logic_vector(21 DOWNTO 0);
      osc_out      : OUT std_logic_vector(21 DOWNTO 0);
      matlab1x_in  : IN  std_logic_vector(21 DOWNTO 0);
      matlab4x_in  : IN  std_logic_vector(21 DOWNTO 0);
      matlab8x_in  : IN  std_logic_vector(21 DOWNTO 0);
      filter1x_out : OUT std_logic_vector(21 DOWNTO 0);
      filter4x_out : OUT std_logic_vector(21 DOWNTO 0);
      filter8x_out : OUT std_logic_vector(21 DOWNTO 0));
  END COMPONENT;

  FOR ALL : simple_osc
    USE ENTITY work.simple_osc(rtl);

  FOR ALL : osc_filter
    USE ENTITY work.osc_filter(matlab);

  SIGNAL osc_out               : std_logic_vector(21 DOWNTO 0);
  SIGNAL filter_osc_out        : std_logic_vector(21 DOWNTO 0);

  SIGNAL matlab1x_in           : std_logic_vector(21 DOWNTO 0);
  SIGNAL matlab4x_in           : std_logic_vector(21 DOWNTO 0);
  SIGNAL matlab8x_in           : std_logic_vector(21 DOWNTO 0);

  SIGNAL filter1x_out          : std_logic_vector(21 DOWNTO 0);
  SIGNAL filter4x_out          : std_logic_vector(21 DOWNTO 0);
  SIGNAL filter8x_out          : std_logic_vector(21 DOWNTO 0);

BEGIN
  u_simple_osc: simple_osc
    PORT MAP (
        clk        => clk,
        clk_enable => clk_enable,
        reset      => reset,
        Out1       => osc_out);

  u_osc_filter: osc_filter
    PORT MAP (
        clk          => clk,
        clk_enable   => clk_enable,
        reset        => reset,
        osc_in       => osc_out,
        osc_out      => filter_osc_out,
        matlab1x_in  => matlab1x_in,
        matlab4x_in  => matlab4x_in,        
        matlab8x_in  => matlab8x_in,
        filter1x_out => filter1x_out,
        filter4x_out => filter4x_out,
        filter8x_out => filter8x_out);

  sine_out <= filter8x_out;

END rtl;
