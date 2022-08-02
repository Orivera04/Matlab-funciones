function fts = uminus(ftsa)
%@FINTS/UMINUS implements unary minus plus for the FINTS objects.
%
%   See also @FINTS/UPLUS. 

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.7 $   $Date: 2002/01/21 12:19:08 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

fts = ftsa;
fts.data{4} = -1 * ftsa.data{4};

% [EOF]