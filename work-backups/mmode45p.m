function [T,Y]=mmode45p(yprime,tspan,yo,lim,s,int)
%MMODE45P Plotted ODE Solution Using 4-5 Order MMODESS. (MM)
% MMODE45P(YPRIME,TSPAN,Y0,LIM,S,INT) integrates the system of first
% order differential equations computed by the function YPRIME(t,y)
% starting from the initial conditions Y0, using the time data in TSPAN.
% YPRIME is a function handle or a function M-file.
%
% Y*S is plotted versus time by MMPLOTI using the y-axis limits in 
% LIM = [Ymin Ymax], where Y is the solution ROW vector of length N and S
% is an N-by-P selection matrix where P is the number of variables to plot.
% For example, S=eye(N) plots all variables, and
% S=[1 0... 0 1]' plots the sum of first and last variables.
%
% TSPAN = [T0 TFINAL] identifies the integration interval, with the solution
% plotted at integrator chosen time points.
%
% If INT is given and nonempty, the integrator plots interpolated solution
% points at INT number of points within each integrator chosen time step. 
% For example, INT=1 plots one interpolated point using MMODECHI at the 
% midpoint between each pair of integrator chosen time points.
%
% If LIM = [Y1min Y1max Y2min Y2max] a phase plane plot is generated using
% the two selections in Y*S. That is, S must have P=2 columns.
% For example: S=[1 0;0 1;0 0;...] plots Y(2) vs. Y(1).
%
% Integration parameters must be initialized by MMODEINI.
%
% See also MMODEINI, MMODESS, MMODE45, MMODECHI.

% Calls: mmploti mmodess mmodechi

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/13/96, modified 9/10/96, v5: 1/14/97, 2/25/97, 6/10/97, 2/25/01
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<5, error('Not Enough Input Arguments.'), end
if nargin==5, int=0; end
if isempty(int), int=0; else, int=max(round(int),0); end

if ischar(yprime)
   ypstr=yprime;
elseif isa(yprime,'function_handle')
   ypstr=func2str(yprime);
else
   error('Inline objects not supported.')
end
y=yo(:)';
ylen=length(y);
[sr,sc]=size(s);
if ylen~=sr
   error('Length of Y and Rows of S Must be Equal.')
end
llim=length(lim);
if llim==4 & sc~=2
   error('Must Select Exactly Two Items for a Phase Plane Plot.')
end
if tspan(2)<tspan(1)
   error('TFINAL < T0 not allowed.')
end
t=tspan(1);  % initial data
yp=feval(yprime,t,y');
if size(yp,2)>1
   error(['Function >> ' ypstr ' << Must Return a Column.'])
end

if llim==2  % Time plot
   mmploti([tspan(1) tspan(2) lim(1) lim(2)])
   mmploti(t,y*s)  % plot initial conditions
   
   if int  % integrate and interpolate
      pts=linspace(0,1,int+2);
      pts=pts(2:int+1)';  % normalized interpolation points
      while t<tspan(2)  % integrate
         if 1.1*mmodeini('NextStep')>=tspan(2)-t % jump to end if close
            mmodeini('NextStep',tspan(2)-t)
         end
         t0=t;y0=y;yp0=yp;  % first point
         [t,y,yp]=mmodess(yprime,t,y,yp);  % one step
         ti=t0+pts*(t-t0); % actual interpolation points
         yi=mmodechi(t0,y0,yp0,t,y,yp,ti);  % interpolated solution
         mmploti([ti;t],[yi;y])
      end
   else    % no interpolation
      while t<tspan(2)  % integrate
         if 1.1*mmodeini('NextStep')>=tspan(2)-t % jump to end if close
            mmodeini('NextStep',tspan(2)-t)
         end
         [t,y,yp]=mmodess(yprime,t,y,yp);
         mmploti(t,y*s)
      end
   end
else        % Phase Plane plot
   mmploti(lim(1:4))
   ys=y*s;
   mmploti(ys(1),ys(2))  % plot initial conditions
   
   if int  % integrate and interpolate
      pts=linspace(0,1,int+2);
      pts=pts(2:int+1)';  % normalized interpolation points
      while t<tspan(2)  % integrate
         t0=t;y0=y;yp0=yp;  % first point
         [t,y,yp]=mmodess(yprime,t,y,yp);  % one step
         ti=t0+pts*(t-t0); % actual interpolation points
         yi=mmodechi(t0,y0,yp0,t,y,yp,ti);  % interpolated solution
         ys=[yi;y]*s;
         mmploti(ys(:,1),ys(:,2))
      end
   else    % no interpolation
      while t<tspan(2)  % integrate
         [t,y,yp]=mmodess(yprime,t,y,yp);
         ys=y*s;
         mmploti(ys(1),ys(2))
      end
   end
end
mmploti('done')
