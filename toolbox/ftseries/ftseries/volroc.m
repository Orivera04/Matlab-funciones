function vroc = volroc(tvolume, nperiods)
%VOLROC Volume Rate-of-Change.
%
%   VROC = VOLROC(TVOLUME) calculates the volume rate-of-change, VROC, 
%   from the volume traded data TVOLUME.  The volume rate-of-change is 
%   calculated between the current volume and the volume 12 periods 
%   ago.
%
%   VROC = VOLROC(TVOLUME  NPERIODS) calculates the volume rate-of-change,
%   VROC, similarly as above except, instead of the 12-period difference,
%   it is NPERIODS period difference.  The volume rate-of-change is 
%   calculated between the current volume and the volume NPERIODS periods 
%   ago.
%
%   Example:   load disney.mat
%              dis_VROC = volroc(dis_VOLUME);
%              plot(dis_VROC);
%
%   See also PRCROC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 310-311

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.13 $   $Date: 2002/01/21 12:30:35 $

% Check input arguments.
switch nargin
case 1
    nperiods = 12;
case 2
otherwise
    error('Ftseries:ftseries_volroc:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Make sure that inputs make sense.
if nperiods > length(tvolume)
    error('Ftseries:ftseries_volroc:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of data points.');
end

% Calculate the Volume Rate-of-Change (VROC).
if (nperiods > 0) & (nperiods ~= 0)
    vroc = NaN*ones(size(tvolume));
    for didx = nperiods:length(vroc)
        vroc(didx) = ((tvolume(didx)-tvolume(didx-nperiods+1))./tvolume(didx-nperiods+1))*100;
    end
elseif nperiods < 0
    error('Ftseries:ftseries_volroc:NPERIODSMustBePosScalar', ...
        'NPERIODS must be a positive scalar.');
else
    vroc = tvolume;
end

% [EOF]