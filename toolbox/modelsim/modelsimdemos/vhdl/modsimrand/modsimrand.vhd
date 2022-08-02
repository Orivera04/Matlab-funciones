---------------------------------------------------
-- Psuedo Random Word Generator
-- Demonstration of 'Link for ModelSim'     
--
--
--
--  Modelsim
-- >vsimmatlab work.modsimrand
-- >matlabtb modsimrand -mfunc modsimrand_plot -rising /modsimrand/clk 
-- >force sim:/modsimrand/clk 0 0,1 5 ns -repeat 10 ns
-- >force sim:/modsimrand/clk_en 1
-- >force sim:/modsimrand/reset 1 0,0 50 ns
-- >run 80000
--
--  Copyright 2003 The MathWorks, Inc.
--  $Revision: 1.2 $  $Date: 2003/11/05 18:40:23 $
---------------------------------------------------

---------------------------------------------------
-- Entity: modsimrand
-- Pseudo random algorithm
-- Implements a uniform PN generator using 
-- a fibonacci sequence.  
---------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY modsimrand IS
PORT (
  clk    : IN std_logic ;
  clk_en : IN std_logic ;
  reset  : IN std_logic ;
  dout   : OUT std_logic_vector (31 downto 0) );
END modsimrand ;

ARCHITECTURE behavioral OF modsimrand IS
  TYPE    regfile_t IS ARRAY (NATURAL range <>) OF unsigned (31 downto 0); 
  SIGNAL  regfile : regfile_t(54 DOWNTO 0);
BEGIN
  --
  PROCESS(clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      IF clk_en = '1' THEN
    	IF reset = '1' THEN  -- Sync Reset
    	  regfile(54 DOWNTO 0) <= (OTHERS=>(OTHERS=>'1'));
    	ELSE
	  regfile(54 DOWNTO 1) <= regfile(53 DOWNTO 0);
	  regfile(0) <= regfile(54) + regfile(23);
    	END IF;
      END IF;
    END IF;

END PROCESS;
dout <= STD_LOGIC_VECTOR(regfile(0));

END behavioral;

-----------------------------------------------------
-- [EOF] modsimrand.vhd
