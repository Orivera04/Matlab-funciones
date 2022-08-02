function [xc,termcode]=mmfminu(varargin)
%MMFMINU Minimize a Function of Several Variables. (MM)
% [Xf,TermCode]=MMFMINU(FUN,Xo,Options,P1,P2,...)
% tries to find a vector X that is a local minimizer of FUN(X) starting from
% the initial guess Xo, passing optional parameters P1,P2,... to FUN.
% FUN is a function handle or a function M-file that evaluates FUN(X,...).
% Options is an optional structure that defines algorithm behavior.
% If Options is empty, default Options are used.
%
% Options=MMFMINU('Name',Value,...) set values in Options structure based
% on the Name/Value pairs:
% Name        Values  {default} Description
% 'Display'   ['on' {'off'}]    Display Iteration Information
% 'XRelTol'   {1e-4}            Relative Error Tolerance in X
% 'FRelTol'   {1e-4}            Relative Error Tolerance in FUN(X)
% 'Gradient'  {'finite'}        Finite Difference Gradient
% 'Gradient'   'GNAME'          Analytic Gradient in GNAME.M
% 'Hessian'   {'fun'}           |FUN(Xo)|*Identity Initial Hessian
% 'Hessian'    'eye'            Identity Initial Hessian
% 'Hessian'     H0              Matrix H0 is Initial Hessian
% 'MaxIter'   {100}             Maximum number of iterations
%
% Options=MMFMINU(Options,'Name','Value',...) updates the Options structure
% with new parameter values.
%
% Xf = final approximation
% TermCode = termination code:
%            1 = normal return, 2 = change in X too small
%            3 = line search failure, 4 = too many iterations

% Reference: "Numerical Methods for Unconstrained Optimization and
% Nonlinear Equations," by Dennis and Schnabel,
% Siam's Classics in Applied Mathematics, no. 16, (2)nd printing 1996.

% G. Smith and D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/6/97, 2/25/01
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMFMINU_ITER

if nargin==1 & strcmp('default',varargin(1))  % set default parameters
   xc.Display='off';
   xc.XRelTol=1e-4;
   xc.FRelTol=1e-4;
   xc.Gradient='finite';
   xc.Hessian='fun';
   xc.MaxIter=100;
   return
end
if isstruct(varargin{1}) % check if Options=MMFMINU(Options,'Name','Value',...)
   if ~isfield(varargin{1},'FRelTol')
      error('Options Structure not Correct for MMFMINU.')
   end
   xc=varargin{1};
   for i=2:2:nargin-1
      name=varargin{i};
      if ~ischar(name), error('Parameter Names Must be Strings.'), end
      name=lower(name(isletter(name)));
      value=varargin{i+1};
      if     strncmp(name,'d',1), xc.Display=value;
      elseif strncmp(name,'x',1), xc.XRelTol=value(1);
      elseif strncmp(name,'f',1), xc.FRelTol=value(1);
      elseif strncmp(name,'g',1), xc.Gradient=value;
      elseif strncmp(name,'h',1), xc.Hessian=value;
      elseif strncmp(name,'m',1), xc.MaxIter=value(1);
      else   disp(['Unknown Parameter Name --> ' name])
      end
   end
   return
end
if ischar(varargin{1}) % check if Options=MMFMINU('Name',Value,...)
   Pnames=char('display','xreltol','freltol','gradient','hessian','maxiter');
   if ~isempty(strmatch(lower(varargin{1}),Pnames))
      xc=mmfminu('default');
      xc=mmfminu(xc,varargin{:});
      return
   end
end
% MMFMINU('FUN',Xo,Options,P1,P2,...)

FUN=varargin{1};
if ~(isvarname(FUN) | isa(FUN,'function_handle'))
   error('FUN Must be a Function Handle or M-file Name.')
end
xo=varargin{2};
if nargin>2, options=varargin{3};
else         options=mmfminu('default');
end
if nargin>3, P=varargin(4:nargin);
else         P={};
end

xc=xo(:);
n=length(xc);
fxc=feval(FUN,xc,P{:});
MMFMINU_ITER=1;
if strcmp(options.Hessian,'eye')
   H=eye(n);
elseif strcmp(options.Hessian,'fun')
   H=abs(fxc)*eye(n);
elseif isnumeric(options.Hessian)
   H=options.Hessian;
   if any(size(H)~=n)
      error(sprintf('Hessian Must Be %.0f-by-%.0f.',[n;n]))
   end
else
   error('Unknown Initial Hessian Specified.')
end

%----~ Initialize Variables ~----
msg=['None     ';'Quadratic';'Cubic    '];
gxc=zeros(n,1);
gxplus=gxc;
steptol=eps^(2/3)/2;
termcode=0;
count=0;
g_step=sqrt(eps);
anal_grad= ~strcmp(options.Gradient,'finite');
disp_on=strcmp(options.Display,'on');
search_fail=0;
IAq=[-1 1 -1;0 0 1;1 0 0];


