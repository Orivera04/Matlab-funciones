function [T,Y]=mmode45(yprime,tspan,yo,int)
%MMODE45 ODE Solution Using 4-5 Order MMODESS. (MM)
% [T,Y]=MMODE45(YPRIME,TSPAN,Y0,INT,TSTOP) integrates the system of first
% order differential equations computed by the function YPRIME(t,y)
% starting from the initial conditions Y0, using the time data in TSPAN.
% YPRIME is a function handle or a function M-file.
%
% When TSPAN = [T0 TFINAL] the differential equations are integrated
% from time T0 through TFINAL, using integrator chosen time points.
%
% When TSPAN = [T0 T1 T2 ... TFINAL] the solution is returned at the given
% time points by interpolating the integrator chosen time points as 
% necessary using MMODECHI.
%
% If INT is given and nonempty and TSPAN = [T0 TFINAL], the integrator 
% returns interpolated solution points at INT number of points within each
% integrator chosen time step. For example, INT=1 returns one interpolated
% point using MMODECHI at the midpoint between each pair of integrator chosen
% time points.
%
% [T,Y] are the results where T is a vector of time points and Y is a
% matrix having length(T) rows where the (i)th row of Y is the solution
% at the time T(i).
% 
% Integration parameters must be initialized by MMODEINI.
%
% See also MMODEINI, MMODESS, MMODE45P, MMODECHI.

% Calls: mmodess mmodechi

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/10/96, modified 9/10/96, v5: 1/14/97, 2/25/97, 6/10/97, 2/25/01
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ischar(yprime)
   ypstr=yprime;
elseif isa(yprime,'function_handle')
   ypstr=func2str(yprime);
else
   error('Inline objects not supported.')
end
T=tspan(:);
tlen=length(T);
if nargin==3, int=0; end
if isempty(int), int=0; else, int=max(round(int),0); end
y=yo(:)';
ylen=length(y);

if tlen==2  % TSPAN = [T0 TFINAL] case
   if tspan(2)<tspan(1)
      error('TFINAL < T0 not allowed.')
   end
   chunk=128;  % make output array in chunks for speed
   T=zeros(chunk,1);
   Y=zeros(chunk,ylen);
   k=1;  % place initial conditions in outputs
   T(k)=tspan(1); Y(k,:)=y;
   t=tspan(1);  % initial data
   yp=feval(yprime,t,y');
   if size(yp,2)>1
      error(['Function >> ' ypstr ' << Must Return a Column.'])
   end
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
         kend=k+1+int;
         if kend>length(T)  % allocate more room for results
            T=[T; zeros(chunk,1)];
            Y=[Y; zeros(chunk,ylen)];
         end
         i=k+1:kend;     % indices to fill
         T(i)=[ti;t];    % poke in time points
         Y(i,:)=[yi;y];  % poke in solution
         k=kend;         % last index filled
      end		
   else  % noninterpolated solution
      while t<tspan(2)  % integrate
         if 1.1*mmodeini('NextStep')>=tspan(2)-t % jump to end if close
            mmodeini('NextStep',tspan(2)-t)
         end
         [t,y,yp]=mmodess(yprime,t,y,yp);
         k=k+1;
         if k>length(T)  % allocate more room for results
            T=[T; zeros(chunk,1)];
            Y=[Y; zeros(chunk,ylen)];
         end
         T(k)=t;
         Y(k,:)=y;
      end
   end
   T=T(1:k);  % return only filled data
   Y=Y(1:k,:);
   
else  % TSPAN = [T0 T1 T2 ... TFINAL] case
   if any(diff(T)<=0)
      error('TSPAN Must be Strictly Increasing.')
   end
   Y=zeros(tlen,ylen);
   Y(1,:)=y;  % place initial conditions in output
   t=T(1);    % initial data
   yp=feval(yprime,t,y);
   if size(yp,2)>1
      error(['Function >> ' ypstr ' << Must Return a Column.'])
   end
   k=2;  % next index to fill
   while k<=tlen  % integrate to fill output arrays
      while t<T(k)  % loop until pass next output point
         t0=t;y0=y;yp0=yp;  % first interpolation point
         [t,y,yp]=mmodess(yprime,t,y,yp);
      end		
      t1=t;y1=y;yp1=yp;  % next interpolation point
      i=find(T>t0 & T<=t1);  % time interp indices
      ilen=length(i);
      Y(k:k+ilen-1,:)=mmodechi(t0,y0,yp0,t1,y1,yp1,T(i));
      k=i(ilen)+1;  % next index to fill
   end
end
