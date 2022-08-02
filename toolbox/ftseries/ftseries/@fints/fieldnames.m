function fnames = fieldnames(tso, seriesonlyflag)
%@FINTS/FIELDNAMES gets field names in a FINTS object.
%
%   FNAMES = fieldnames(FTS) returns the FINTS object field names
%   associated with the FINTS object FTS as a cell array of strings,
%   including the common minimum fields: desc, freq, and dates.  The
%   names are returned in the cell array FNAMES.
%    
%   FNAMES = fieldnames(FTS, SRSNAMEONLY) returns the FINTS object 
%   field names associated with the FINTS object FTS as a cell array 
%   of strings.  The field names returned in the cell array FNAMES
%   depends on the value of SRSNAMEONLY.  If SRSNAMEONLY is set to 0,
%   all field names will be returned including the common minimum 
%   fields: desc, freq, dates, and times.  However, if SRSNAMEONLY is
%   set to 1, only the data series name(s) will be returned in FNAMES.
%    
%   See also GETFIELD, SETFIELD, RMFIELD, ISFIELD, CHFIELD.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.10.2.2 $  $Date: 2004/04/06 01:08:17 $

% If the object is of an older version, convert it.
[ftsVersion, timeData] = fintsver(tso);

if ftsVersion == 1
    tso = ftsold2new(tso); % This sorts the fts too.
elseif ~issorted(tso)
    tso = sortfts(tso);
end

if nargin == 1
    seriesonlyflag = 0;
end

if (seriesonlyflag ~= 0) & (seriesonlyflag ~= 1)
    error('Ftseries:ftseries_fints_fieldnames:InvalidSeriesOnlyFlag', ...
        '''Series Flag'' can only be 1 or 0.');
end

if seriesonlyflag
    fnames = tso.names(4:end-1)';
else
    if timeData
        fnames = tso.names';
    else
        fnames = tso.names(1:end-1)';
    end
end

% [EOF]
