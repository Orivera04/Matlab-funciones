---------------------------------------------------
--  Top Level: Manchester Receiver (manchester.vhd)
--  This Level: Decoder (decode.vhd)
--  Dependency: none
--
--  Accepts convolved I/Q counts and produces the 
--  decoded data stream, validity, and adjustment
--  term to track drifts in the receive clock 
--- phase or frequency.  
--  
--  Simple combinatorial implementation
--  
--  Copyright 2002-2003 The MathWorks, Inc.
--  $Revision: 1.5.4.1 $  $Date: 2004/04/08 20:55:07 $
---------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY decoder IS
PORT (
  isum   : IN std_logic_vector(4 downto 0); -- Inphase measurement   (max 17 with period adjust)
  qsum   : IN std_logic_vector(4 downto 0); -- Quadrature measurement(max 17 with period adjust)
  
  adj    : OUT std_logic_vector (1 downto 0); -- Period adjustment direction, lead, lag or none
  dvalid : OUT std_logic;  -- Data validity, Set to '0' when phase error makes detection impossible
  odata  : OUT std_logic  -- Recovered data stream
  );
END decoder ;

ARCHITECTURE behavioral OF decoder IS

CONSTANT midpt :  std_logic_vector (4 downto 0) := "01000";  -- 8
  BEGIN 
  
  odata <= '1' WHEN isum < midpt ELSE
           '0' AFTER 1 ns;
           
  dvalid <= '0' WHEN isum = midpt ELSE
            '1'  AFTER 1 ns;
   
  adj <= "00" WHEN qsum = midpt AND isum /= midpt ELSE  -- In phase
         "01" WHEN (qsum < midpt AND isum < midpt) OR (qsum >= midpt AND isum >= midpt) ELSE  -- Lead +1 
         "11" AFTER 1 ns; -- Lag -1 
END behavioral;

