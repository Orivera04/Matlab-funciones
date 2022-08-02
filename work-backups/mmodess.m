function [tn,yn,ypn,stats]=mmodess(yprime,t,y,yp)
%MMODESS Single Step ODE Solution, 4-5th Order. (MM)
% [T,Y,YP,STATS]=MMODESS(yprime,t,y,yp) integrates the system
% of first order differential equations computed in the
% M-file yprime(t,y) from the time point t where y = y(t)
% and yp = yprime(t,y). yprime(t,y) must return a column vector.
%
% [T,Y,YP,STATS] are the results at the integrator chosen time T>t,
% where Y=Y(T), YP=yprime(T,Y), and STATS is a vector of statistics:
% STATS=[IERR FAIL ORDER] where IERR identifies the variable Y(IERR)
% which dominated the error in the step, FAIL is the number of failed steps
% encountered in this integration step and ORDER is the order
% of the accepted solution. Order is 2, 3, or 5.  
% T is scalar, Y and YP are ROW vectors.
%
% Integration parameters must be initialized by MMODEINI.
% Typical usage:
%                mmodeini default
%                t=0;           % initial time
%                y=[y1;y2;...]; % initial condition column vector
%                yp=feval('yprime',t,y); % initial derivatives
%                while test
%                    [t,y,yp]=mmodess('yprime',t,y,yp);
%                    % process data
%                end
%
% See also MMODEINI, MMODE45, MMODE45P, MMODECHI.

% Uses the Runge-Kutta Method Parameters given in:
% J.R. Cash and A.H. Harp, ACM Trans. on Math. Software
% vol. 16, no. 3, pp. 201-222, 1990.
% See also: L.F. Shampine, Numerical Solution of Ordinary
% Differential Equations, Chapman and Hall, 1994.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/8/96, revised 7/10/96, 11/1/96, 12/16/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMODE_Rtol MMODE_Atol MMODE_Hmin MMODE_Hmax
global MMODE_SF MMODE_GL MMODE_SL MMODE_FB
global MMODE_A MMODE_B MMODE_H
global MMODE_5 MMODE_5E MMODE_3 MMODE_3E MMODE_2 MMODE_2E

fail=0; % number of failed tries
yi=y(:);
f=zeros(length(yi),6);

if isempty(MMODE_H) % first call, guess a stepsize
   ypm=max(abs(yp),eps);
   MMODE_H=MMODE_SF*min(abs((MMODE_Rtol*abs(yi)+MMODE_Atol)./ypm)).^0.2;
end
h=MMODE_H;                       % get step size to try
f(:,1)=yp(:);  % slopes at t

while 1  % advance one step
   h=min(max([h;MMODE_Hmin;16*eps*t]),MMODE_Hmax); % limit stepsize
   hA=MMODE_A*h;
   hB=MMODE_B*h;
   f(:,2)=feval(yprime,t+hA(1),yi+f*hB(:,1));
   f(:,3)=feval(yprime,t+hA(2),yi+f*hB(:,2));
   f(:,4)=feval(yprime,t+hA(3),yi+f*hB(:,3));
   f(:,5)=feval(yprime,t+hA(4),yi+f*hB(:,4));
   f(:,6)=feval(yprime,t+hA(5),yi+f*hB(:,5));
   tn=t+h;  % prospective solution
   yn=yi+h*f*MMODE_5;
   
   yerr=abs(h*f*MMODE_5E);                           % compute errors
   ytol=MMODE_Rtol*max(abs(yi),abs(yn))+MMODE_Atol;  % tolerances
   [err,ierr]=max(yerr-ytol);                        % worst variable
   err=max(yerr(ierr),eps);                          % worst error
   tol=ytol(ierr);                                   % worst tolerance
   hratio=MMODE_SF*(tol/err)^0.2;
   
   if err<=tol   % 4/5 order step worked
      if ~fail  % find new step size only if no failure
         MMODE_H=h*min(MMODE_GL,hratio);
      else
         MMODE_H=h; % retain last successful step size
      end
      ypn=feval(yprime,tn,yn)';
      yn=yn';
      stats=[ierr fail 5];
      return
   elseif MMODE_FB    % step failed, check 2/3 order step at t+3h/5
      if h<=max(MMODE_Hmin,16*eps*t)
         error(sprintf('Hmin reached: Step Failure at t = %.4g.',t))
      end
      tn=t+3*h/5;  % prospective solution
      yn=yi+h*f*MMODE_3;
      
      yerr=abs(h*f*MMODE_3E);                           % compute errors
      ytol=MMODE_Rtol*max(abs(yi),abs(yn))+MMODE_Atol;  % tolerances
      [err,ierr]=max(yerr-ytol);                        % worst variable
      err=max(yerr(ierr),eps);                          % worst error
      tol=ytol(ierr);                                   % worst tolerance
      if err<=tol  % 2/3 order solution works
         MMODE_H=3*h/5;
         ypn=feval(yprime,tn,yn)';
         yn=yn';
         stats=[ierr fail 3];
         return
      else         % step failed, check 1/2 order solution at t+h/5
         tn=t+h/5;  % prospective solution
         yn=yi+h*f*MMODE_2;
         
         yerr=abs(h*f*MMODE_2E);                     % compute errors
         ytol=MMODE_Rtol*max(abs(yi),abs(yn))+MMODE_Atol;  % tolerances
         [err,ierr]=max(yerr-ytol);                        % worst variable
         err=max(yerr(ierr),eps);                          % worst error
         tol=ytol(ierr);                                   % worst tolerance
         if err<=tol  % 1/2nd order solution works
            MMODE_H=2*h/5;
            ypn=feval(yprime,tn,yn)';
            yn=yn';
            stats=[ierr fail 2];
            return
         else  % all fall backs fail go back to order 4/5
            fail=fail+1;
            h=h*min(max(MMODE_SL,hratio),0.5);
         end
      end
   else % try a new stepsize at order 4/5
      if fail==0  % first failure, get a new step size
         fail=1;
         h=h*max(MMODE_SL,hratio);
      else      % multiple failure, so just cut step in half
         fail=fail+1;
         h=h/2;
      end
   end
end
