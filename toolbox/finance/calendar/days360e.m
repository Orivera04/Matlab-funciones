function numdays = days360E(d1,d2)
% DAYS360E Days between dates based on a 360 day year. (European)
%   This function returns the number of days between two dates given a
%   basis of 30/360 based on European convention.
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
%   NumberDays = days360e(StartDate, EndDate);
%
%   returns:
%
%   NumberDays = 3
%
% See also DAYS360SIA, DAYS360PSA, DAYS365, DAYSACT, DAYSDIF.
%
%Author(s): Bob Winata 1-18-02 
%       Copyright 1995-2002 The MathWorks, Inc.
%$Revision: 1.2.8.2 $   $Date: 2004/04/06 01:06:25 $ 

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


%SIA/PSA index preprocessing

d1vec = datevec(d1);
d2vec = datevec(d2);

ind1 = find(d1vec(:,3)==31); % find all dates == 31 in first argument
ind2 = find(d2vec(:,3)==31); % find all dates == 31 in second argument

% if date == 31 in first argument change it to date == 30 in first argument

d1vec(ind1,3) = 30;

% if date == 31 in second argument , change it to date == 30 in second argument

d2vec(ind2,3) = 30;

numdays = 360*(d2vec(:,1)-d1vec(:,1)) + 30*(d2vec(:,2)-d1vec(:,2)) + (d2vec(:,3)-d1vec(:,3));