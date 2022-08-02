function macdts = macd(ftsa, series_name)
%@FINTS/MACD Moving Average Accumulation/Distribution Line of a FINTS object.
%
%   MACDTS = MACD(FTS) calculates the Moving Average Convergence/Divergence 
%   (MACD) line from the financial time series FTS, as well as the 9-period 
%   exponential moving average from the MACD line.  The MACD is calculated 
%   for the closing price series in FTS presumed to have been named 'Close'. 
%   The result is stored in the FINTS object MACDTS.  MACDTS has the same 
%   dates as the input object FTS and contains only 2 series named 
%   'MACDLine' and 'NinePerMA'.  The first series contains the values 
%   representing the MACD line and the latter is the 9-period exponential 
%   moving average of the MACD line.
%
%   MACDTS = MACD(FTS, SERIES_NAME) is similar to above except that you 
%   can manually specify the series which you want the MACD calculated for.
%   SERIES_NAME specifies the desired series name.
%
%   When the two lines are plotted, they can give you indications on when
%   to buy or sell a stock, when overbought or oversold is occuring, and 
%   when the end of trend may occur.
%
%   The MACD is calculated by subtracting the 26-period (7.5%) exponential 
%   moving average from the 12-period (15%) moving average.  The 9-period 
%   (20%) exponential moving average of the MACD line is used as the 
%   "signal" line.  For example, when the MACD and the 20% moving average 
%   line has just crossed and the MACD line becomes below the other line, 
%   it is time to sell.
%
%   Example:   load disney.mat
%              dis_CloseMACD = macd(dis);
%              dis_OpenMACD = macd(dis, 'OPEN');
%              plot(dis_CloseMACD);
%              plot(dis_OpenMACD);
%
%   See also FINTS/ADLINE, FINTS/WILLAD.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 166-168

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:22:53 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

% Check input arguments.
switch nargin
case 1
    series_name = 'close';
case 2
    if ~ischar(series_name)
        error('Ftseries:ftseries_fints_macd:SecondArgMustBeString', ...
            'Second argument must be string data series name.');
    elseif size(series_name, 1) ~= 1
        error('Ftseries:ftseries_fints_macd:OneStringOnly', ...
            'Please enter only one string.');
    end
otherwise
    error('Ftseries:ftseries_fints_macd:TwoInputsNeeded', ...
        'Two input arguments needed: a FINTS object and a series name.');
end
nameidx = getnameidx(lower(ftsa.names), lower(series_name));
if ~nameidx
    error('Ftseries:ftseries_fints_macd:SeriesNameNotFound', ...
        'SERIES_NAME not found in object specified.');
end

% Calculate the MACD Line and the 9-period exp. mov. avg. of the MACD Line.
[macdvec, nineperma] = macd(ftsa.data{4}(:, nameidx-3));

% Assign output.
macdts               = fints;
macdts.names         = {'desc' 'freq' 'dates' 'MACDLine' 'NinePerMA' 'times'};
macdts.data{1}       = ['MACD: ', ftsa.data{1}];        % desc
macdts.data{2}       = ftsa.data{2};                    % freq
macdts.data{3}       = ftsa.data{3};                    % dates
macdts.data{4}(:, 1) = macdvec(:);                      % data
macdts.data{4}(:, 2) = nineperma(:);                    % data
macdts.data{5}       = ftsa.data{5};                    % times
macdts.datacount     = length(macdvec);
macdts.serscount     = 2;

% [EOF]