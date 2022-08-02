function bd = busdate(d, direc, hol, weekend)
%BUSDATE Next or previous business day.
%
% BD = BUSDATE(D,DIREC,HOL,WEEKEND) 
%
% Inputs:
%
%   D       - A reference business date.
%
% Optional Inputs:
%
%   DIREC   - specifies the search direction:
%             next (DIREC = 1, default) or previous (DIREC = -1)  
%
%   HOL     - a vector of non-trading day dates. If HOL is 
%             not specified the non-trading day data is 
%             determined by the routine, HOLIDAYS.
%             At this time we support NY holidays in HOLIDAYS.
%
%   WEEKEND - a vector of length 7, 
%             containing 0 and 1, with
%             the value of 1 to indicate weekend day(s). 
%             The first element of this vector corresponds 
%             to Sunday. 
%             Thus, when Saturday and Sunday are weekend
%             then WEEKEND = [1 0 0 0 0 0 1]. The default
%             is Saturday and Sunday weekend.
%
% Outputs:
%
%  BD       - Next or previous business day, depending on HOL.
%  
%  For example, bd = busdate('3-jul-1997',1) returns bd = 729578 which 
%  is the serial date corresponding to July 7, 1997.  
%
%  See also HOLIDAYS, ISBUSDAY. 
       
%  Author(s): C.F. Garvin, 10-31-95
%  Copyright 1995-2004 The MathWorks, Inc.
%  $Revision: 1.9.2.3 $   $Date: 2004/04/06 01:06:19 $

if nargin < 1
  error('Finance:busdate:invalidInputs', ...
      'Please enter date, D.')
end

if nargin < 2 | isempty(direc)
  direc = 1;
end

if nargin < 3 | isempty(hol)
  hol = holidays;
end

if nargin < 4 | isempty(weekend)
    weekend = [1 0 0 0 0 0 1];
end

Isdirec = find(direc ~= 1 & direc ~= -1);
if (~isempty(Isdirec))
     error('Finance:busdate:invalidDirection', ...
         'DIREC should have a value of 1 or -1.')
end

if isstr(d)
  dt = datenum(d);
  [row1,col1] = size(dt);      % need size of date for later reshape
else
  [row1,col1] = size(d);
  dt = d(:);
end
if isstr(hol)
  h = datenum(hol);
else
  h = hol(:);
end

[row2,col2] = size(direc);      % need size of direc for later reshape

direc = direc(:);
if max(size(dt))==1, dt = dt(ones(size(direc)));end  % scalar expansion
if max(size(direc))==1, direc = direc(ones(size(dt)));end

rng = 1:7;                            % numbers to be added to dates
rng = rng(ones(length(direc),1),:);   % expand rng for vectorization
[rr,cr] = size(rng);                 
direc = direc(:,ones(1,cr));          % expand direc for vectorization
mat = rng.*direc;                     % date projection based on direc
newdt = dt(:,ones(1,cr));             % expand dt for vectorization
total = newdt+mat;                    % create new dates 
ind = isbusday(total,h,weekend);      % find valid business days
diffmat = newdt-total;                % difference between dt and new dates
diffmat = abs(diffmat);             
nonday = find(~ind);                  % index of non-business days
diffmat(nonday) = (1e+8)*ones(size(nonday));  % set nondays to large numbers
[row,col] = size(dt);
genind = 0:7:7*(row-1);                       % create index into new dates
in = genind+min(diffmat');                    % get min values in new dates
dm = diffmat';                                % transpose for use with in
t = total';
bd = reshape(t(in),max([row1 col1;row2 col2])); % find nearest days and resize
