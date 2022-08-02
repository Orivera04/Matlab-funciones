function isfld = isfield(fts, fldname)
%@FINTS/ISFIELD True if field is in FINTS object structure array.
%
%   F = ISFIELD(FTS, FLDNAME) returns true if FLDNAME is the name of a
%   field in the FINTS object structure array S.
% 
%   See also GETFIELD, SETFIELD, FIELDNAMES.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/04/14 16:30:55 $

% If the object is of an older version, convert it.
if fintsver(fts) == 1
    w = warning('off');
    fts = ftsold2new(fts); % This sorts the fts too.
    warning(w);
elseif ~issorted(fts)
    fts = sortfts(fts);
end

if ischar(fldname) & size(fldname, 1)==1
    isfld = any(getnameidx(fts.names, fldname));
else
    error('Ftseries:ftseries_fints_isfield:FLDNAMEMustBeSingleString', ...
        'FLDNAME must be a single string.');
end

% [EOF]
