function [no, xo] = hist(ftsin, nbins)
%@FINTS/HIST Overloaded for FINTS objects: displays/calculate histogram.
%
%   HIST(FTS) calculates and displays the histogram of the data series
%   contained in the FINTS object, FTS.  It defaults to 10 (ten)
%   histogram bins.
%
%   FTSHIST = HIST(FTS) calculates the histogram of the data series in
%   the FINTS object FTS.  It does not display the plot/chart as in the
%   first syntax.  It defaults to 10 (ten) bins.  FTSHIST is a structure
%   with fieldnames similar to the data series names of the object FTS.
%
%   [FTSHIST, BINPOS] = HIST(FTS) does exactly the same as above with
%   the addition of returning the bin positions BINPOS.  The positions 
%   are the centers of each bins.  BINPOS is a column vector.
%   
%   HIST(FTS, NUMBINS) calculates and displays the histogram of the 
%   data series contained in the FINTS object, FTS.  It uses NUMBINS
%   number of bins.
%
%   FTSHIST = HIST(FTS, NUMBINS) calculates the histogram of the data 
%   series in the FINTS object FTS.  It does not display the plot/chart 
%   as in the first syntax.  It uses NUMBINS number of bins.  FTSHIST 
%   is a structure with fieldnames similar to the data series names of 
%   the object FTS.
%
%   [FTSHIST, BINPOS] = HIST(FTS, NUMBINS) does exactly the same as 
%   above with the addition of returning the bin positions BINPOS.  
%   The positions are the centers of each bins.  BINPOS is a column 
%   vector.
%   
%   See also HIST, FINTS/HIST, FINTS/MEAN.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8.2.1 $   $Date: 2003/01/16 12:50:58 $

% If the object is of an older version, convert it.
if fintsver(ftsin) == 1
    w = warning('off');
    ftsin = ftsold2new(ftsin); % This sorts the fts too.
    warning(w);
elseif ~issorted(ftsin)
    ftsin = sortfts(ftsin);
end

if nargin == 1
    nbins = 10;
end

switch nargout
case 0
    hist(fts2mat(ftsin), nbins);
case 1
    nno = hist(fts2mat(ftsin), nbins);
    if size(fts2mat(ftsin), 2) == 1
        nno = nno';
    end
    for idx = 4:length(ftsin.names)-1
        eval(['no.', ftsin.names{idx}, ' = nno(:, idx-3);']);
    end
case 2
    [nno, xxo] = hist(fts2mat(ftsin), nbins);
    if size(fts2mat(ftsin), 2) == 1
        nno = nno';
        xxo = xxo';
    end
    for idx = 4:length(ftsin.names)-1
        eval(['no.', ftsin.names{idx}, ' = nno(:, idx-3);']);
    end
    xo = xxo;
end

% [EOF]