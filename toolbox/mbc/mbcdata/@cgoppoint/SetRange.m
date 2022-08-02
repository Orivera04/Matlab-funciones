function [p,range,x,z,t] = SetRange(p,ind,smooth,thresh,numpoints)
% p = SetRange(p)
%       Calculate the internal range.  This is used, together with tolerance,
%        to display the data in 2 or 3 dimensions and to fill tables.
%       A normalised data distribution is calculated, and smoothed to blend
%        close data points.  Peaks in the distribution above a threshold are
%        deemed to represent the range.
% p = SetRange(p,ind)
%       Set range for factor indexed by ind.  ind may be 'all'.
% p = SetRange(p,ind,smooth,thresh,numpoints)
%      Smooth sets the width of the smoothing function as a
%        number of normalised points (default 10).
%      Thresh sets the detection threshold, in percent of data distribtion.
%        By default, or if thresh is empty, threshold is set to include all
%        points not blended by smoothing.
%      Numpoints sets the resolution.  Below this resolution it is not possible
%        to distinguish individual data points.  Default is 1000 points over
%        the range of data.
% [p,range] = SetRange(p,...) returns the range of p as a cell array.
% [p,range,x,z,t] = SetRange(...) returns the data distribution of the last factor calculated.
%        t returns threshold value actually used.
%
% See also: SetTolerance

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:21 $

if nargin<2 | (ischar(ind) & strcmp(lower(ind),'all'))
    ind = 1:length(p.ptrlist);
end
if nargin<3 | isempty(smooth)
    smooth = 15; 
end
if nargin<4, thresh = []; end
if nargin<5 | ~isnumeric(numpoints) | length(numpoints)~=1
    numpoints = 1000; 
end
numpoints = max(numpoints,10);
smooth = min(numpoints,max(smooth,0.5));

if ~all(ismember(ind,1:length(p.ptrlist)))
    error('SetRange: bad index into factors');
end
    
data = p.data;

range = get(p,'range');
for factornum = ind
    if isempty(data) 
        thisdata = [];
    else 
        thisdata = data(:,factornum);
    end
    [range{factornum},x,z,t] = i_SetRange(thisdata,smooth,thresh,numpoints);
end
p = set(p,'range',range);

%-------------------------------------------------
function [range,xn,z,t] = i_SetRange(data,smooth,thresh,numpoints)
%-------------------------------------------------
res = 1./numpoints;
x = 0:res:1;
if isempty(data) | any(isnan(data(:)) | isinf(data(:)))
    out = [];
    xn = [-1 0 1]; z = [0 0 0];
    t = 0.01;
else
    mindata = min(data);
    diffdata = max(data)-min(data);
    if diffdata<eps
        diffdata = 2;
        mindata = mindata - 1;  %constant
    end
    numpts = length(data);
    wt = 1./numpts;
    norm = (data-mindata)./(diffdata); %normalise data
    n = histc(norm,x).*wt;
    if isempty(thresh)
        ntmp = n(find(n));
        findwt = min(ntmp).*0.5;    %include all data by default
        findwt = max(findwt,0.01);     %but don't go below 1%
    else
        findwt = thresh./100;   %convert from percent
        findwt = min(100,max(findwt,0));     %but don't go outside 0-100%
    end
    
    %set up a gaussian for smoothing
    y = -0.5:res:0.5;
    sig = smooth.*res./2;
    g = exp(-(y.*y)./(2.*(sig.^2)));
    %smooth
    z = conv(n,g);
    discard = round((length(y)-1)./2);  %extra length due to convolving with gaussian
    z = z(discard+1:end-discard);
    
    f = find(z>findwt);
    mx = []; ind = [];
    
    if ~isempty(f)
        f2 = find(diff(f)~=1);
        ei = [f(f2) f(end)];
        si = [f(1) f(f2+1)];   %+1 will alwats be okay, since we've done a diff(f)
    
        for i = 1:length(si)
            section = z(si(i):ei(i));
            [mx(i),ind(i)] = max(section);
        end
        ind = ind+si-1;

        out = x(ind).*(diffdata) + mindata;    %back to real units
    else
        out = [];
    end
    if nargout>1
        xn = x.*(diffdata) + mindata;  %back to real units
    end
    t = findwt.*100;
end
range = out;
