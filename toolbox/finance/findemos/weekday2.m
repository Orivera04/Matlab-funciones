function vec=weekday2(start,stop);
%WEEKDAY2 Creates a vector of working days from start to stop dates.
%
%   WeekDayVec = weekdays(StartDate, StopDate) returns a vector of weekdays,
%   WeekDayVec, between the starting date, StartDate, and end date, StopDate.
%   The WeekdayVec is a vector of serial dates.
%
%   Note: This function is the same as WEEKDAYS except implemented differently.
%           

% Design reference: A042, Cambridge Control Limited
% --------------------------------------------------------
% Version Control
% ---------------
% $Id: weekday2.m,v 1.6 2002/04/14 21:45:34 batserve Exp $
% ---------------------------------------------------------

%	Author(s): Dave Maclay, Cambridge Control, 12/15/97 
%  Editor: P. N. Secakusuma, The MathWorks, Inc., 05/06/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%	$Revision: 1.6 $ $Date: 2002/04/14 21:45:34 $ 

% weekday2.m - Generates a vector of working days
% 					between start and stop dates.

daystr = datestr(start, 8);
switch daystr 
   case 'Mon', day=1;
   case 'Tue', day=2;
   case 'Wed', day=3;
   case 'Thu', day=4;
   case 'Fri', day=5;
   case 'Sat', day=1; start=start+2;
   case 'Sun', day=1; start=start+1; 
   otherwise, fprintf('Err-day not recognized\n');
end 

vec=[];
j=1; i=start;
while i<=stop
   vec(j,1)=i;
   j=j+1; i=i+1; day=day+1;
   if day>5
      day=1;
      i=i+2;
   end
end
