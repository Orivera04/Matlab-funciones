function [intercepts,p] = pointselect(D,data,t)
%POINTSELECT
%
%  [intercepts,p] = POINTSELECT(data,t) takes noisy, step-like digital data
%  and extracts information about the transition time of the step.
%
%  Data will be u(t), then output y(t)
%  Comparing step times will give estimate of delay in the system.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:59:01 $

% ensure intercepts can be returned
intercepts=[];

if nargin == 1
    % If called without t parameter generate from
    % data length
    data = t(:);
    t = 1:length(data);
end
data = data(:)';
t = t(:)';

% Normalise the data range
max_data = max(data);
min_data = min(data);
norm_data = (data - min_data)/(max_data - min_data);

% Calculate average of all points where norm_data is
% more than 75% or less than 25%
top = mean(data(norm_data > 0.75));
base = mean(data(norm_data < 0.25));

% Upper and lower selector levels based on the upper 75%
% and lower 25% data averages
u_select = 0.75*top;
l_select = 0.25*top;

% Find indicies to data in the upper and lower selection
% levels
l = find(data < l_select);
u = find(data > u_select);

% Calculate mean and standard deviations of the data in the
% upper and lower selection levels
um = mean(data(u));
us = std(data(u));
lm = mean(data(l));
ls = std(data(l));

% Number of data points used in s.d. calculation
nl = length(l);
nu = length(u);
% Calculated weighted average of s.d.
as = sqrt((nl*ls^2 + nu*us^2)/(nl+nu));
% Calculate 3 s.d.'s above lower mean and 3 below upper mean
dist = 3;
lb = lm+dist*as;
ub = um-dist*as;

% Find points more than 3 s.d.'s away from the mean's
p = find((data > lb) & (data < ub));
% Find the indicies into p where the difference in adjacent points
% is more than 1. These indicate new straight line portions of
% the data
breaks = [0 find(diff(p) > 1) length(p)];

% Now calculate polynomial coefficients for each set of lines
nl = 0;
for i = 1:length(breaks)-1
    % get the indicies into p that correspond to the line being
    % investigates currently
    vp = p(breaks(i)+1:breaks(i+1));
    % Make sure it has more than 3 points
    if length(vp) > 3
        % Increment the number of lines counter
        nl = nl+1;
        % Calculate 1st order polynomial fit
        coeff{nl} = polyfit(t(vp),data(vp),1);
        % Get points to plot fit line at
        pf{nl} = vp(1)-3:min(vp(end)+3,length(t));
        % Evaluate fit for plotting
        fit{nl} = polyval(coeff{nl},t(pf{nl}));
        % Calculate intercepts with the top and base lines
        intercepts(1,nl) = (base - coeff{nl}(2))/coeff{nl}(1);
        intercepts(2,nl) = (top - coeff{nl}(2))/coeff{nl}(1);
    end
end