%----~ Initialize Gradient ~----
if anal_grad
   gxc(:)=feval(options.Gradient,xc,P{:});
else
   p=xc;
   delta=g_step*(xc+(xc==0));
   for i=1:n   
      p(i)=p(i)+delta(i);   
      gxc(i)=(feval(FUN,p,P{:})-fxc)/delta(i);
      MMFMINU_ITER=MMFMINU_ITER+1;
      p(i)=xc(i);
   end   
end
if disp_on
   if n<8
      disp('Initial Hessian:')
      disp(H)
   end
   disp('Initial Gradient:')
   disp(gxc')
   disp('count    FUN(X)')
   fprintf(' %2.0f     %.8g    Initial Condition\n',count,fxc)
end
%----~ Iterative Body ~----
while termcode==0
   msgidx=1;
   Sdir=-H\gxc;                   % search direction
   xplus=xc+Sdir;
   fxplus=feval(FUN,xplus,P{:});  % lambda=1 trial
   MMFMINU_ITER=MMFMINU_ITER+1;
   GD=gxc'*Sdir;
   
   if fxplus>(fxc+1e-4*GD) % backtrack line search required
      
      xprev=xplus;                     % lambda=1 point that failed
      fxprev=fxplus;                   % FUN(xplus)
      lxprev=1;                        % old and first lambda
      q=IAq*[fxc;fxplus;GD];           % quadratic interpolation
      lambda=-q(2)/(2*q(1));           % lambda where minimum occurs
      lxplus=min(max(lambda,0.1),0.5); % bound lambda: 0.1<lambda<0.5
      xplus=xc+lxplus*Sdir;            % tentative new point
      fxplus=feval(FUN,xplus,P{:});    % FUN(xplus)
      MMFMINU_ITER=MMFMINU_ITER+1;
      msgidx=2;
      
      while fxplus>(fxc+1e-4*lambda*GD) & search_fail==0 % continue line search
         % xc,    fxc:                     X and FUN(X) for lambda = 0
         % xplus, fxplus, lxplus:  lambda, X and FUN(X) at most current point
         % xprev, fxprev, lxprev:  lambda, X and FUN(X) at previous point
         
         tmp=[(fxplus-fxc)/lxplus;(fxprev-fxc)/lxprev]-GD;
         q=[lxplus^2 lxplus;lxprev^2 lxprev]\tmp; % cubic interpolation
         a=q(1);b=q(2);
         
         if abs(a)<=eps                % cubic is really quadratic
            lambda=GD/(2*b);
         else                          % cubic is fine
            lambda=(-b+real(sqrt(b^2-3*a*GD))/(3*a));
         end
         lxprev=lxplus; xprev=xplus; fxprev=fxplus;  % move values back
         lxplus=min(max(lambda,lxplus/10),lxplus/2); % new lambda (limited)
         xplus=xc+lxplus*Sdir;                       % new xplus
         fxplus=feval(FUN,xplus,P{:});               % new fxplus
         MMFMINU_ITER=MMFMINU_ITER+1;
         if lxplus<steptol/max(abs(Sdir)), search_fail=1; end
         
         msgidx=3;
      end
   end % end of backtrack
   
   %----~ Get Next Gradient ~----   
   if anal_grad
      gxplus(:)=feval(options.Gradient,xplus,P{:});
   else
      p=xplus;
      delta=g_step*(xplus+(xplus==0));
      for i=1:n   
         p(i)=p(i)+delta(i);   
         gxplus(i)=(feval(FUN,p,P{:})-fxplus)/delta(i);
         MMFMINU_ITER=MMFMINU_ITER+1;
         p(i)=xplus(i);
      end   
   end
   %----~ Update Hessian ~----
   y=gxplus-gxc;
   s=xplus-xc;
   if s'*y>g_step*norm(s)*norm(y) % update if acceptable data
      H=H+(y*y')/(y'*s)-(H*s*s'*H)/(s'*H*s);
   end
   %----~ Check Termination ~----
   if abs(fxplus-fxc)<options.FRelTol*max(abs(fxplus),abs(fxc)) & ...
         max(abs(Sdir))<options.XRelTol*max(abs(xplus),abs(xc))
      termcode=1;
   elseif max(abs(s))<steptol
      termcode=2;
   elseif search_fail==1
      termcode=3;
   elseif count==options.MaxIter
      termcode=4;
   end
   %----~ Increment ~----
   xc=xplus;
   gxc=gxplus;
   fxc=fxplus;
   count=count+1;
   if disp_on
      disp('count     FUN(X)     Line Search')
      fprintf(' %2.0f     %.8g    %s\n',count,fxc,msg(msgidx,:))
   end
end
if disp_on
   switch termcode
   case 1, disp('Successful Solution.')
   case 2, disp('Change in X Too Small.')
   case 3, disp('Line Search Failure.')
   case 4, disp('Too Many Iterations.')
   end
end
