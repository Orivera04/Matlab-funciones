function [mid, uppr, lowr] = bollinger(data, wsize, wts, nstd)
%BOLLINGER The Bollinger band.
%
%   [MID, UPPR, LOWR] = BOLLINGER(DATA) calculates the middle, upper,
%   and lower bands that make up the Bollinger bands from the vector
%   of data, DATA.  MID is the vector that represents the middle band
%   which is a simple moving average with default window size of 20.
%   The UPPR and LOWR are vectors that represent the upper and lower 
%   bands which are +2 times and -2 times moving standard deviations
%   away from the middle band. Data is a column-oriented vector.
%
%   [MID, UPPR, LOWR] = BOLLINGER(DATA, WSIZE, WTS, NSTD) does as 
%   described above; however, you have the freedom of specifying the
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
%     [dis_CloseMid, dis_CloseUppr, dis_CloseLowr] = bollinger(dis_CLOSE);
%     plot([dis_CloseMid, dis_CloseUppr, dis_CloseLowr]);
%
%   See also TSMOVAVG.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 72-74

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9.2.1 $   $Date: 2003/01/16 12:51:13 $

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
    error('Ftseries:ftseries_bollinger:InvalidNumberOfInputArguments', ...
       'Invalid number of input arguments.');
end

% Create output vectors.
mid  = repmat(NaN,size(data,1),1);
uppr = mid;
lowr = mid;

% Create weight vector.
wtsvec = ((1:wsize).^wts) ./ (sum((1:wsize).^wts));

% Save the original data and remove NaN's from the data to be processed.
nnandata = data(~isnan(data));

% Calculate middle band moving average using convolution.
cmid    = conv(nnandata, wtsvec);
nnanmid = cmid(wsize:length(nnandata));

% Calculate shift for the upper and lower bands.  The shift is a
% moving standard deviation of the data.
if wsize >= length(nnandata)
    error('Ftseries:ftseries_bollinger:SpecifyWindowSize', ...
       sprintf(['The number of data points is less than than the default\n', ...
           'window size (20). Please specify a window size.']));
end
for idx = wsize:length(nnandata)
    mstd(idx-wsize+1, :) = std(nnandata(idx-wsize+1:idx));
end

% Calculate the upper and lower bands.
nnanuppr = nnanmid + nstd.*mstd;
nnanlowr = nnanmid - nstd.*mstd;

% Return the values.
nanVec = repmat(NaN,wsize-1,1);
mid(~isnan(data))  = [nanVec; nnanmid];
uppr(~isnan(data)) = [nanVec; nnanuppr];
lowr(~isnan(data)) = [nanVec; nnanlowr];

% [EOF]
