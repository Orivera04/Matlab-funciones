function nvi = negvolidx(varargin)
%NEGVOLIDX Negative Volume Index.
%
%   NVI = NEGVOLIDX(CLOSEP, TVOLUME) calculates the negative volume index from 
%   a set of stock closing prices (CLOSEP) and traded volume (TVOLUME) date. 
%   NVI is a vector representing the negative volume index.  The initial value 
%   for the negative volume index is arbitrarily set to 100.
%
%   NVI = NEGVOLIDX([CLOSEP  TVOLUME]) does the same as the above except that 
%   the input is a 2-column matrix whose first column represents the closing 
%   prices (CLOSEP) and the second represents the traded volume (TVOLUME) data.
%
%   NVI = NEGVOLIDX(CLOSEP, TVOLUME, INITNVI) calculates the negative volume 
%   index from a set of stock closing prices (CLOSEP) and traded volume 
%   (TVOLUME) date.  NVI is a vector representing the negative volume index.  
%   The initial value for the negative volume index is manually set to INITNVI.
%
%   NVI = NEGVOLIDX([CLOSEP  TVOLUME], INITNVI) does the same as the above 
%   except that the input is a 2-column matrix whose first column represents 
%   the closing prices (CLOSEP) and the second represents the traded volume 
%   (TVOLUME) data.
%
%   Example:   load disney.mat
%              dis_NVI = negvolidx(dis_CLOSE, dis_VOLUME);
%              plot(dis_NVI);
%
%   See also ONBALVOL, POSVOLIDX.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 193-194

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:29:09 $

% Check input arguments.
switch nargin
case 1   % negvolidx([CLOSEP TVOLUME])
    if size(varargin{1}, 2) ~= 2
        error('Ftseries:ftseries_negvolidx:CLOSEAndVOLUMERequired', ...
            'Two columns of data required: CLOSE and VOLUME.');
    end
    closep  = varargin{1}(:, 1);
    tvolume = varargin{1}(:, 2);
    initnvi = 100;
case 2   % negvolidx(CLOSEP, TVOLUME) or negvolidx([CLOSEP  TVOLUME], INITNVI)
    switch size(varargin{1}, 2)
    case 1
        if (size(varargin{1}, 1) ~= size(varargin{2}, 1))
            error('Ftseries:ftseries_negvolidx:LengthOfInputsMustAgree', ...
                'Lengths of all input vectors must agree.');
        end
        closep  = varargin{1}(:);
        tvolume = varargin{2}(:);
        initnvi = 100;
    case 2
        if prod(size(varargin{2})) == 1
            error('Ftseries:ftseries_negvolidx:INITNVIMustBeScalar', ...
                'INITNVI must be a scalar integer.');
        end
        closep  = varargin{1}(:, 1);
        tvolume = varargin{1}(:, 2);
        initnvi = varargin{2};
    end
case 3   % negvolidx(CLOSEP,  TVOLUME, INITNVI)
    if prod(size(varargin{2})) == 1
        error('Ftseries:ftseries_negvolidx:INITNVIMustBeScalar', ...
            'INITNVI must be a scalar integer.');
    end
    closep  = varargin{1}(:);
    tvolume = varargin{2}(:);
    initnvi = varargin{3};
otherwise
    error('Ftseries:ftseries_negvolidx:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the Negative Volume Index (NVI).
nvi = initnvi*ones(size(tvolume));
for didx = 2:length(tvolume)
    if tvolume(didx) < tvolume(didx-1)
        nvi(didx) = nvi(didx-1) * (1+((closep(didx)-closep(didx-1))./closep(didx-1)));
    elseif tvolume(didx) >= tvolume(didx-1)
        nvi(didx) = nvi(didx-1);
    end
end

% [EOF]
