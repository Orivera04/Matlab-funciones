function fts = resamplets(ftsa, samplestep)
%@FINTS/RESAMPLETS downsamples data in a FINTS object.
%
%   NEWFTS = resamplets(OLDFTS, SAMPLESTEP) downsamples the data contained
%   in the FINTS object OLDFTS every SAMPLESTEP periods.  For example,
%   if you would like to have the new FINTS object to contain every other
%   row of data from OLDFTS, the SAMPLESTEP used should be 2.
%
%   See also FILTER.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.7.2.1 $   $Date: 2003/01/16 12:51:01 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

fts = ftsa;

fts.data{1} = ['RESAMPLES of ', ftsa.data{1}];  % desc
fts.data{2} = 0;                                % freq
fts.data{3} = ftsa.data{3}(1:samplestep:end);   % dates
fts.data{4} = ftsa.data{4}(1:samplestep:end, :);% data
fts.data{5} = ftsa.data{5}(1:samplestep:end);   % times

fts.datacount = size(fts.data{3},1);

% [EOF]