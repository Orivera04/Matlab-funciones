function varargout= exponential(U,x,varargin)
% xregusermod/exponential template for user defined functions
%
% varargout= exponential(U,x,varargin)
%   
% To use this function, the command 
%   U2= mvcheckin(xregusermod,'exponential',xtest)
% must be run. The last argument is a column based input matrix to
% test the function. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:07 $

% don't change this section of code
b= double(U);
if isa(x,'double')
   % shortcut for fast eval 
   
   % function definition
   % make sure this is vectorised
   y=b(1)*exp(b(2)*x); 
    
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
n= 2;

%---------------------------------------------------------------
% i_initial initial parameter values
%---------------------------------------------------------------
function [param,OK]= i_initial(U,b,X,Y)
 
if nargin>2
   % data dependent initial parameter values
   OK=1;
   
   Y=double(Y);
   X=double(X);
   
   % Initial estimate of alpha and beta
   Xs= [ones(size(X)) log(X)];
   % Find alpha and beta
   p= Xs\Y;
   % parameters from linear regression
   alpha= exp(p(1));     
   beta=b(2);
   
   % Returned parameter initial values
   param= [alpha beta]';
   
   % Bounds from spec.
   minbound=[1e-6 1e-6]';
   maxbound=[inf inf]';
   toosmall=find(param<minbound);
   toobig=find(param>maxbound);
   param(toosmall)=minbound(toosmall)+eps;
   param(toobig)=maxbound(toobig)-eps;
   
   OK= OK & isreal(param);
else
   %% defaults from spec
   param= [0.04 0.18]';
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
UB=[inf inf]';
LB=[1e-6 1e-6]';

% only bounds are used for local regression at present

% don't use bounds with linear constraints if you want to use large scale optimisation

% Linear A, Linear b  (A*b<c)

% no constraints
A= [];
c= [];

% Number of NonLinear constraints
nlcon= 0;

% optional parameters for cost function
optparams= [];

      
%---------------------------------------------------------------
%---------------------------------------------------------------
function fopts= i_foptions(U,b,fopts)
      
fopts= optimset(fopts,...
   'Display','iter');

      
%---------------------------------------------------------------
% i_jacobian analytic jacobian (if defined)
%---------------------------------------------------------------
function J= i_jacobian(U,b,x)

% return empty matrix if not defined
J=[exp(b(2)*x), b(1)*x.*exp(b(2)*x)];

%---------------------------------------------------------------
% i_labels user parameter names 
%---------------------------------------------------------------
function c= i_labels(U,b)


c={'\alpha','\beta'};

%---------------------------------------------------------------
% i_char display equation string
%---------------------------------------------------------------
function str= i_char(U,b,fopts)
      
s= get(U,'symbol');
% this can contain TeX expressions supported by HG text objects
str=sprintf('%.3g*exp(%.3g*',b([1 2]));
str = [str, detex(s{1}), ')'];

%---------------------------------------------------------------
% i_str_func one line summary of function
%---------------------------------------------------------------
function str= i_str_func(U,b)
      
s= get(U,'symbol');
% this can contain TeX expressions supported by HG text objects
lab= labels(U);
str= sprintf('%s*exp(%s*',lab{1},lab{2});
str = [str, s{1}, ')'];
      
% used for local regression only 
% all are optional


%---------------------------------------------------------------
% i_rfnames  response feature names 
%---------------------------------------------------------------
function [rname, defaults]= i_rfnames(U,b)
% this doesn't need to be defined  even if you have defined user-specified rfs.

% response feature names 
rname= {'SPK(0.15)'};
if nargout >1
    defaults = [1:2];
end


%---------------------------------------------------------------
% i_rfvals evaluate response features and gradient
%---------------------------------------------------------------
function [rf,dG]= i_rfvals(U,b)
% Note: model parameters are automatically available as response features

% this is an example of how to implement a nonlinear response feature
% response feature definition
a=b(1);
b=b(2);
rf=(1/b)*log(0.15/a);
      
if nargout>1
   % delrf/delbi
   dG= [ -1/a/b -log(0.15/a)/b^2];   
end   
      
%---------------------------------------------------------------
% i_reconstruct nonlinear reconstruction
%---------------------------------------------------------------
function p= i_reconstruct(U,b,Yrf,dG,rfuser)
% rfuser is an index to the user defined response features
% so you can figure out which rf's are which
% rfuser(i) = 0 if the rf is a parameter

% this solves for linear response features which can be estimated independently 
% of the nonlinear rf.
%  if all response features are linear you don't need to define 'reconstruct'

% this solves for linear response features which can be estimated independently 
% of the nonlinear rf.
%  if all response features are linear you don't need to define 'reconstruct'
p= Yrf/dG';

if ~any(rfuser==1)
    state=1;
elseif ~any(rfuser==2)
    state=2;
end

% find which response feature is a user defined
if any(rfuser>2)
    % return the required coefficient
    switch state
    case 1
        % parameter c missing
        p(1)=0.15/exp(p(2)*Yrf(find(rfuser==3)));
    otherwise
        % parameter a missing
        p(2)=log(0.15/p(1))/Yrf(find(rfuser==3));
    end
end



