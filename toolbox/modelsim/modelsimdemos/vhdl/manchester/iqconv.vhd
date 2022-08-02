---------------------------------------------------
--  Top Level: Manchester Receiver (main.vhd)
--  This Level: IQ Convolution (iqconv.vhd)
--  Dependency: lfsr_reg13 (for test_bench)
--
--  Accepts raw data stream (samp) and convolves with I/Q 
--  pattern provided by "statecnt" entity.  The resulting
--  detected values are integrated into counters.  Use
--  reset to synchronously clear counters.
--
--  Copyright 2002-2003 The MathWorks, Inc.
--  $Revision: 1.4.4.1 $  $Date: 2004/04/08 20:55:08 $
---------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 

ENTITY iqconv IS
PORT (
  clk    : IN std_logic ;    -- Clock (Sample Clock) (rising edge)
  enable : IN std_logic ;    -- Sync Clock Enable (active high)
  reset  : IN std_logic ;    -- Sync Reset(active high)
		
  i_wf : IN std_logic ;   -- Inphase Decoding Waveform(from statecnt)
  q_wf : IN std_logic ; -- Quadrature Decoding Waveform(from statecnt)
  samp : IN std_logic ; -- raw sampled Manchester-encoded data

  isum : OUT std_logic_vector(4 downto 0) ; -- (max 17 with adjust)
  qsum : OUT std_logic_vector(4 downto 0)   -- (max 17 with adjust)
  );
END iqconv ;
---------------------------------------
ARCHITECTURE behavioral OF iqconv IS
SIGNAL  idect : std_logic;
SIGNAL  qdect : std_logic;
SIGNAL  icntv : std_logic_vector(4 downto 0);
SIGNAL  qcntv : std_logic_vector(4 downto 0); 
SIGNAL  isum_internal : std_logic_vector(4 downto 0);
SIGNAL  qsum_internal : std_logic_vector(4 downto 0);

BEGIN
-- 
idect <= samp XOR i_wf after 1 ns;  -- Detector!  
qdect <= samp XOR q_wf after 1 ns;

isum_internal <= icntv + idect;
qsum_internal <= qcntv + qdect;

-- synchronous process
iqc_proc : PROCESS (clk)

BEGIN
  IF rising_edge(clk) THEN
    IF (reset = '1') THEN            -- async active high reset
      icntv <= (others => '0');  -- reset state;
      qcntv <= (others => '0');  -- reset state;
    ELSIF enable = '1' THEN 
      icntv <= isum_internal;       -- change state
      qcntv <= qsum_internal;      -- change state      present_cnt <= next_cnt;       -- change state
    END IF;
  END IF;
 END PROCESS iqc_proc;

isum <= isum_internal after 1 ns;
qsum <= qsum_internal after 1 ns;

END behavioral;
