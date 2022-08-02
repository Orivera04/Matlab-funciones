function [P0,y0,h,err,P,Y] = grads(Fn,Gn,P0,max1,delta,epsilon,show)
%---------------------------------------------------------------------------
%GRADS   Gradient search for a minimum.
% Sample call
%   [P0,y0,h,err,P,Y] = grads('Fn','Gn',P0,max1,delta,epsilon,1)
% Inputs
%   Fn        name of the vector function
%   Gn        gradient for Fn
%   P0        starting point
%   max1      maximum number of iterations
%   delta     convergence tolerance for the independent variables
%   epsilon   convergence tolerance for the dependent variable
%   show      if show==1 the iterations are displayed
% Return
%   P0        point V0 for the minimum
%   y0        function value  Fn(V0)
%   h         minimum step size
%   err       error  estimate
%   P         matrix containing the iterations
%   Y         vector containing the iterations
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 8.4, (Steepest Descent  or Gradient Method).
% Section	8.1, Minimization of a Function, Page 418
%---------------------------------------------------------------------------

if nargin==5, show = 0; end
if show==1,
    Mx1 = 'Gradient search iteration';
    Mx2 = '      p         q       f(p,q)';
	clc;
	y0 = feval(Fn,P0);
    diary output,disp(' '),disp(' '),....
	disp(Mx1),disp(Mx2),disp(' '),disp([P0,y0]),diary off;
end
[mm n] = size(P0);
maxj = 20;
big = 1e8;
h = 1;
len = norm(P0);
y0 = feval(Fn,P0);
if (len>1e4), h = len/1e4; end
err = 1;
cnt = 0;
cond = 0;
P(1,:) = P0(1,:);
Y(1,:) = y0(1,:);
while (cnt<max1 & cond~=5 & (h>delta | err>epsilon))
  S = feval(Gn,P0); echo off;
  P1 = P0 + h*S;
  P2 = P0 + 2*h*S;
  y1 = feval(Fn,P1);
  y2 = feval(Fn,P2);
  cond = 0;
  j = 0;
  while (j<maxj & cond==0)
    len = norm(P0);
    if (y0<y1),
      P2 = P1;
      y2 = y1;
      h = h/2;
      P1 = P0 + h*S;
      y1 = feval(Fn,P1);
    else
      if (y2<y1),
        P1 = P2;
        y1 = y2;
        h = 2*h;
        P2 = P0 + 2*h*S;
        y2 = feval(Fn,P2);
      else
        cond = -1;
      end
    end
    j = j+1;
    if (h<delta), cond=1; end
    if (abs(h)>big | len>big), cond=5; end
  end
  if (cond==5),
    Pmin = P1;
    ymin = y1;
  else
    d = 4*y1 - 2*y0 - 2*y2;     % Start of a long block:
    if (d<0),
      hmin = h*(4*y1-3*y0-y2)/d;
    else
      cond = 4;
      hmin = h/3;
    end
    Pmin = P0 + hmin*S;
    ymin = feval(Fn,Pmin);
    h0 = abs(hmin);
    h1 = abs(hmin-h);
    h2 = abs(hmin-2*h);
    if (h0<h), h = h0; end
    if (h1<h), h = h1; end
    if (h2<h), h = h2; end
    if (h==0), h = hmin; end
    if (h<delta), cond=1; end
    e0 = abs(y0-ymin);
    e1 = abs(y1-ymin);
    e2 = abs(y2-ymin);
    if (e0~=0 & e0<err), err = e0; end
    if (e1~=0 & e1<err), err = e1; end
    if (e2~=0 & e2<err), err = e2; end
    if (e0==0 & e1==0 & e2==0), err = 0; end
    if (err<epsilon), cond=2; end
    if (cond==2 & h<delta), cond=3; end
  end     % End of the long block.
  cnt = cnt+1;
  P0 = Pmin;
  y0 = ymin;
  P(cnt+1,:) = P0(1,:);
  Y(cnt+1) = y0;
  if show==1,
    Mx1 = 'Gradient search iteration No. ';
    Mx2 = '      p         q       f(p,q)';
    diary output,disp([P0,y0]),diary off;
    hold on;
	plot([P(cnt,1),P(cnt+1,1)],[P(cnt,2),P(cnt+1,2)],'g');	
    plot(P0(1),P0(2),'or');
	hold off;
	figure(gcf);
  end
end
