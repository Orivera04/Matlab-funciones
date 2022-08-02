function [Max, Min] = max_min(x,disp)
%MAX_MIN   Get extremes of series
%
%   Syntax:
%      [MAX,MIN] = MAX_MIN(X,DISP)
%
%   Inputs:
%      X      Vector to analyse
%      DISP   Show result in a plot (new figure) [ {0} | 1 ]
%
%   output:
%      MAX   Maximums structure with fields .i .val .iabs .abs
%            (indices, values, indice of absolute maximum, absolute
%            maximum)
%      MIN   Minimums structure with fields .i .val .iabs .abs
%            (indices, values, indice of absolute minimum, absolute
%            minimum)
%
%   Example:
%      x=[2 2 1 1 1 2 3 1 .5 1 1 1 .5 .5 .5 .7 .1 1 1 1 ];
%      [Max, Min]=max_min(x,1);
%      legend('x','max','min','abs max','abs min')
%
%   MMA 11-12-2002, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   15-07-2003 - Works with nan (i=1)

if nargin == 1
  disp=0;
end

iMax=1; % to deal with NaNs
iMin=1;

n=length(x);
if  ~(n > 1)
  return
end
cmax=0;
cmin=0;

% at start:
if x(1) >= x(2)
  cmax=cmax+1;
  iMax(cmax)=1;
end
if x(1) <= x(2)
  cmin=cmin+1;
  iMin(cmin)=1;
end
% internal:
for i=2:n-1
  if x(i-1) <= x(i) & x(i+1) <= x(i)
    cmax=cmax+1;
    iMax(cmax)=i;
  end
  if x(i-1) >= x(i) & x(i+1) >= x(i)
    cmin=cmin+1;
    iMin(cmin)=i;
  end
end
% at end:
if x(end) >= x(end-1)
  cmax=cmax+1;
  iMax(cmax)=n;
end
if x(end) <= x(end-1)
  cmin=cmin+1;
  iMin(cmin)=n;
end
%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
[a,b]=max(x);
iabs_max=find(x==a);
abs_max=x(iabs_max);

[a,b]=min(x);
iabs_min=find(x==a);
abs_min=x(iabs_min);

%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% build output:

Max.i    = iMax;
Max.val  = x(iMax);
Max.iabs = iabs_max;
Max.abs  = x(iabs_max);

Min.i    = iMin;
Min.val  = x(iMin);
Min.iabs = iabs_min;
Min.abs = x(iabs_min);

%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% graphics:
if disp
  figure
  plot(x,'-+')
  hold on
  plot(Max.i,Max.val,'r*')    % maximums
  plot(Min.i,Min.val,'bo')    % minimums
  plot(Max.iabs,Max.abs,'r^') % absolute maximum
  plot(Min.iabs,Min.abs,'b^') % absolute minimum
end
