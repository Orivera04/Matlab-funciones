function obv = onbalvol(varargin)
%ONBALVOL On-Balance Volume.
%
%   OBV = ONBALVOL(CLOSEP, TVOLUME) calculates the On-Balance Volume from 
%   the stock closing price (CLOSEP) and volume traded (TVOLUME) data.
%   OBV is the vector that contains the On-Balance Volume of the stock.
%
%   OBV = ONBALVOL([CLOSEP  TVOLUME]) does similar to above except the 
%   2 input vectors are entered as a 2-column matrix representing the 
%   closing price (CLOSEP) and volume traded (TVOLUME), in that order.
%
%   Example:   load disney.mat
%              dis_OBV = onbalvol(dis_CLOSE, dis_VOLUME);
%              plot(dis_OBV);
%
%   See also NEGVOLIDX, POSVOLIDX.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 207-209

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:29:16 $

% Check input arguments.
switch nargin
case 1
    if size(varargin{1}, 2) ~= 2
        error('Ftseries:ftseries_onbalvol:CLOSEAndVOLUMERequired', ...
            'Two columns of data required: CLOSE and VOLUME.');
    end
    closep  = varargin{1}(:, 1);
    tvolume = varargin{1}(:, 2);
case 2
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1))
        error('Ftseries:ftseries_onbalvol:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    closep  = varargin{1}(:);
    tvolume = varargin{2}(:);
otherwise
    error('Ftseries:ftseries_onbalvol:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the On-Balance Volume.
obv = tvolume;
for didx = 2:length(tvolume),
    if closep(didx) > closep(didx-1)
        obv(didx) = obv(didx-1) + tvolume(didx);
    elseif closep(didx) < closep(didx-1)
        obv(didx) = obv(didx-1) - tvolume(didx);
    elseif closep(didx) == closep(didx-1)
        obv(didx) = obv(didx-1);
    end
end

% [EOF]
