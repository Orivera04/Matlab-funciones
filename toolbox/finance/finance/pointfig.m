function pointfig(asset)
%POINTFIG Point and figure chart.
%   POINTFIG(ASSET) plots a point and figure chart for given data, ASSET.
%   Upward price movements are plotted as X's and downward price
%   movements are plotted as O's.
%
%   See also HIGHLOW, CANDLE, MOVAVG, BOLLING.

%       Author(s): C.F. Garvin, 3-02-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:50 $

if nargin < 1
  error('Missing ASSET.')
end

[r,c] = size(asset);
asset = round(asset);
k = 1;
marker = 'x';
color = 'g';
inc = 1;
plot(k,asset(1),[color,marker],'linewidth',2)
hold on
if asset(2) > asset(1)
elseif asset(2) < asset(1)
  k = k+1;
  marker = 'o';
  color = 'r';
  inc = -1;
end
plot(k*ones(size(asset(1)+inc:inc:asset(2))),asset(1)+inc:inc:asset(2),[color,marker],'linewidth',2)
for i = 3:max([r;c])
  if (asset(i) > asset(i-1) & asset(i-1) >= asset(i-2) & marker == 'x')
    plot(k*ones(size(asset(i-1)+1:asset(i))),asset(i-1)+1:asset(i),[color,marker],'linewidth',2)
  elseif (asset(i) > asset(i-1) & asset(i-1) <= asset(i-2))
    k = k+1;
    color = 'g';
    marker = 'x';
    plot(k*ones(size(asset(i-1)+1:asset(i))),asset(i-1)+1:asset(i),[color,marker],'linewidth',2)
  elseif (asset(i) < asset(i-1) & asset(i-1) <= asset(i-2) & marker == 'o')
    plot(k*ones(size(asset(i-1)-1:-1:asset(i))),asset(i-1)-1:-1:asset(i),[color,marker],'linewidth',2)
  elseif (asset(i) < asset(i-1) & asset(i-1) >= asset(i-2))
    k = k+1;
    color = 'r';
    marker = 'o';
    plot(k*ones(size(asset(i-1)-1:-1:asset(i))),asset(i-1)-1:-1:asset(i),[color,marker],'linewidth',2)
  end
end
hold off
