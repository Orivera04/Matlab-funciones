function [m, cost ,OK] = cheapwidthopt(m,x,y);
% use fminsearch to find the optimal single global width using the existing centers and lambda

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:28 $


wid0 = m.width;
if size(wid0,1) == 1
   % set up the options
   fopts= optimset(optimset('fminsearch'),'display','iter');

   % Nelder Meade
   wid= fminsearch(@i_widthsearchcostfn,wid0,fopts,m,x,y);
elseif size(wid0,1) > 1
   warning('Cheap width algorithm has not been run')
   cost = get(getFitOpt(m),'cost');
   OK = 0;
   return
end
m.width= wid;

[m,OK] = leastsq(m,x,y);
cost = log10(calcGCV(m));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cost=i_widthsearchcostfn(wid,m,x,y)

m.width = wid;
% least squares fit
[m,OK]= leastsq(m,x,y);
cost = calcGCV(m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%