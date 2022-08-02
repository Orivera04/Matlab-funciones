function varargout= weibul(U,x,varargin)
%WEIBUL Template for user defined functions
%
%  WEIBUL implements the Weibul local model in the Model Browser.  This
%  file can be used as a template for writing your own user-defined models,
%  however this file should not be altered as it will cause the Weibul
%  model to be altered and it may no longer work in the Model Browser.
%
%  The calling syntax function is VARARGOUT= WEIBUL(U,X,VARARGIN).
%   
%  To use this function the command:
%
%    U2= checkin(xregusermod,'weibul',xtest)
%
%  must be run. The last argument is a column based input matrix to
%  test the function.
%
%  See also XREGUSERMOD/CHECKIN.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.7.2.2 $  $Date: 2004/02/09 08:01:46 $

% don't change this section of code
b= double(U);
if isa(x,'double')
   % shortcut for fast eval 
   
   % function definition
   % make sure this is vectorised
   y = b(1) - (b(1)-b(2)).*exp(-(b(3).*x).^b(4));
   %y=b(1)./(1+exp(-b(3)*(x-b(2))));
   
   m= x>0;
   y(~m)=NaN;

   % this line must not be changed
   varargout{1}= y;
else
   % x specifies what sub- function to evaluate
   % prefix function name by i_
   [varargout{1:nargout}]= feval(['i_',lower(x)],U,b,varargin{:});
end


