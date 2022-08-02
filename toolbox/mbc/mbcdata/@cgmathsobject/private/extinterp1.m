function Zi = extinterp1(X,Y,xi)
%EXTINTERP1 Quick 1-D linear interpolation (extends interp1q)
%
%  F = EXTINTERP1(X,Y,XI) returns the value of the 1-D function Y at the
%  points XI using linear interpolation and extrapolation outside the
%  bounds. Length(F) is equal to length(XI).  The vector X specifies the
%  coordinates of the underlying interval.
%   
%  If Y is a matrix, then the interpolation is performed for each column of
%  Y in which case F is length(XI)-by-size(Y,2).

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:50:04 $

% If inputs aren't valid then set output to nan
if any(isnan(xi(:))) || any(isnan(X(:))) || any(isnan(Y(:)))
    Zi = nan;
    return
end

if numel(Y)==1
    % When only a single point is defined, all output values are equal to
    % this input value
    Zi = Y.*ones(size(xi));
    return
end

% Make inputs into column vectors
[NR,NC] = size(xi);
X = X(:);
Y = Y(:);
xi = xi(:);

% Main code
xim = [xi , (1:length(xi))'];
xxim = sortrows(xim,1);
a = min(X);
b = max(X);
m = length(X);
if a<=xxim(1,1) && b>=xxim(length(xi),1)
    Zi = interp1q(X,Y,xi);
else
    xb = xxim(xxim(:,1)<a,:);
    xbt = xxim(xxim(:,1)>=a,:);
    xt = xbt(xbt(:,1)>b,:);
    xm = xbt(xbt(:,1)<=b,:);
    if ~isempty(xb);
        zb = (Y(2)-Y(1))/(X(2)-X(1))*(xb(:,1)-X(1)*ones(length(xb(1)),1))+Y(1);
    else 
        zb = [];
    end
    if ~isempty(xt);
        zt = (Y(m)-Y(m-1))/(X(m)-X(m-1))*(xt(:,1)-X(m)*ones(length(xt(1)),1))+Y(m);
    else
        zt = [];
    end
    if ~isempty(xm)
        zm = interp1q(X,Y,xm(:,1));
    else
        zm = [];
    end
    ZZi = [zb xb(:,2); zm xm(:,2); zt xt(:,2)];
    ZZs = sortrows(ZZi,2);
    Zi = ZZs(:,1);
 end
 
 Zi = reshape(Zi,[NR,NC]);
 