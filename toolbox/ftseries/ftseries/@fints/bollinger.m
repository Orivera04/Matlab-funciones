function [midfts, upprfts, lowrfts] = bollinger(fts, wsize, wts, nstd)
%@FINTS/BOLLINGER The Bollinger Band of a FINTS object.
%
%   [MIDFTS, UPPRFTS, LOWRFTS] = BOLLINGER(FTS) calculates the middle, 
%   upper, and lower bands that make up the Bollinger bands from a 
%   financial time series object FTS.  MIDFTS is a FINTS object that 
%   represents the middle band for all series in the input object FTS.
%   The UPPRFTS and LOWRFTS are FINTS objects that represent the upper 
%   and lower bands of all series which are +2 times and -2 times moving 
%   standard deviations away from the middle band.
%
%   [MIDFTS, UPPRFTS, LOWRFTS] = BOLLINGER(FTS, WSIZE, WTS, NSTD) does 
%   as described above, but you have the freedom of specifying the
%   window size (WSIZE), weight factor (WTS), and number of standard 
%   deviations (NSTD) for the upper and lower bands.  The defaults 
%   for these parameters are 20, 0, and 2, respectively.
%
%   The weight factor, WTS, determines the type of moving average used
%   to calculate the middle band with.  When it is 0 (zero), simple
%   (box) moving average is used.  When it is 1 (one), linear moving
%   average is employed.  And, so on.
%
%   Example:   
%
%     load disney.mat
%     [dis_Mid, dis_Uppr, dis_Lowr] = bollinger(dis);
%     dis_CloseBolling = [dis_Mid.CLOSE, dis_Uppr.CLOSE, dis_Lowr.CLOSE];
%     plot(dis_CloseBolling);
%
%   See also TSMOVAVG.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 72-74

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11.2.1 $   $Date: 2003/01/16 12:50:49 $

% If the object is of an older version, convert it.
if fintsver(fts) == 1
    fts = ftsold2new(fts); % This sorts the fts too.
elseif ~issorted(fts)
    fts = sortfts(fts);
end

% Check input arguments.
switch nargin
case 1
    wsize = 20;
    wts   = 0;   % Simple moving average (Box).
    nstd  = 2;
case 2
    wts   = 0;   % Simple moving average (Box).
    nstd  = 2;
case 3
    nstd  = 2;
case 4
otherwise
    error('Ftseries:ftseries_fints_bollinger:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate Bollinger bands by calling the generalized BOLLINGER.
mid  = zeros(fts.datacount, fts.serscount);
uppr = zeros(fts.datacount, fts.serscount);
lowr = zeros(fts.datacount, fts.serscount);
for sidx = 1:fts.serscount
    [mid(:, sidx), uppr(:, sidx), lowr(:, sidx)] = bollinger(fts.data{4}(:, sidx), wsize, wts, nstd);
end

% Prepare & assign output arguments.
midfts = fints;
midfts.names   = fts.names;
midfts.data{1} = ['Middle Bollinger Band of ', fts.data{1}];
midfts.data{2} = fts.data{2};
midfts.data{3} = fts.data{3};
midfts.data{4} = mid;
midfts.data{5} = fts.data{5};
midfts.datacount = size(mid,1);
midfts.serscount = fts.serscount;

if nargout <= 3
    upprfts = fints;
    upprfts.names   = fts.names;
    upprfts.data{1} = ['Upper Bollinger Band of ', fts.data{1}];
    upprfts.data{2} = fts.data{2};
    upprfts.data{3} = fts.data{3};
    upprfts.data{4} = uppr;
    upprfts.data{5} = fts.data{5};
    upprfts.datacount = size(uppr,1);
    upprfts.serscount = fts.serscount;
end

if nargout == 3
    lowrfts = fints;
    lowrfts.names   = fts.names;
    lowrfts.data{1} = ['Upper Bollinger Band of ', fts.data{1}];
    lowrfts.data{2} = fts.data{2};
    lowrfts.data{3} = fts.data{3};
    lowrfts.data{4} = lowr;
    lowrfts.data{5} = fts.data{5};
    lowrfts.datacount = size(lowr,1);
    lowrfts.serscount = fts.serscount;
end

if nargout > 3
    error('Ftseries:ftseries_fints_bollinger:InvalidNumberOfOutputArguments', ...
        'Invalid number of output arguments.');
end

% [EOF]
