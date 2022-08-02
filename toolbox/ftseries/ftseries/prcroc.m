function proc = prcroc(closep, nperiods)
%PRCROC Price Rate-of-Change.
%
%   PROC = PRCROC(CLOSEP) calculates the price rate-of-change, PROC, 
%   from the closing price data CLOSEP.  The volume rate-of-change is 
%   calculated between the current closing price and the closing price 
%   12 periods ago.
%
%   PROC = PRCROC(CLOSEP, NPERIODS) calculates the price rate-of-change,
%   PROC, similarly as above except, instead of the 12-period difference,
%   it is NPERIODS period difference.  The price rate-of-change is 
%   calculated between the current closing price and the closing price 
%   NPERIODS periods ago.
%
%   Example:   load disney.mat
%              dis_PROC = prcroc(dis_CLOSE);
%              plot(dis_PROC);
%
%   See also VOLROC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 243-245

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.12 $   $Date: 2002/01/21 12:29:28 $

% Check input arguments.
switch nargin
case 1
    nperiods = 12;
case 2
otherwise
    error('Ftseries:ftseries_prcroc:ClosingPriceRequired', ...
        'Closing prices required.');
end

% Make sure that inputs make sense.
if nperiods > length(closep)
    error('Ftseries:ftseries_prcroc:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of data points.');
end

% Calculate the Price Rate-Of-Change (PROC).
if (nperiods > 0) & (nperiods ~= 0)
    proc = NaN*ones(size(closep));
    for didx = nperiods:length(closep)
        proc(didx) = ((closep(didx)-closep(didx-nperiods+1))./closep(didx-nperiods+1))*100;
    end
elseif nperiods < 0
    error('Ftseries:ftseries_proc:NPERIODSMustBePosScalar', ...
        'NPERIODS must be a positive scalar.');
else
    proc = closep;
end
% [EOF]