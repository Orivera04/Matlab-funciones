----------------------------------------------------------------
-- Module: simple_osc
-- This module produces a low-quality sine wave output as a
-- fixed-point number with 22 total bits and 20 fractional bits
-- at a frequency of 70/256 or 0.2734375 times the sample rate.
-- For the given sample rate of 80 ns or 12.5 MHz in the test
-- bench, the output frequency is approximately 3.4 MHz.
--
-- This low-quality sine wave is then digitally filtered by 
-- oversampling filters implemented in MATLAB.
--
--  Copyright 2003 The MathWorks, Inc.
--  $Revision $  $Date: 2003/11/03 19:32:18 $
----------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

ENTITY simple_osc IS
   PORT( clk                             :   IN    std_logic;
         clk_enable                      :   IN    std_logic;
         reset                           :   IN    std_logic;
         Out1                            :   OUT   std_logic_vector(21 DOWNTO 0)
         );

END simple_osc;

ARCHITECTURE rtl OF simple_osc IS
  -- Constants
  CONSTANT Gain1_const                    : signed(21 DOWNTO 0) := to_signed(1369803, 22); 
  CONSTANT Gain2_const                    : signed(21 DOWNTO 0) := to_signed(-1048576, 22); 
  -- Signals
  SIGNAL Gain1                            : signed(21 DOWNTO 0); 
  SIGNAL Gain2                            : signed(21 DOWNTO 0); 
  SIGNAL Sum1                             : signed(21 DOWNTO 0); 
  SIGNAL Unit_Delay1                      : signed(21 DOWNTO 0); 
  SIGNAL Unit_Delay2                      : signed(21 DOWNTO 0); 
  SIGNAL mul_temp_1                       : signed(43 DOWNTO 0); -- 44 bits
  SIGNAL mul_temp_2                       : signed(43 DOWNTO 0); -- 44 bits
  SIGNAL add_temp_1                       : signed(22 DOWNTO 0); -- 23 bits


BEGIN
  -- Component Instances
  -- Body Statements

  mul_temp_1 <= Unit_Delay1 * Gain1_const;
  Gain1 <= mul_temp_1(41 DOWNTO 20);

  mul_temp_2 <= Unit_Delay2 * Gain2_const;
  Gain2 <= mul_temp_2(41 DOWNTO 20);

  add_temp_1 <= resize(Gain2, 23) + resize(Gain1, 23);
  Sum1 <= add_temp_1(21 DOWNTO 0);

  Unit_Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Unit_Delay1 <= to_signed(32768, 22);
      Unit_Delay2 <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN
      IF clk_enable = '1' THEN
        Unit_Delay1 <= Sum1;
        Unit_Delay2 <= Unit_Delay1;
      END IF;
    END IF; 
  END PROCESS Unit_Delay_process;

  ---- Output Port Assignment Statements
  Out1 <= std_logic_vector(Sum1);
END rtl;
