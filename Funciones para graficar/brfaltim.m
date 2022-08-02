function [tfall,xbrac,ybrac]=brfaltim ...
                             (a,b,grav,npts)
%
% 
% [tfall,xbrac,ybrac]=brfaltim(a,b,grav,npts)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 
% This function determines the descent time 
% and a set of points on the brachistochrone 
% curve passing through (0,0) and (a,b). 
% The curve is a cycloid expressible in 
% parametric form as
%
%    x=k*(th-sin(th)), 
%    y=k*(1-cos(th))    for 0<=th<=thf
%
% where thf is found by solving the equation
%
%    b/a=(1-cos(thf))/(thf-sin(thf)). 
%
% Once thf is known then k is found from 
%
%    k=a/(th-sin(th)). 
%
% The exact value of the descent time is given 
% by
%
%    tfall=sqrt(k/g)*thf
%  
% a,b   - final values of (x,y) on the curve
% grav  - the gravity constant
% npts  - the number of points computed on 
%         the curve
%
% tfall - the time required for a smooth 
%         particle to to slide along the curve 
%         from (0,0) to (a,b)
% xbrac - x points on the curve with x 
%         increasing to the right
% ybrac - y points on the curve with y 
%         increasing downward           
%
% User m functions called: none
%----------------------------------------------

brfn=inline('cos(th)-1+cof*(th-sin(th))','th','cof');
 
ba=b/a; [th,fval,flag]=fzero(...
                 brfn,[.01,10],optimset('fzero'),ba);

k=a/(th-sin(th)); tfall=sqrt(k/grav)*th;
if nargin==4
  thvec=(0:npts-1)'*(th/(npts-1));
  xbrac=k*(thvec-sin(thvec)); 
  ybrac=k*(1-cos(thvec));
end