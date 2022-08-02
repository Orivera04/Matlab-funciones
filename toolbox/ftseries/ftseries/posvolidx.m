function pvi = posvolidx(varargin)
%POSVOLIDX Positive Volume Index.
%
%   PVI = POSVOLIDX(CLOSEP, TVOLUME) calculates the positive volume 
%   index from a set of stock closing prices (CLOSEP) and traded volume 
%   (TVOLUME) date.  PVI is a vector representing the positive volume 
%   index.  The initial value for the positive volume index is 
%   arbitrarily set to 100.
%
%   PVI = POSVOLIDX([CLOSEP  TVOLUME]) does the same as the above except 
%   that the input is a 2-column matrix whose first column represents the 
%   closing prices (CLOSEP) and the second represents the traded volume 
%   (TVOLUME) data.
%
%   PVI = POSVOLIDX(CLOSEP, TVOLUME, INITPVI) calculates the positive 
%   volume index from a set of stock closing prices (CLOSEP) and traded 
%   volume (TVOLUME) date.  PVI is a vector representing the positive 
%   volume index.  The initial value for the positive volume index is 
%   manually set to INITPVI.
%
%   PVI = POSVOLIDX([CLOSEP  TVOLUME], INITPVI) does the same as the 
%   above except that the input is a 2-column matrix whose first column 
%   represents the closing prices (CLOSEP) and the second represents the 
%   traded volume (TVOLUME) data.
%
%   Example:   load disney.mat
%              dis_PVI = posvolidx(dis_CLOSE, dis_VOLUME);
%              plot(dis_PVI);
%
%   See also NEGVOLIDX, ONBALVOL.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 236-238

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:29:23 $

% Check input arguments.
switch nargin
case 1   % posvolidx([CLOSEP TVOLUME])
    if size(varargin{1}, 2) ~= 2
        error('Ftseries:ftseries_posvolidx:CLOSEAndVOLUMERequired', ...
            'Two columns of data required: CLOSE and VOLUME.');
    end
    closep  = varargin{1}(:, 1);
    tvolume = varargin{1}(:, 2);
    initpvi = 100;
case 2   % posvolidx(CLOSEP, TVOLUME) or posvolidx([CLOSEP  TVOLUME], INITPVI)
    switch size(varargin{1}, 2)
    case 1
        if (size(varargin{1}, 1) ~= size(varargin{2}, 1))
            error('Ftseries:ftseries_posvolidx:LengthOfInputsMustAgree', ...
                'Lengths of all input vectors must agree.');
        end
        closep  = varargin{1}(:);
        tvolume = varargin{2}(:);
        initpvi = 100;
    case 2
        if prod(size(varargin{2})) == 1
            error('Ftseries:ftseries_posvolidx:INITNVIMustBeScalar', ...
                'INITNVI must be a scalar integer.');
        end
        closep  = varargin{1}(:, 1);
        tvolume = varargin{1}(:, 2);
        initpvi = varargin{2};
    end
case 3  % posvolidx(CLOSEP,  TVOLUME, INITPVI)
    if prod(size(varargin{2})) == 1
        error('Ftseries:ftseries_posvolidx:INITNVIMustBeScalar', ...
            'INITNVI must be a scalar integer.');
    end
    closep  = varargin{1}(:);
    tvolume = varargin{2}(:);
    initpvi = varargin{3};
otherwise
    error('Ftseries:ftseries_posvolidx:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the Positive Volume Index (PVI).
pvi = initpvi*ones(size(tvolume));
for didx = 2:length(tvolume)
    if tvolume(didx) > tvolume(didx-1)
        pvi(didx) = pvi(didx-1) * (1+((closep(didx)-closep(didx-1))./closep(didx-1)));
    elseif tvolume(didx) <= tvolume(didx-1)
        pvi(didx) = pvi(didx-1);
    end
end

% [EOF]
