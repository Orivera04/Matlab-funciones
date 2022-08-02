function [sfts, sidx] = sortfts(varargin)
%@FINTS/SORTFTS sorts a FINTS object contents.
%
%   SFTS = SORTFTS(FTS) sorts the FINTS object, FTS, based on the 'dates' vector  
%   in a monotonically increasing order if there is no time information. If
%   there is time information, SORTFTS(FTS) sorts the FINTS object based on the
%   combination of the 'dates' and 'times' vectors. The result is returned in
%   another FINTS object SFTS.
%
%   SFTS = SORTFTS(FTS, SERIESNAMES) sorts the FINTS object FTS in a
%   monotonically increasing order based on the data series name(s) SERIESNAMES.
%   SERIESNAMES can be a single string of a data series name or a cell array of
%   a list of data series names. The result is returned in another FINTS object
%   SFTS. Please note that the 'times' vector cannot be sorted individually.  
%
%   SFTS = SORTFTS(FTS, DIRFLAG) sorts the FINTS object FTS based on the 'dates' 
%   and/or 'dates' and 'times' vector in the order specified by DIRFLAG.
%   DIRFLAG = +1 indicates increasing order while DIRFLAG = -1 denotes decreasing
%   order. The result is returned in another FINTS object SFTS.
%
%   SFTS = SORTFTS(FTS, SERIESNAMES, DIRFLAG) sorts the FINTS object FTS based on 
%   the data series name(s) SERIESNAMES in the order specified by DIRFLAG.  
%   SERIESNAMES can be a single string of a data series name or a cell array of a 
%   list of data series names.  DIRFLAG = +1 indicates increasing order while 
%   DIRFLAG = -1 denotes decreasing order.  The result is returned in another 
%   FINTS object SFTS.  
%
%   [SFTS, SIDX] = SORTFTS( ... ) will also take one, two, or three input arguments 
%   like the above with the addition of returning the index of the original object 
%   FTS sorted based on 'dates' or specified data series name(s).
%
%   See also SORT and SORTROWS.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.7 $   $Date: 2002/04/14 16:31:08 $

% Determine object version and convert to new version when necessary
[ftsVersion,timeData] = fintsver(varargin{1});
if ftsVersion == 1
    w = warning('off');
    varargin{1} = ftsold2new(varargin{1});
    warning(w);
end

% Parse the input argument(s).
switch nargin
case 1   % sortfts(FTS);
    ftsa = varargin{1};
    
    % If time data exists, dates will represent 'dates and times'
    srsnames = 'dates';   % Sort by 'dates' or 'dates and times'.
    
    dir = 1;              % 0 = Increasing order.
case 2   % sortfts(FTS, SERIESNAMES); or sortfts(FTS, DIRFLAG);
    ftsa = varargin{1};
    switch class(varargin{2})
    case 'cell'
        srsnames = varargin{2};
      dir = 1;                    % 0 = Increasing order.
   case 'char'
      srsnames = varargin{2};
      if size(srsnames, 1) ~= 1
         error('Ftseries:sortfts:OneStringAtATimeOrUseCellArr', ...
             'Please enter one sting at a time. For a list, please use a cell array.');
      end
      dir = 1;                    % 0 = Increasing order.
   case 'double'
      srsnames = 'dates';
      dir = varargin{2};
   end
case 3   % sortfts(FTS, SERIESNAMES, DIRFLAG);
   ftsa = varargin{1};
   switch class(varargin{2})
   case 'cell'
      srsnames = varargin{2};
      dir = 1;                    % 0 = Increasing order.
   case 'char'
      srsnames = varargin{2};
      if size(srsnames, 1) ~= 1
         error('Ftseries:sortfts:OneStringAtATimeOrUseCellArr', ...
             'Please enter one sting at a time. For a list, please use a cell array.');
      end
      dir = 1;                    % 0 = Increasing order.
   case 'double'
      error('Ftseries:sortfts:SERIESNAMEMustBeStr', ...
          'SERIESNAMES must be a string or a cell array.');
   end
   dir = varargin{3};
otherwise
    error('Ftseries:sortfts:ThreeInputsMax', ...
        'SORTFTS takes maximum of 3 input arguments.');
end

% Find the specified column names; if any doesn't exist, give error.
% Do not allow times to work.
if strcmp(srsnames,'times') == 1
    error('Ftseries:sortfts:TimesCannotBeSorted', ...
        'Times cannot be sorted individually.');
end
nameidx = getnameidx(ftsa.names, srsnames);
if any(~nameidx)
    error('Ftseries:sortfts:SeriesNonExistent', ...
        'One or more of the series names do not exist.');
end

% Make sure that DIRFLAG is -1 (decreasing) or +1 (increasing).
if (dir ~= -1) & (dir ~= 1)
   error('Ftseries:sortfts:DIRFLAGinvalid', ...
       'DIRFLAG must be either -1 or +1.');
end

% Make a big matrix containing the dates and the data.
if timeData == 0
    % No time data
    bigmtx = [ftsa.data{3} ftsa.data{4}];
else
    % There is time data
    bigmtx = [(ftsa.data{3}+ftsa.data{5}) ftsa.data{4}];
end

% Sort the big matrix.  The big matrix is multiplied by DIRFLAG.  So, to achieve 
% decreasing order, we are sorting negative numbers in increasing order. 
[yy, ii] = sortrows(dir.*bigmtx, nameidx-2);


% Assign output.  Remultiply the matrix with DIRFLAG before assigning to output 
% to get the correct result.
sfts = ftsa;
sfts.data{1} = ftsa.data{1};
sfts.data{4} = dir.*yy(:,2:end);

% Separate the date from the time
[year,month,day,hour,min,sec] = datevec(yy(:,1));

% Find where any 'sec' = 60 and leave it the same. 
% This prevents rounding errors
roundedS = round(sec);
loc60 = find(roundedS == 60);
sec = zeros(length(year),1);
sec(loc60) = 60;

colZeros = zeros(length(year),1);
onlyDates = datenum([year,month,day,colZeros,colZeros,colZeros]);
onlyTimes = datenum([colZeros,colZeros,colZeros,hour,min,sec]);

if timeData == 0
    % No time data
    sfts.data{3} = dir.*yy(:,1);
    sfts.data{4} = dir.*yy(:,2:end);
else
    % There is time data
    sfts.data{3} = dir.*(onlyDates);
    sfts.data{5} = dir.*(onlyTimes);
end

% Return the new order with reference to the original object order.
sidx = ii;

% [EOF]
