---------------------------------------------------
--  Top Level: Manchester Receiver (manchester.vhd)
--  This Level: manchester (manchester.vhd)
--  Dependency: iqconv.vhd, statecnt.vhd, decoder.vhd
--
--  Integrates the parts of the Manchester receiver into
--  a functional Manchester receiver.  Also syncs the 
--  recovered stream data (for a longer data hold)
--  
--  Copyright 2002-2003 The MathWorks, Inc.
--  $Revision: 1.4.4.1 $  $Date: 2004/04/08 20:55:09 $
---------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY manchester IS
PORT (
  samp   : IN std_logic;   -- raw sampled Manchester-encoded data
  clk    : IN std_logic;   -- Sample clock (x16 data rate)
  enable : IN std_logic;   -- Disables some clocking
  reset  : IN std_logic;

  data   : OUT std_logic;  -- detected data stream (demodulated)
  dvalid : OUT std_logic;  -- Is data valid ?
  dclk   : OUT std_logic   -- Detected data clock (1/16 of clk)

);
END manchester ;
---------------------------------------
ARCHITECTURE behavioral OF manchester IS

COMPONENT iqconv  -- IQ convolution
PORT (
  clk    : IN std_logic ;
  enable : IN std_logic ;
  reset  : IN std_logic ;
		
  i_wf   : IN std_logic ; -- Inphase Decoding Waveform(from statecnt)
  q_wf   : IN std_logic ; -- Quadrature Decoding Waveform(from statecnt)
  samp   : IN std_logic ; -- raw sampled Manchester-encoded data

  isum   : OUT std_logic_vector(4 downto 0) ; -- (max 17 with adjust)
  qsum   : OUT std_logic_vector( 4 downto 0) -- (max 17 with adjust)
  );
END COMPONENT;

COMPONENT statecnt  -- State Counter
PORT (
  clk    : IN std_logic ;  
  enable : IN std_logic ;
  reset  : IN std_logic ; 
		
  adj    : IN std_logic_vector (1 downto 0); 
		
  sync   : OUT std_logic;  

  i_wf   : OUT std_logic;
  q_wf   : OUT std_logic
);
END COMPONENT;

COMPONENT decoder   -- Decoder
PORT (
  isum   : IN std_logic_vector(4 downto 0); -- (max 17 with adjust)
  qsum   : IN std_logic_vector(4 downto 0); -- (max 17 with adjust)		
		
  adj    : OUT std_logic_vector (1 downto 0);
  dvalid : OUT std_logic;  -- Validity (data)
  odata  : OUT std_logic  -- Detected data stream
  );
END COMPONENT;

FOR ALL : statecnt
  USE ENTITY work.statecnt(behavioral);

FOR ALL : iqconv
  USE ENTITY work.iqconv(behavioral);

FOR ALL : decoder
  USE ENTITY work.decoder(behavioral);

SIGNAL  i_wf_i : std_logic;  --  statcnt --> i_wf --> iqconv
SIGNAL  q_wf_i : std_logic;  --  statcnt --> q_wf --> iqconv


SIGNAL  isum_i : std_logic_vector(4 downto 0); -- (max 17 with adjust)
SIGNAL  qsum_i : std_logic_vector(4 downto 0);
SIGNAL  adj_i  : std_logic_vector (1 downto 0);

SIGNAL  sync_i    : std_logic;
SIGNAL  dvalid_i  : std_logic;
SIGNAL  data_i    : std_logic;

BEGIN
u_iqconv : iqconv port map (
  clk    => clk,
  enable => enable,
  reset  => sync_i,
  
  i_wf   => i_wf_i,
  q_wf   => q_wf_i,
  samp   => samp,

  isum   => isum_i,
  qsum   => qsum_i
);

u_decoder : decoder port map (
  isum   => isum_i,
  qsum   => qsum_i,
		
  adj    => adj_i,
  dvalid => dvalid_i,
  odata  => data_i
);

u_statecnt : statecnt port map (
  clk    => clk,
  enable => enable,
  reset  => reset, 
		
  adj    => adj_i,
  		
  sync   => sync_i,
  i_wf   => i_wf_i,
  q_wf   => q_wf_i
);
  
dclk <= NOT q_wf_i AFTER 1 ns;    -- borrow for data clocking

syncD: PROCESS(clk)  -- Register recovered data to period to match dclk
  BEGIN
  IF (rising_edge(clk)) AND sync_i = '1' THEN
      data <= data_i AFTER 1 ns;
      dvalid <= dvalid_i AFTER 1 ns;
  END IF;
  END PROCESS syncD;

END behavioral;

