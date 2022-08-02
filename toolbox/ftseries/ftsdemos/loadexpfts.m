%
% Demo file - LOADEXPFTS: Loading and Building FinTS object.....
%
%   This script M-file loads example financial time series objects 
%   into the MATLAB Workspace.  It either loads 1 (one) long Dow 
%   Jones Industrial Open, Close, High, and Low prices or 4 (four) 
%   short time series objects which are excerpts from the long one.
%   The short ones are data from the months March 1994, April 1994, 
%   May 1994, and June 1994.
%
%   If you choose to load one long data series, you have an object 
%   named 'fts' in the workspace.  (Use the 'whos' command to see 
%   what items are in the workspace.)
%
%   However, if you choose to load the short ones, you will get a 
%   cell array that contains 4 (four) objects.  See MATLAB User's 
%   Guide on how to work with cell arrays; in short, it is similar 
%   to indexing into a matrix or array but use '{' and '}' (curly 
%   braces) instead of parentheses ('(' and ')').
%

%   Author(s); P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 2002/01/21 12:18:29 $

whichfile = input('(L)ong/(S)hort data file?', 's');

dtfile = {};
dtdesc = {};
if lower(whichfile) == 'l',
   dtfile{1} = 'dji30.dat';
   dtdesc{1} = 'djia30';
   disp('*** Loading LONG dji30 file ***');
   numfiles = 1;
elseif lower(whichfile) == 's',
   dtfile{1} = 'dji30mar94.dat';
   dtfile{2} = 'dji30apr94.dat';
   dtfile{3} = 'dji30may94.dat';
   dtfile{4} = 'dji30jun94.dat';
   dtdesc{1} = 'dji30mar94.dat';
   dtdesc{2} = 'dji30apr94.dat';
   dtdesc{3} = 'dji30may94.dat';
   dtdesc{4} = 'dji30jun94.dat';
   disp('*** Loading SHORT dji30 files ***');
   numfiles = 4;
else
   error('Please choose either (L)ong or (S)hort time series to load...');
end

fts = cell(numfiles, 1);
for nfi = 1:numfiles;
   [dates, open, high, low, close]=textread(dtfile{nfi}, '%s %f %f %f %f', ...
                                                    'headerlines', 2);
   fts{nfi} = fints(dates, [open, high, low, close], ...
                           {'Open', 'High', 'Low', 'Close'}, 1, dtdesc{nfi});
   if numfiles == 1,
      fts = fts{1};
   end
end

clear dates open high low close dtdesc dtfile nfi numfiles whichfile



