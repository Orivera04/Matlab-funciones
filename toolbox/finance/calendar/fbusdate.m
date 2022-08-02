function d = fbusdate(y,m,hol,weekend)
%FBUSDATE First business date of month.
%
% D = FBUSDATE(Y,M,HOL,WEEKEND) 
%
% Inputs:
%
%   Y   - Year
%         Example: 2002
%
%   M   - Month
%         Example: 12 (meaning December)
%
% Optional Inputs:
%
%   HOL - a vector of non-trading day dates. If HOL is 
%         not specified the non-trading day data is 
%         determined by the routine, HOLIDAYS.
%         At this time we support NY holidays in HOLIDAYS.
%
%   WEEKEND - a vector of length 7, 
%         containing 0 and 1, with
%         the value of 1 to indicate weekend day(s). 
%         The first element of this vector corresponds 
%         to Sunday. 
%         Thus, when Saturday and Sunday are weekend
%         then WEEKDAY = [1 0 0 0 0 0 1]. The default
%         is Saturday and Sunday weekend.
% 
% Outputs:
%
%   D  - The first business day of the month(s) specified.
% 
%        For example, d = fbusdate(1997,11) returns d = 729697 
%        which is the serial date corresponding to November 03, 1997.
%
%        See also BUSDATE, EOMDATE, HOLIDAYS, ISBUSDAY, LBUSDATE.

%  Author(s): C.F. Garvin, 11-14-95 Bob Winata 12-12-02
%  Copyright 1995-2003 The MathWorks, Inc.
%  $Revision: 1.8.2.2 $   $Date: 2004/04/06 01:06:29 $

if nargin < 3 | isempty(hol)
   hol = holidays;
end

if nargin < 4 | isempty(weekend)
    weekend = [1 0 0 0 0 0 1];
end

if nargin < 2
  error('Please enter year, Y, and month, M.')
end

if any(any(m > 12 | m < 1)) 
  error('M must be greater than 0 and less than 13.') 
end 

if length(y)==1;y = y(ones(size(m)));end        % scalar expansion
if length(m)==1;m = m(ones(size(y)));end
if checksiz([size(y);size(m)],mfilename)
  return
end

ld = eomday(y,m);                               % Last day of each month
num_ld = length(ld(:));                         % Number of dates input
date_grid = ones(num_ld,31);                    % Initialize matrix
for i = 1:num_ld 
   yr = y(i);mn = m(i);                         % Get each year and month
   date_grid(i,1:ld(i)) = datenum(yr,mn,1):datenum(yr,mn,ld(i));  % Fill rows
end
nb_ind = find(~isbusday(date_grid,hol,weekend));        % Find non-business days
date_grid(nb_ind) = (1e+7)*ones(size(nb_ind));  % Eliminate non-business days
d = reshape(min(date_grid')',size(ld));         % Find first business days