% The user must specify the folowing functions
% see xregusermod/weibul for an example

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mandatory functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% n= i_numparams(U,b,varargin);
% n= i_nfactors(U,b,varargin);
% [param,OK]= i_initial(U,b,X,Y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optional functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% i_jacobian(U,b,X)              % analytic jacobian
% i_foptions(U,b,fopts)          % optimisation parameters
% [LB,UB,A,c,nlcon,optparams]= i_constraints(U,b,X,Y)  % define parameter constraints
% g= i_nlconstraints(U,b,X,Y)    % evaluate nonlinear constraints
% str= i_char(U,b)               % display string for function
% str= i_str_func(U,b)           % one line summary of function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optional local regresion functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% names= i_rfnames(U,b)                 % response feature evaluation
% [rf,dG]= i_rfvals(U,b)                % response feature evaluation
% p= i_reconstruct(U,b,Yrf,dG,rfuser)   % local model reconstruction

% sub functions begin here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mandatory functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------------------------------------
% i_nfactors number of input factors 
%---------------------------------------------------------------
function n= i_nfactors(U,b,varargin);
% you must specify this 
n= 1;
%---------------------------------------------------------------
% i_numparams number of parameters 
%---------------------------------------------------------------
function n= i_numparams(U,b,varargin);

% you must specify this or initial
n= 4;

%---------------------------------------------------------------
% i_initial initial parameter values
%---------------------------------------------------------------
function [param,OK]= i_initial(U,b,X,Y)
 
if nargin>2
   % data dependent initial parameter values
   OK=1;
   
   Y=double(Y);
   X=double(X);
   
    yok= Y>0;
    Y= Y(yok);
    X= X(yok,:);
   
	 if ~isempty(Y)

         % Initial estimate of alpha
         mY=max(Y);
         r= mY-min(Y);
         % find out if there a number of points very close to the maximum y
         % we are then likely to be very close to the asymtote
         f=    min(length(find(Y-mY > -r*0.01))+1,5);
         alpha= (1 + 10^(-f))*mY;
    
         % alpha=1.01*max(Y);
         
         % Initial estimate of alpha and beta
         mY=min(Y);
         % find out if there a number of points very close to the maximum y
         % we are then likely to be very close to the asymtote
         f=    min(length(find(Y-mY < r*0.01))+1,5);
         beta= (1 - 10^(-f))*mY;
    
		 % Get regression matrix
		 %Xs= linx2fx(L4,X);
		 X=X(:); 
		 Xs= [ones(size(X)) log(X)];
		 ylin= log(-log((alpha-Y)./(alpha-beta)));
		 % Find gamma and kappa
		 p= Xs\ylin;
		 % parameters from linear regression
		 delta= p(2) ;     
		 kappa= exp(p(1)/delta);
		 
		 % Returned parameter initial values
		 param= [alpha beta kappa delta]';
		 
		 % Bounds from spec.
		 minbound=[0 0 0 0]';
		 maxbound=[inf inf inf Inf]';
		 toosmall=find(param<minbound);
		 toobig=find(param>maxbound);
		 param(toosmall)=minbound(toosmall)+eps;
		 param(toobig)=maxbound(toobig)-eps;
	 else
		 OK=0;
		 param=[NaN NaN NaN NaN]';
	 end
   
   OK= OK & isreal(param);
else
   %% defaults from nowhere
   param= [2 1 2 5]';
   OK=1;
end

%---------------------------------------------------------------
% optional functions
%---------------------------------------------------------------

% i_jacobian           % analytic jacobian
% i_foptions           % optimisation parameters
% i_constraints        % define parameter constraints
% i_nlconstraints      % evaluate nonlinear constraints
% i_char               % display string for function
% i_str_func           % one line summary of function

% local regression optional functions

% i_rfnames            % response feature evaluation
% i_rfvals             % response feature evaluation
% i_reconstruct        % local model reconstruction

%---------------------------------------------------------------
% i_constraints constraint definition for least squares fitting
%---------------------------------------------------------------
function [LB,UB,A,c,nlcon,optparams]= i_constraints(U,b,varargin)
%
% Lower Bounds, Upper Bounds  
% make sure these are column vectors
LB=[eps eps eps eps]';
UB=[1e10 1e10 1e10 1e10]';

% only bounds are used for local regression at present

% don't use bounds with linear constraints if you want to use large scale optimisation

% Linear A, Linear b  (A*b<c)

%% this constraint is  -alpha+beta<0  =>  alpha > beta
A= [-1 1 0 0];
c= [0];

% Number of NonLinear constraints
% you must define 'nlconstraints' if nlcon>0
nlcon= 0;

% Note that fmincon will be used if A and b is empty or nlcon>0
% otherwise lsqnonlin is used

% optional parameters for cost function
optparams= [];

      
%---------------------------------------------------------------
%---------------------------------------------------------------
function fopts= i_foptions(U,b,fopts)
      
fopts= optimset(fopts,...
   'Display','none');

      
%---------------------------------------------------------------
% i_jacobian analytic jacobian (if defined)
%---------------------------------------------------------------
function J= i_jacobian(U,b,x)

x = x(:);

% return empty matrix if not defined

J= zeros(length(x),4);

a=b(1);
beta=b(2);
k=b(3);
d=b(4);

%   y = b(1) - (b(1)-b(2)).*exp(-(b(3).*x).^b(4));

ekd= exp(-(k.*x).^d);
j2= (a-beta).*(k.*x).^d.*ekd;

J(:,1)= 1-ekd;                           
J(:,2)= ekd;                             
J(:,3)= j2.*d./k;     
J(:,4)= j2.*log(k.*x);

      
%---------------------------------------------------------------
% i_labels user parameter names 
%---------------------------------------------------------------
function c= i_labels(U,b)


c={'\alpha','\beta','\kappa','\delta'};

%---------------------------------------------------------------
% i_char display equation string
%---------------------------------------------------------------
function str= i_char(U,b,fopts)
      
s= get(U,'symbol');
% this can contain TeX expressions supported by HG text objects
str=sprintf('%.3g - (%.3g-%.3g)*exp(-(%.3g*%s)^{%.3g})',b([1 1 2 3]),detex(s{1}), b(4));

%---------------------------------------------------------------
% i_str_func one line summary of function
%---------------------------------------------------------------
function str= i_str_func(U,b,TeX)
      
s= get(U,'symbol');
if nargin==2 | TeX
	s= detex(s);
end
% this can contain TeX expressions supported by HG text objects
lab= labels(U);
str= sprintf('%s - (%s - %s)*exp(-(%s*%s)^{%s})',lab{1},lab{1},lab{2},lab{3},s{1},lab{4});

      
% used for local regression only 
% all are optional


%---------------------------------------------------------------
% i_rfnames  response feature names 
%---------------------------------------------------------------
function [rname, default] = i_rfnames(U,b)
% this doesn't need to be defined  even if you have defined user-specified rfs.

% response feature names 
rname= {'inflex'};
      
if nargout>1
    default = [1 2 5 4]; %{'Alpha','Beta','Inflex','Delta'};
end

%---------------------------------------------------------------
% i_rfvals evaluate response features and gradient
%---------------------------------------------------------------
function [rf,dG]= i_rfvals(U,b)
% Note: model parameters are automatically available as response features

% this is an example of how to implement a nonlinear response feature
% response feature definition
if b(4)>=1
   rf= (1/b(3))*((b(4)-1)/b(4))^(1/b(4));
else
   rf= NaN;
end
      
if nargout>1
   % delrf/delbi
   if b(4)>=1
      dG= [0, 0, -((b(4)-1)/b(4))^(1/b(4))/b(3)^2,...
            1/b(3)*((b(4)-1)/b(4))^(1/b(4))*(-1/b(4)^2*log((b(4)-1)/b(4))+(1/b(4)-(b(4)-1)/b(4)^2)/(b(4)-1))];   
   else
      dG= [0, 0, 1 1];
   end
end   
      
%---------------------------------------------------------------
% i_reconstruct nonlinear reconstruction
%---------------------------------------------------------------
function p= i_reconstruct(U,b,Yrf,dG,rfuser)
% rfuser is an index to the user defined response features
% so you can figure out which rf's are which
% rfuser <= length(b) means the rf is the parameter rfuser

% this solves for linear response features which can be estimated independently 
% of the nonlinear rf.
%  if all response features are linear you don't need to define 'reconstruct'
p= Yrf/dG';

% find which response feature is a user defined
f= find(rfuser>size(p,2));
if ~any(rfuser==3)
   % need to use delta (must be > 1 for reconstruction to work
   p(:,4)= max(p(:,4),1+16*eps);
   
   p(:,3)= ((p(:,4)-1)./p(:,4)).^(1./p(:,4))./Yrf(:,f);
end

%---------------------------------------------------------------
% i_evalbuild simulink evaluation block
%---------------------------------------------------------------
function Blk = i_evalbuild(U, b, sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

Blk= add_block('models2/LocalMod/weibulEval',[sys,'/weibulEval']);

% break library link
set_param(Blk,'linkstatus','none');


%---------------------------------------------------------------
% i_slrecon simulink reconstruction block
%---------------------------------------------------------------
function blk= i_slrecon(U, b, LUM, sname)
% GOMP/SLRECON -  adds the appropriate reconstruct block

blk= add_block(['Models2/Reconstruct/weibRecon'],...
   [sname,'/Reconstruct']);

% break library link
set_param(blk,'linkstatus','none');