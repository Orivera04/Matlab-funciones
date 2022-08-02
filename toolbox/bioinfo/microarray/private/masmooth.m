function c = masmooth(varargin)
%MASMOOTH  Helper function for MALOWESS.

%   See Curvefitting Toolbox for more options.

%   Copyright 2001-2004 The MathWorks, Inc. 
%   $Revision: 1.2.4.3 $  $Date: 2004/01/24 09:19:13 $

if nargin < 1
    error('Bioinfo:MAsmoothNeedMoreArgs',...
        'MASMOOTH needs at least one argument.');
end

% is x given as the first argument?
if nargin==1 || ( nargin > 1 && (length(varargin{2})==1 || ischar(varargin{2})) )
    % smooth(Y) || smooth(Y,span,...) || smooth(Y,method,...)
    is_x = 0; % x is not given
    y = varargin{1};
    y = y(:);
    x = (1:length(y))';
else % smooth(X,Y,...)
    is_x = 1;
    y = varargin{2};
    x = varargin{1};
    y = y(:);
    x = x(:);
end

% is span given?
span = [];
if nargin == 1+is_x || ischar(varargin{2+is_x})
    % smooth(Y), smooth(X,Y) || smooth(X,Y,method,..), smooth(Y,method)
    is_span = 0;
else
    % smooth(...,SPAN,...)
    is_span = 1;
    span = varargin{2+is_x};
end

% is method given?
method = [];
if nargin >= 2+is_x+is_span 
    % smooth(...,Y,method,...) || smooth(...,Y,span,method,...)
    method = varargin{2+is_x+is_span};
end

if isempty(method)
    if abs(diff(diff(x))<eps)
        method = 'moving'; % uniformly distributed X.
    else
        method = 'lowess';
    end
end

t = length(y);
if length(x) ~= t
    error('Bioinfo:MAsmoothXYmustBeSameLength',...
        'X and Y must be the same length.');
end

% realize span
if span <= 0, 
    error('Bioinfo:MAsmoothSpanMustBePositive', ...
        'SPAN must be positive.'); 
end
if span < 1, 
    span = ceil(span*t); 
end % percent convention
if isempty(span), 
    span = 5; 
end % smooth(Y,[],method)

idx = 1:t;

sortx = any(diff(isnan(x))<0);   % if NaNs not all at end
if sortx || any(diff(x)<0) % sort x
    [x,idx] = sort(x);
    y = y(idx);
end

c = NaN + zeros(size(y));
ok = ~isnan(x);
switch method

    case {'lowess','loess','rlowess','rloess'}
        robust = 0;
        iter = 5;
        if method(1)=='r'
            robust = 1;
            method = method(2:end);
            if nargin >= 3+is_x+is_span
                iter = varargin{3+is_x+is_span};
            end
        end
        c(ok) = lowess(x(ok),y(ok),span, method,robust,iter);

    otherwise
        error('Bioinfo:MAsmoothUnrecognizedMethod', ...
            'Unrecognized method.');
end

c(idx) = c;
%--------------------------------------------------------------------
function c = lowess(x,y, span, method, robust,iter)
% LOWESS  Smooth data using Lowess or Loess method.
% 
% The difference between LOWESS and LOESS is that LOWESS uses a
% linear model to do the local fitting whereas LOESS uses a
% quadratic model to do the local fitting. Some other software
% may not have LOWESS, instead, they use LOESS with order 1 or 2 to
% represent these two smoothing method.
% Reference: "Trimmed resistant weighted scatterplot smooth" by
% Matthew C Hutcheson.

n = length(y);
span = floor(span);
span = min(span,n);
if span <= 0
    error('Bioinfo:MAsmoothInvalidSpan',...
        'Span must be an integer between 1 and length of x.');
end
if span == 1, c = y; return; end

c = zeros(size(y));

% pre-allocate space for lower and upper indices for each fit
lbound = [];
rbound = [];
dmaxv = [];
if robust
    lbound = zeros(n,1);
    rbound = zeros(n,1);
    dmaxv = zeros(n,1);
end

