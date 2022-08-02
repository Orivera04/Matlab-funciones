function fts = chfield(fts, fromname, toname)
%@FINTS/CHFIELD changes the existing name(s) of the data series.
%
%   FTS = CHFIELD(FTS, FROMNAME, TONAME) changes the fieldnames (series
%   names) of the financial time series object FTS in FROMNAME to TONAME.
%   The 'dates' and/or 'times' cannot be renamed.
%
%   FROMNAME and TONAME can be a string or a row/column cell array.  A
%   string can be used only when there is ONE fieldname to be changed.
%   A row/column cell array is needed when multiple fieldnames are
%   changed.
%
%   See also FIELDNAMES, ISFIELD, RMFIELD.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.10.2.2 $   $Date: 2004/04/06 01:08:14 $

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(fts);
if ftsVersion
    fts = ftsold2new(fts); % This sorts the fts too.
elseif ~issorted(fts);
    fts = sortfts(fts);
end

if any(~islegalname(toname))
    error('Ftseries:fints_chfield:IllegalNames', ...
        'Illegal name(s) detected. Please check the name(s).');
end

if ischar(fromname) & ischar(toname)
    if size(fromname, 1)~=1 || size(toname, 1)~=1
        error('Ftseries:fints_chfield:SingleStrings', ...
            'FROMNAME and TONAME must be a single string each.');
    end
    
    fnmidx = getnameidx(fts.names, fromname);
    if ~fnmidx
        error('Ftseries:fints_chfield:FROMNAMEDoesNotExist', ...
            'FROMNAME does not exist. Please check spelling and/or case.');
    end
    
    tnmidx = getnameidx(fts.names, toname);
    if tnmidx
        error('Ftseries:fints_chfield:TONAMEExists', ...
            'TONAME exists already.')
    end
    
    fts.names{fnmidx} = toname;
else
    if iscell(fromname) && ~iscell(toname)
        error('Ftseries:fints_chfield:InvalidTONAME', ...
            'TONAME must be a column cell array of string like FROMNAME.');
    elseif iscell(toname) && ~iscell(fromname)
        error('Ftseries:fints_chfield:InvalidFROMNAME', ...
            'FROMNAME must be a column cell array of string like TONAME.');
    end
    
    if iscell(fromname) && iscell(toname)
        if (size(fromname, 1)~=1 && size(fromname, 2)~=1) || ...
                (size(toname, 1)~=1 && size(toname, 2)~=1)   
            error('Ftseries:fints_chfield:InvalidTOansFROMNAME', ...
                'FROMNAME and/or TONAME must be a vector cell array of strings.');
        end
        if length(fromname(:))~=length(toname(:))
            error('Ftseries:fints_chfield:InvalidTOansFROMNAME', ...
                'FROMNAME and TONAME must have the same number of cells.');
        end
    end
    if length(fromname) ~= length(unique(fromname))
        error('Ftseries:fints_chfield:FROMNAMENotUniq', ...
            'FROMNAMEs in the list must be unique.');
    elseif length(toname) ~= length(unique(toname))
        error('Ftseries:fints_chfield:TOMNAMENotUniq', ...
            'TONAMEs in the list must be unique.');
    end
    
    fnmidx = getnameidx(fts.names, fromname);
    if any(~fnmidx)
        error('Ftseries:fints_chfield:CheckSpelling', ...
            sprintf(['One or more of the strings in FROMNAME does not exist.\n', ...
                'Please check spelling and/or case.']));
    end
    tnmidx = getnameidx(fts.names, toname);
    if any(tnmidx)
        error('Ftseries:fints_chfield:DuplicateTONAMES', ...
            'One or more TONAMEs exist already.')
    end
    
    fts.names(fnmidx) = toname;
end

% [EOF]
