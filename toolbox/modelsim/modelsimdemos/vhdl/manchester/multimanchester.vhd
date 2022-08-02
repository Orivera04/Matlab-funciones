---------------------------------------------------
--  Top Level: Multiblock Manchester Receiver
--  This Level: manchester (multimanchester.vhd)
--  Dependency: iqconv.vhd, statecnt.vhd, decoder.vhd
--
--  Instantiates the parts of the Manchester receiver into
--  a Manchester receiver to be wired up in Simulink.
--  Also instantiates logic to sync the recovered stream
--  data (for a longer data hold)
--  
--  Copyright 2003 The MathWorks, Inc.
--  $Revision $  $Date: 2003/11/03 19:51:21 $
---------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY multimanchester IS

END multimanchester ;
---------------------------------------
ARCHITECTURE behavioral OF multimanchester IS

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

  COMPONENT decoder   -- Decoder
    PORT (
      isum   : IN std_logic_vector(4 downto 0); -- (max 17 with adjust)
      qsum   : IN std_logic_vector(4 downto 0); -- (max 17 with adjust)		
		
      adj    : OUT std_logic_vector (1 downto 0);
      dvalid : OUT std_logic;  -- Validity (data)
      odata  : OUT std_logic  -- Detected data stream
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

  FOR ALL : statecnt
    USE ENTITY work.statecnt(behavioral);

  FOR ALL : iqconv
    USE ENTITY work.iqconv(behavioral);

  FOR ALL : decoder
    USE ENTITY work.decoder(behavioral);

  SIGNAL iqconv_clk       : std_logic;
  SIGNAL iqconv_enable    : std_logic;
  SIGNAL iqconv_sync      : std_logic;
  SIGNAL iqconv_i_wf      : std_logic;
  SIGNAL iqconv_q_wf      : std_logic;
  SIGNAL iqconv_samp      : std_logic;
  SIGNAL iqconv_isum      : std_logic_vector(4 DOWNTO 0);
  SIGNAL iqconv_qsum      : std_logic_vector(4 DOWNTO 0);

  SIGNAL decoder_isum     : std_logic_vector(4 DOWNTO 0);
  SIGNAL decoder_qsum     : std_logic_vector(4 DOWNTO 0);
  SIGNAL decoder_adj      : std_logic_vector(1 DOWNTO 0);
  SIGNAL decoder_dvalid   : std_logic;
  SIGNAL decoder_data     : std_logic;

  SIGNAL statecnt_clk     : std_logic;
  SIGNAL statecnt_enable  : std_logic;
  SIGNAL statecnt_reset   : std_logic;
  SIGNAL statecnt_adj     : std_logic_vector(1 DOWNTO 0);
  SIGNAL statecnt_sync    : std_logic;
  SIGNAL statecnt_i_wf    : std_logic;
  SIGNAL statecnt_q_wf    : std_logic;

  SIGNAL dclk             : std_logic;
  SIGNAL dvalid           : std_logic;
  SIGNAL data             : std_logic;

BEGIN
u_iqconv : iqconv port map (
  clk    => iqconv_clk,
  enable => iqconv_enable,
  reset  => iqconv_sync,
  
  i_wf   => iqconv_i_wf,
  q_wf   => iqconv_q_wf,
  samp   => iqconv_samp,

  isum   => iqconv_isum,
  qsum   => iqconv_qsum
);

u_decoder : decoder port map (
  isum   => decoder_isum,
  qsum   => decoder_qsum,
		
  adj    => decoder_adj,
  dvalid => decoder_dvalid,
  odata  => decoder_data
);

u_statecnt : statecnt port map (
  clk    => statecnt_clk,
  enable => statecnt_enable,
  reset  => statecnt_reset, 
		
  adj    => statecnt_adj,
  		
  sync   => statecnt_sync,
  i_wf   => statecnt_i_wf,
  q_wf   => statecnt_q_wf
);
  
dclk <= NOT statecnt_q_wf AFTER 1 ns;    -- borrow for data clocking

syncD: PROCESS(statecnt_clk)  -- Register recovered data to period to match dclk
  BEGIN
  IF (rising_edge(statecnt_clk)) AND statecnt_sync = '1' THEN
      data <= decoder_data AFTER 1 ns;
      dvalid <= decoder_dvalid AFTER 1 ns;
  END IF;
  END PROCESS syncD;

END behavioral;

