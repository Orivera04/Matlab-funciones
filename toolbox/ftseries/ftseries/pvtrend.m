function pvt = pvtrend(varargin)
%PVTREND Price and Volume Trend (PVT).
%
%   PVT = pvtrend(CLOSEP, TVOLUME) calculates the Price and Volume 
%   Trend (PVT) from the stock closing price (CLOSEP) data and the
%   traded volume (TVOLUME) data.
%
%   PVT = pvtrend([CLOSEP  TVOLUME]) does the same as above except
%   that the input is a 2-column matrix which first column is the 
%   closing prices (CLOSEP) and the second is the trade volume 
%   (TVOLUME) data.
%
%   Example:   load disney.mat
%              dis_PVT = pvtrend(dis_CLOSE, dis_VOLUME);
%              plot(dis_PVT);
%
%   See also TSACCEL, TSMOM.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 239-240

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:29:35 $

% Check input arguments.
switch nargin
case 1   % pvtrend([CLOSEP TVOLUME])
    if size(varargin{1}, 2) ~= 2
        error('Ftseries:ftseries_pvtrend:CLOSEAndVOLUMERequired', ...
            'Two columns of data required: CLOSE and VOLUME.');
    end
    closep  = varargin{1}(:, 1);
    tvolume = varargin{1}(:, 2);
case 2   % pvtrend(CLOSEP, TVOLUME)
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1))
        error('Ftseries:ftseries_pvtrend:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    closep  = varargin{1}(:);
    tvolume = varargin{2}(:);
otherwise
    error('Ftseries:ftseries_pvtrend:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the Price and Volume Trend (PVT).
nnanpvt  = tvolume(~isnan(tvolume));
nnantvol = tvolume(~isnan(tvolume));
nnanclsp = closep(~isnan(closep));
for didx = 2:length(nnantvol)
    nnanpvt(didx) = (((nnanclsp(didx)-nnanclsp(didx-1))/nnanclsp(didx-1)) * ...
        nnantvol(didx)) + nnanpvt(didx-1);
end
pvt = NaN*ones(size(tvolume));
pvt(~isnan(tvolume)) = nnanpvt;

% [EOF]
