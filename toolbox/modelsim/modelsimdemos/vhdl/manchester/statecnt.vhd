---------------------------------------------------
--  Top Level: Manchester Receiver (manchester.vhd)
--  This Level: State Counter (statecnt.vhd)
--  Dependency: none
--
--  Controller for Manchester Receiver
--  
--  Input Ports
--   adj(2) <- Phase Adjustment (from decode)
--   clk    <- Sample Clock (approx 16x Data Clock)
--   reset  <- Reset to initial state
--   
--  Output Ports
--   sync   -> clk enable indicating decoded data value
--              This will occur approximately every 16 sample clocks
--   i_wf   ->    
--   q_wf   ->
--
--  Copyright 2002-2003 The MathWorks, Inc.
--  $Revision: 1.4.4.1 $  $Date: 2004/04/08 20:55:10 $
---------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY statecnt IS
PORT (

  clk    : IN std_logic ;    -- Clock (Sample Clock) (rising edge)
  enable : IN std_logic ;    -- Sync Clock Enable (active high)
  reset  : IN std_logic ;    -- Sync Reset(active high)
  		
  adj    : IN std_logic_vector (1 downto 0);  -- Data Rate adjust "00","01" or "10"
		
  sync   : OUT std_logic;   -- Data clock (approx freq(sclk)/16)

  i_wf : OUT std_logic;   -- Inphase Decoding Waveform (to iqconv)
  q_wf : OUT std_logic );   -- Quadrature Decoding Waveform (to iqconv)
END statecnt ;

---------------------------------------
ARCHITECTURE behavioral OF statecnt IS
TYPE state_type IS (LEAD_START,  -- Extra cycle (17) if lead detected
                    NORMAL_START, -- Normal 
                    LAG_START,
                    STATE_3,STATE_4,
                    STATE_5,STATE_6,STATE_7,STATE_8,
                    STATE_9,STATE_A,STATE_B,STATE_C,
                    STATE_D,STATE_E,STATE_F,
                    DECODE_ME);  -- Last cycle
  SIGNAL state, next_state : state_type ;                    
BEGIN

-- State register Update
seq: PROCESS(clk)
  BEGIN
  IF (rising_edge(clk)) THEN
    IF reset = '1' THEN
      state <= NORMAL_START AFTER 1 ns;
    ELSIF enable = '1' THEN
      state <= next_state AFTER 1 ns;
    END IF;
  END IF;
  END PROCESS seq;
  
-- Next State and Ouput Logic
com: PROCESS(state,adj)
  BEGIN 
  CASE state IS
    WHEN LEAD_START   => next_state <= NORMAL_START AFTER 1 ns;
    WHEN NORMAL_START => next_state <= LAG_START AFTER 1 ns;
    WHEN LAG_START    => next_state <= STATE_3 AFTER 1 ns;    
    WHEN STATE_3      => next_state <= STATE_4 AFTER 1 ns;
    WHEN STATE_4      => next_state <= STATE_5 AFTER 1 ns;
        
    WHEN STATE_5      => next_state <= STATE_6 AFTER 1 ns;
    WHEN STATE_6      => next_state <= STATE_7 AFTER 1 ns;
    WHEN STATE_7      => next_state <= STATE_8 AFTER 1 ns;
    WHEN STATE_8      => next_state <= STATE_9 AFTER 1 ns;
    
    WHEN STATE_9      => next_state <= STATE_A AFTER 1 ns;
    WHEN STATE_A      => next_state <= STATE_B AFTER 1 ns;
    WHEN STATE_B      => next_state <= STATE_C AFTER 1 ns;
    WHEN STATE_C      => next_state <= STATE_D AFTER 1 ns;
    
    WHEN STATE_D      => next_state <= STATE_E AFTER 1 ns;
    WHEN STATE_E      => next_state <= STATE_F AFTER 1 ns;
    WHEN STATE_F      => next_state <= DECODE_ME AFTER 1 ns;
    WHEN DECODE_ME    =>
      IF adj = "00" THEN
        next_state <= NORMAL_START AFTER 1 ns;
      ELSIF adj = "01" THEN
        next_state <= LAG_START AFTER 1 ns;
      ELSE
        next_state <= LEAD_START AFTER 1 ns;
      END IF;
    WHEN OTHERS => next_state <= NORMAL_START AFTER 1 ns;
  END CASE;
  
  CASE state IS 
    WHEN LEAD_START => 
      i_wf <= '0' AFTER 1 ns;
      q_wf <= '1' AFTER 1 ns;
      sync <= '0' AFTER 1 ns;
    WHEN NORMAL_START | LAG_START | STATE_3 | STATE_4 =>
      i_wf <= '1' AFTER 1 ns;
      q_wf <= '1' AFTER 1 ns;
      sync <= '0' AFTER 1 ns;
    WHEN STATE_5 | STATE_6 | STATE_7 | STATE_8  =>
      i_wf <= '1' AFTER 1 ns;
      q_wf <= '0' AFTER 1 ns;
      sync <= '0' AFTER 1 ns;
    WHEN STATE_9 | STATE_A | STATE_B | STATE_C  =>
      i_wf <= '0' AFTER 1 ns;
      q_wf <= '0' AFTER 1 ns;
      sync <= '0' AFTER 1 ns;
    WHEN STATE_D | STATE_E | STATE_F => 
      i_wf <= '0' AFTER 1 ns;
      q_wf <= '1' AFTER 1 ns;
      sync <= '0' AFTER 1 ns;
    WHEN DECODE_ME =>
      i_wf <= '0' AFTER 1 ns;
      q_wf <= '1' AFTER 1 ns;
      sync <= '1' AFTER 1 ns;
    WHEN OTHERS =>
      i_wf <= '0' AFTER 1 ns;
      q_wf <= '1' AFTER 1 ns;
      sync <= '0' AFTER 1 ns;
  END CASE;

END PROCESS com;

END behavioral;




