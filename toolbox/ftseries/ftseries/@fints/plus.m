function fts = plus(ftsa, ftsb)
%@FINTS/PLUS implements the addition method of FINTS objects.  
%
%   If an object is to be summed with another object, both objects 
%   must have the same frequency, dates and components. (NOTE: Component 
%   names must also be the same although the order need not be the same.)
%   The PLUS method will, essentially, add element-per-element the 
%   contents of the components.  You may also add a scalar value to the 
%   whole object. 
%
%   The order of the data series, when 2 objects are added to each 
%   other, follows the order of the first object.  For example,
%
%      FTSRES = FTSA + FTSB;
%
%   FTSRES will have data series order identical to FTSA.
%
%   See also @FINTS/MINUS, @FINTS/TIMES, @FINTS/MRDIVIDE.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:21:49 $

if isnumeric(ftsa)
    % If the object is of an older version, convert it.
    if fintsver(ftsb) == 1
        ftsb = ftsold2new(ftsb); % This sorts the fts too.
    elseif ~issorted(ftsb)
        ftsb = sortfts(ftsb);
    end
    fts = ftsb;
    fts.data{4} = ftsa + ftsb.data{4};
elseif isnumeric(ftsb)
    % If the object is of an older version, convert it.
    if fintsver(ftsa) == 1
        ftsa = ftsold2new(ftsa); % This sorts the fts too.
    elseif ~issorted(ftsa)
        ftsa = sortfts(ftsa);
    end
    fts = ftsa;
    fts.data{4} = ftsa.data{4} + ftsb;
else
    if ~iscompatible(ftsa, ftsb)
        error('Ftseries:ftseries_fints_plus:FINTSObjNotIdentical', ...
            'FINTS objects are not compatible (identical).');
    end
    [dtnmsa, ftsanamesidx] = sort(ftsa.names(4:end-1));
    [dtnmsb, ftsbnamesidx] = sort(ftsb.names(4:end-1));
    fts = ftsa;
    if ftsa.data{2} ~= ftsb.data{2}
        fts.data{2} = 0;
    end
    fts.data{4}(:,ftsanamesidx) = ftsa.data{4}(:,ftsanamesidx) + ftsb.data{4}(:,ftsbnamesidx);
end

% [EOF]