useLoess = false;
if isequal(method,'loess')
    useLoess = true;
end

ws = warning('off','MATLAB:divideByZero');
warning('off','MATLAB:rankDeficientMatrix');

ynan = isnan(y);
anyNans = any(ynan(:));
%anyNans = true;
seps = sqrt(eps);
theDiffs = [1; diff(x);1];

for i=1:n
    % if x(i) and x(i-1) are equal we just use the old value.
    if theDiffs(i) == 0
        c(i) = c(i-1);
        if robust
            lbound(i) = lbound(i-1);
            rbound(i) = rbound(i-1);
            dmaxv(i) = dmaxv(i-1);
        end
        continue;
    end
    % calculate how far we have to look on either side
    left = max(1,i-span+1);
    right = min(n,i+span-1);
    % now see if we have any equal values that we need to take into account
    while left > 0 && theDiffs(left) == 0
        left = left-1;
    end
    while right <= n && theDiffs(right+1) == 0
        right = right+1;
    end
    
    mx = x(i);       % center around current point to improve conditioning
    % look at the span interval around x(i) 
    d1 = abs(x(left:right)-mx);
    [dsort,idx] = sort(d1);
    idx = idx +left-1;  % add back left value
    
    if anyNans
        idx = idx(dsort<=dsort(span) & ~ynan(idx));
    else
        idx = idx(dsort<=dsort(span));
    end
    
    if isempty(idx)
        c(i) = NaN;
        continue
    end
    x1 = x(idx)-mx;
    y1 = y(idx);
    dsort = d1(idx-left+1);

    dmax = dsort(end);
    
    if dmax==0, dmax = 1; end
    if robust
        lbound(i) = min(idx);
        rbound(i) = max(idx);
        dmaxv(i) = dmax;
    end
    
    weight = (1 - (dsort/dmax).^3).^1.5; % tri-cubic weight
    if all(weight<seps)
        weight(:) = 1;    % if all weights are 0, just skip weighting
    end
    
    v = [ones(size(x1)) x1];
    if useLoess
        v = [v x1.*x1];
    end
    
    v = weight(:,ones(1,size(v,2))).*v;
    y1 = weight.*y1;
    if size(v,1)==size(v,2)
        % Square v may give infs in the \ solution, so force least squares
        b = [v;zeros(1,size(v,2))]\[y1;0];
    else
        b = v\y1;
    end
    c(i) = b(1);
end

% now that we have a non-robust fit, we can compute the residual and do
% the robust fit if required
maxabsyXeps = max(abs(y))*eps;
if robust
    for k = 1:iter
        r = y-c;
        for i=1:n
            if i>1 && x(i)==x(i-1)
                c(i) = c(i-1);
                continue;
            end
            if isnan(c(i)), continue; end
            idx = lbound(i):rbound(i);
            if anyNans
                idx = idx(~ynan(idx));
            end
            x1 = x(idx);
            mx = x(i);
            x1 = x1-mx;
            dsort = abs(x1);
            y1 = y(idx);
            r1 = r(idx);
            
            weight = (1 - (dsort/dmaxv(i)).^3).^1.5; % tri-cubic weight
            if all(weight<seps)
                weight(:) = 1;    % if all weights 0, just skip weighting
            end
            
            v = [ones(size(x1,1),size(x1,2)) x1];
            if useLoess
                v = [v x1.*x1];
            end
            r1 = abs(r1-median(r1));
            mad = median(r1);
            % if mad > max(abs(y))*eps
            if mad > maxabsyXeps 
                rweight = r1./(6*mad);
                id = (rweight<=1);
                rweight(~id) = 0;
                rweight(id) = (1-rweight(id).*rweight(id));
                weight = weight.*rweight;
            end
            v = weight(:,ones(1,size(v,2))).*v;
            y1 = weight.*y1;
            if size(v,1)==size(v,2)
                % Square v may give infs in the \ solution, so force least squares
                b = [v;zeros(1,size(v,2))]\[y1;0];
            else
                b = v\y1;
            end
            c(i) = b(1);
        end
    end
end
warning(ws);


