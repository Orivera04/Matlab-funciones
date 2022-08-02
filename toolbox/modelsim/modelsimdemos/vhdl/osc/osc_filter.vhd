----------------------------------------------------------------
-- Module: osc_filter
-- This module is wrapper for the matlab filter. This level has
-- just ports to connect to in MATLAB.  See osc_filter.m for
-- the details.
--
--  Copyright 2003 The MathWorks, Inc.
--  $Revision $  $Date: 2003/11/03 19:32:21 $
----------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

ENTITY osc_filter IS
   PORT( clk                             :   IN    std_logic;
         clk_enable                      :   IN    std_logic;
         reset                           :   IN    std_logic;
         osc_in                          :   IN    std_logic_vector(21 DOWNTO 0);
         osc_out                         :   OUT   std_logic_vector(21 DOWNTO 0);
         matlab1x_in                     :   IN    std_logic_vector(21 DOWNTO 0);
         matlab4x_in                     :   IN    std_logic_vector(21 DOWNTO 0);
         matlab8x_in                     :   IN    std_logic_vector(21 DOWNTO 0);
         filter1x_out                    :   OUT   std_logic_vector(21 DOWNTO 0);
         filter4x_out                    :   OUT   std_logic_vector(21 DOWNTO 0);
         filter8x_out                    :   OUT   std_logic_vector(21 DOWNTO 0)
         );
END osc_filter;

ARCHITECTURE matlab OF osc_filter IS

BEGIN 

  osc_out <= osc_in;

  filter1x_out <= matlab1x_in;
  filter4x_out <= matlab4x_in;
  filter8x_out <= matlab8x_in;

END matlab;
