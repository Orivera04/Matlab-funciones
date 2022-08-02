function numdays = days360(d1,d2)
%DAYS360 Days between dates based on a 360 day year. (SIA compliant)
%   This function returns the number of days between two dates given a
%   basis of 30/360.
%
%   NumberDays = days360(StartDate, EndDate)
%
% Inputs: 
%   StartDate - Nx1 or 1xN vector or scalar value, in either serial date
%     number or date string form, representing the start date
%   EndDate - Nx1 or 1xN vector or scalar value, in either serial date
%     number or date string form, representing the end date
%
% Outputs: 
%   NumberDays - Nx1 or 1xN vector or scalar value for the number of
%     days between two dates
%
% Example: 
%   StartDate = '28-Feb-1994';
%   EndDate = '1-Mar-1994';
%
%   NumberDays = days360(StartDate, EndDate);
%
%   returns:
%
%   NumberDays = 1
%
% See also DAYS365, DAYSACT, DAYSDIF.

%Author(s): C.F. Garvin, 2-23-95; C. Bassignani, 10-17-97; Bob Winata 1-18-02 
%       Copyright 1995-2003 The MathWorks, Inc.
%$Revision: 1.13.2.2 $   $Date: 2004/04/06 01:06:24 $ 

% this is SIA compliant

if nargin < 2 
    error('Please enter StartDate and EndDate.');
end

if nargin > 2
    error('Too many input arguments - Type "help days360" for more information');
end

% check size and "pad" rest of values if input is scalar.

d1 = datenum(d1);
d2 = datenum(d2);

sz1 = length(d1);
sz2 = length(d2);

if sz1 ~=1 & sz2 ~=1
    if sz1 ~= sz2
        error('Size mismatch between the two date vector')
    end
end

if sz1 == 1 
     d1 = d1*ones(sz2,1);
end

if sz2 == 1 
     d2 = d2*ones(sz1,1);
end

d1 = datenum(d1);
d2 = datenum(d2);


%SIA index preprocessing

d1vec = datevec(d1);
d2vec = datevec(d2);

ind4a = find(rem(d1vec(:,1),4)==0); %find leap years in first argument
ind4b = find(rem(d2vec(:,1),4)==0); %find leap years in second argument
ind4c = find(rem(d1vec(:,1),4)~=0); %find non-leap years in first argument
ind4d = find(rem(d2vec(:,1),4)~=0); %find non-leap years in second argument

ind4e = find(d1vec(:,2)==2); %month is feb in first argument
ind4f = find(d2vec(:,2)==2); %month is feb in second argument

ind4g = intersect(ind4e,ind4a); % month is feb and leap in first argument
ind4h = intersect(ind4e,ind4c); % month is feb and non-leap in first argument
ind4i = intersect(ind4f,ind4b); % month is feb and leap in second argument
ind4j = intersect(ind4f,ind4d); % month is feb and non-leap in second argument

ind4k = find(d1vec(:,3) == 28); % date is 28th on first argument
ind4l = find(d1vec(:,3) == 29); % date is 29th on first argument
ind4m = find(d2vec(:,3) == 28); % date is 28th on second argument
ind4n = find(d2vec(:,3) == 29); % date is 29th on second argument

%find all dates == 28 (if nonleap) | 29 (if leap) in month == 2 in first argument
ind4 = [intersect(ind4h, ind4k); intersect(ind4g, ind4l)]; 

%find all dates == 28 (if nonleap) | 29 (if leap) in month == 2 in second argument
ind4o = [intersect(ind4j, ind4m); intersect(ind4i, ind4n)]; 

% find all dates == 28 (if nonleap) | 29 (if leap) when month == 2 in
% second argument given day == 28 (if nonleap) |29 (if leap) and month ==2
% in first
ind5 = [intersect(ind4,ind4o)]; 

% if month == 2 and date == 28|29 in second argument 
% while month ==2 and date == 28|29 in first argument

d2vec(ind5,3) = 30;

% if month == 2 and date ==28|29 in first argument

d1vec(ind4,3) = 30;

% find all dates == 31 in second argument
ind2 = find(d2vec(:,3)==31); 

%find all dates == 30|31 in first argument given date == 31 in second argument 
ind3 = [find(d1vec(:,3)==30); find(d1vec(:,3)==31)]; 
ind3a = intersect(ind2,ind3);

% if date == 31 in second argument and date == 30 | 31 in first, 
% change date == 30 in second argument
d2vec(ind3a,3) = 30;

ind1 = find(d1vec(:,3)==31); % find all dates == 31 in first argument

% if date == 31 in first argument change it to date == 30 in first argument

d1vec(ind1,3) = 30;

numdays = ...
    360*(d2vec(:,1)-d1vec(:,1)) + 30*(d2vec(:,2)-d1vec(:,2)) + (d2vec(:,3)-d1vec(:,3));