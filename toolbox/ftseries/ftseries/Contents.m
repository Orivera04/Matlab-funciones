% Financial Time Series Toolbox
% Version 2.1 (R14) 05-May-2004
%
% Financial Time Series Toolbox Methods
%   (*) indicates that it is an overloaded method (i.e. MATLAB functions
%       or Toolbox functions overloaded to work with FINTS objects).
%
% FINTS object construction & conversion.
%   @fints/fints      - Construct a financial time series object, FINTS.
%   @fints/ftsnew2old - Convert Version 2 time series object to Version 1.
%   @fints/ftsold2new - Convert Version 1 time series object to Version 2.
%   @fints/fts2ascii  - Write a FINTS object into an ASCII file.
%   @fints/fts2mat    - Create a matrix from a FINTS object.
%
% Graphics.
%   @fints/bar         - (*)Bar chart from a FINTS object.
%   @fints/bar3        - (*)Horizontal Bar chart from a FINTS object.
%   @fints/barh        - (*)3D Bar chart from a fints object.
%   @fints/bar3h       - (*)3D Horizontal Bar chart from a FINTS object.
%   @fints/candle      - (*)Candle plot from a FINTS object.
%   @fints/chartfts    - Interactive charting of a FINTS object.
%   @fints/highlow     - (*)High-Low plot from a FINTS object.
%   @fints/plot        - (*)Plot of data series in a FINTS object.
%
% Arithmetic & special characters.  (Do not use directly!  See MATLAB User's Guide!)
%   @fints/minus       - (*)Subtraction method of FINTS objects.  
%   @fints/mrdivide    - (*)Division method of FINTS objects.
%   @fints/mtimes      - (*)Multiplication method of FINTS objects.
%   @fints/plus        - (*)Addition method of FINTS objects.  
%   @fints/power       - (*)Power operation for FINTS objects.
%   @fints/rdivide     - (*)Division method of FINTS objects.  
%   @fints/times       - (*)Multiplication method of FINTS objects.  
%   @fints/uminus      - (*)Unary minus plus for the FINTS objects.
%   @fints/uplus       - (*)Unary plus for the FINTS objects.
%   @fints/end         - (*)Index to the last date entry in a FINTS object.
%   @fints/subsasgn    - (*)Assignment into a FINTS object.
%   @fints/subsref     - (*)Indexing for the FINTS object.
%   @fints/display     - (*)Display the financial time series object.
%   @fints/horzcat     - (*)Horizontal concatenation of FINTS objects.  
%   @fints/vertcat     - (*)Vertical concatenation of FINTS objects.  
%
% Mathematical functions.
%   @fints/cumsum      - (*)Cumulative sum of data series elements in a FINTS object.
%   @fints/exp         - (*)Exponential of data series in a FINTS object.
%   @fints/hist        - (*)Histograms of each data series in a FINTS object.
%   @fints/log         - (*)Natural logarithm of data series in a FINTS object.
%   @fints/log2        - (*)Logarithm base 2 of data series in a FINTS object.
%   @fints/log10       - (*)Common logarithm of data series in a FINTS object.
%   @fints/max         - (*)Maximum values of each data series in a FINTS object.
%   @fints/mean        - (*)Arithmetic average of a FINTS object component(s).
%   @fints/min         - (*)Minimum values of each data series in a FINTS object.
%   @fints/std         - (*)Standard deviations of data series in a FINTS object.
%
% Object utility.
%   @fints/chfield      - Change the existing name(s) of FINTS object series.
%   @fints/extfield     - Extract data series from a FINTS object.
%   @fints/fetch        - (*)Extract data from financial time series object.
%   @fints/fieldnames   - (*)Field names in a FINTS object.
%   @fints/fintsver     - Determine version.
%   @fints/flipud       - (*)Flip data in a FINTS object in the up/down direction.
%   @fints/ftsbound     - Starting and ending dates of a FINTS object.
%   @fints/getfield     - (*)Get structure field contents of a FINTS object.
%   @fints/iscompatible - Structural compatibility check of FINTS objects.
%   @fints/isequal      - (*)Equality check of multiple FINTS objects.
%   @fints/isfield      - (*)True if field is in FINTS object structure array.
%   @fints/issorted     - Check if dates and times are monotonically increasing.
%   @fints/length       - (*)Get the number of dates (rows) in a FINTS object.
%   @fints/rmfield      - (*)Remove a field and its content from a FINTS object.
%   @fints/setfield     - (*)Set structure field contents of a FINTS object.
%   @fints/size         - (*)Get the number of dates and data series in a FINTS object.
%   @fints/sortfts      - Sort contents of a FINTS object chronologically.
%
% Time Series Frequency conversion.
%   @fints/convertto    - Convert a FINTS object to one of another frequency.
%   @fints/resamplets   - Down-sample data in a FINTS object.
%   @fints/toannual     - Convert a FINTS object to one of an annual freq. 
%   @fints/todaily      - Convert a FINTS object to one of a daily freq. 
%   @fints/tomonthly    - Convert a FINTS object to one of a monthly freq. 
%   @fints/toquarterly  - Convert a FINTS object to one of a quarterly freq. 
%   @fints/tosemi       - Convert a FINTS object to one of a semiannual freq. 
%   @fints/toweekly     - Convert a FINTS object to one of a weekly freq. 
%
% Data Transformation.
%   @fints/boxcox    - Transform non-normal to a normal FINTS.
%   @fints/diff      - (*)Difference of the values in a FINTS object.
%   @fints/fillts    - Fill NaNs in a FINTS object through interpolation.
%   @fints/filter    - (*)Filter FINTS object components.
%   @fints/lagts     - Delay a FINTS object values by a time step.
%   @fints/leadts    - Advance a FINTS object values by a time step.
%   @fints/peravg    - Periodic average of a FINTS object.
%   @fints/smoothts  - Smooth a FINTS object.
%   @fints/tsmovavg  - Moving average of FINTS object data series.
%
% Oscillators.
%   @fints/adosc     - Accumulation/Distribution (A/D) Oscillator of a FINTS object.
%   @fints/chaikosc  - Chaikin Oscillator of a FINTS object.
%   @fints/macd      - Moving Average Accumulation/Distribution Line of a FINTS object.
%   @fints/stochosc  - Stochastic Oscillator of a FINTS object.
%   @fints/tsaccel   - Acceleration between N periods of a FINTS object.
%   @fints/tsmom     - Momentum between N periods of a FINTS object.
%
% Stochastics.
%   @fints/chaikvolat  - Chaikin's Volatility of a FINTS object.
%   @fints/fpctkd      - Fast PercentK (F%K) and Fast Percentd (F%D) of a FINTS object.
%   @fints/spctkd      - Slow Stochastics, S%K and S%D, for a FINTS object.
%   @fints/willpctr    - Williams PercentR (%R) of a FINTS object.
%
% Indices.
%   @fints/negvolidx  - Negative Volume Index of a FINTS object.
%   @fints/posvolidx  - Positive Volume Index of a FINTS object.
%   @fints/rsindex    - Relative Strength Index (RSI) of a FINTS object.
%
% Indicators.
%   @fints/adline     - Accumulation/Distribution Line of a FINTS object.
%   @fints/bollinger  - The Bollinger Band of a FINTS object.
%   @fints/hhigh      - Highest high of a FINTS object within the past N periods.
%   @fints/llow       - Lowest low of a FINTS object within the past N periods.
%   @fints/medprice   - Median Price of a FINTS object.
%   @fints/onbalvol   - On-Balance Volume of a FINTS object.
%   @fints/prcroc     - Volume Rate-of-Change of a FINTS object.
%   @fints/pvtrend    - Price and Volume Trend (PVT) of a FINTS object.
%   @fints/typprice   - Typical Price of a FINTS object.
%   @fints/volroc     - Volume Rate-of-Change of a FINTS object.
%   @fints/wclose     - Weighted Close of a FINTS object.
%   @fints/willad     - Williams Accumulation/Distribution Line of a FINTS object.
%
% ---------------------------------------
% Financial Time Series Toolbox Functions
%
% Financial Time Series GUI.
%   ftsgui      - Financial Time Series Graphical Interface.
%
% Data Transformation.
%   boxcox      - Transform non-normal to normally distributed data.
%   smoothts    - Smooth a matrix of data using a specified method.
%   tsmovavg    - Moving average (simple, exp., tri., weighted, modified).
%
% Time Series Oscillators.
%   adosc       - Accumulation/Distribution (A/D) Oscillator.
%   chaikosc    - Chaikin Oscillator.
%   macd        - Moving Average Convergence/Divergence (MACD).
%   stochosc    - Stochastic Oscillator.
%   tsaccel     - Acceleration between N periods.
%   tsmom       - Momentum between N periods.
%
% Time Series Stochastics.
%   chaikvolat  - Chaikin's Volatility.
%   fpctkd      - Fast PercentK (F%K) and Fast PercentD (F%D).
%   spctkd      - Slow Stochastics, PercentK (S%K) and PercentD (S%D).
%   willpctr    - Williams PercentR (%R).
%
% Time Series Indices.
%   negvolidx   - Negative Volume Index.
%   posvolidx   - Positive Volume Index.
%   rsindex     - Relative Strength Index (RSI).
%
% Time Series Indicators.
%   adline      - Accumulation/Distribution Line.
%   bollinger   - The Bollinger band.
%   hhigh       - Highest high within the past N periods.
%   llow        - Lowest low within the past N periods.
%   medprice    - Median Price.
%   onbalvol    - On-Balance Volume.
%   prcroc      - Price Rate-of-Change.
%   pvtrend     - Price and Volume Trend (PVT).
%   typprice    - Typical Price.
%   volroc      - Volume Rate-of-Change.
%   wclose      - Weighted Close.
%   willad      - Williams Accumulation/Distribution Line.
%
% Date functions.
%   busdays     - Generate a vector of business days.
%
% Utility functions.
%   fintsver    - Determine version.
%   freqnum     - Convert string to numeric frequency indicator.
%   freqstr     - Convert numeric to string frequency indicator.
%   ftsinfo     - Get information on a FINTS object variable.
%   ftsuniq     - Determine uniqueness.
%   getnameidx  - Get the order/indices of string(s) in a list.
%   issorted    - Check if dates and times are monotonically increasing.
%   todecimal   - Convert quoted (fractional) figures to decimal equivalents.
%   toquoted    - Convert decimal figures to fractional equivalents (quoted).
%
% Object Conversion.
%   ascii2fts   - Generate a FINTS object from an ASCII data file.
%   ftsnew2old  - Convert Version 2 time series object to Version 1.
%   ftsold2new  - Convert Version 1 time series object to Version 2.
%   fts2ascii   - Create a text (ASCII) file from a FINTS object.
%
% Tutorials.
%   intro_fints   - Creating FINTS objects. 
%   using_fints   - Using and manipulating FINTS objects.
%   tech_analysis - Technical Analysis using FINTS objects.
%
% Demos.
%   loadexpfts  - Loads example time series objects into the workspace.
%   predict_ret - Using FINTS objects and regression to predict returns.
%
% -----------------------------------------
% Financial Time Series Toolbox Sample Data
%
% ASCII (text) data file.
%   disney.dat     - Walt Disney Corporation (Open/Close/High/Low/Volume) data.
%   dji30.dat      - Dow Jones Industrial Average (Open/Close/High/Low) data.
%   dji30mar94.dat - Dow Jones Industrial Average (O/C/H/L) March 1994 data.
%   dji30apr94.dat - Dow Jones Industrial Average (O/C/H/L) April 1994 data.
%   dji30may94.dat - Dow Jones Industrial Average (O/C/H/L) May 1994 data.
%   dji30jun94.dat - Dow Jones Industrial Average (O/C/H/L) June 1994 data.
%   ibm9599.dat    - IBM Corporation (Open/Close/High/Low/Volume) data.
%   whirlpool.dat  - Whirlpool Corporation (Open/Close/High/Low/Volume) data.
%
% MAT-file format datasets.
%   disney.mat     - Open, Close, High, Close, and Volume data plus the object.
%   dji30short.mat - 4 (four) FINTS objects from the above 4 short data files.
%   ftsdata.mat    - Combination of DIS, IBM, and WHR time series data.

% Copyright 1995-2004 The MathWorks, Inc.
% Generated from Contents.m_template revision 1.1.6.1   $Date: 2003/02/20 16:11:04 $


