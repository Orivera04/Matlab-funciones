function n = fdatenum(arg1,arg2,arg3,h,min,s)
% FDATNUM: FDATNUM is a much Faster version of DATENUM  
% when the input is a string array and very large. The fastness benefits 
% from another program of mine, FDATEVEC, which in turn befenfits from 
% FSTRFIND and DIVCONQ. Sp make sure you download all them before using 
% this function.  You can call FDATENUM in the same way as you call DATENUM. 
%
% Also see FSTR2NUM, FDATEVEC, FDATE_DEMO, DIVCONQ which are all 
% downloadable from the same place as this function.
%
% Zhigang Xu, xuz@dfo-mpo.gc.ca, Sept. 17, 2003

%DATENUM Serial date number.
%   N = DATENUM(S) converts the string S into a serial date number.
%   Date numbers are serial days where 1 corresponds to 1-Jan-0000.
%   The string S must be in one of the date formats 0,1,2,6,13,14,
%   15,16,23 (as defined by DATESTR). Date strings with 2 character 
%   years are interpreted to be within the 100 years centered around  
%   the current year.
%
%   N = DATENUM(S,PIVOTYEAR) uses the specified pivot year as the
%   starting year of the 100-year range in which a two-character year
%   resides.  The default pivot year is the current year minus 50 years.
%
%   The input can be a string array or a cell array of strings; the
%   resulting output is a column vector of date numbers.
%
%   N = DATENUM(Y,M,D) and N = DATENUM([Y,M,D]) return the serial date
%   numbers for corresponding elements of the Y,M,D (year,month,day) arrays.
%   Y, M, and D must be arrays of the same size (or any can be a scalar).
%
%   N = DATENUM(Y,M,D,H,MI,S) and N = DATENUM([Y,M,D,H,MI,S]) return the
%   serial date numbers for corresponding elements of the Y,M,D,H,MI,S
%   (year,month,hour, minute,second) arrays.  The six arguments must
%   be arrays of the same size (or any can be a scalar).  Values outside
%   the normal range of each array are automatically carried to the next
%   unit (for example month values greater than 12 are carried to years).
%   Month values less than 1 are set to be 1; all other units can wrap 
%   and have valid negative values.
%
%   Examples:
%       n = datenum('19-May-2000') returns n = 730625.
%       n = datenum(2001,12,19) returns n = 731204.
%       n = datenum(2001,12,19,18,0,0) returns n = 731204.75.
%
%   See also NOW, DATESTR, DATEVEC, DATETICK.

%   Copyright 1984-2001 The MathWorks, Inc. 
%   $Revision: 1.22 $  $Date: 2001/04/15 12:03:25 $

switch nargin
   case 1, if isstr(arg1) | iscell(arg1)
              n = datenummx(fdatevec(arg1));
           elseif (size(arg1,2)==3) | (size(arg1,2)==6)
              n = datenummx(arg1);
           else
              n = arg1;
           end
   case 2, n = datenummx(fdatevec(arg1,arg2));
   case 3, n = datenummx(arg1,arg2,arg3);
   case 6, n = datenummx(arg1,arg2,arg3,h,min,s);
   otherwise, error('Incorrect number of arguments')
end

