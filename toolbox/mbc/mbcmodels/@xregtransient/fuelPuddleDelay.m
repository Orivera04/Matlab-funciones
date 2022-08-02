function varargout= fuelPuddleDelayM(U,x,varargin)
% DYNAMIC/FUELPUDDLEDELAY
%
% varargout= fuelPuddle(U,x,varargin)
%   
% To use this function the command 
%   U2 = mvcheckin(xregusermod,funcname,xtest)
% must be run. The last argument is a column based input matrix to
% test the function. 
% This function is not normally called directly.
%
% See also xregusermod/weibul

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:58:49 $

% don't change this section of code
b= double(U);
if isa(x,'double')
   % shortcut for fast eval 
   
   % function definition
   % make sure this is vectorised
   y = [];
   
   % this line must not be changed
   varargout{1}= y;
else
   % x specifies what sub- function to evaluate
   % prefix function name by i_
   [varargout{1:nargout}]= feval(['i_',lower(x)],U,b,varargin{:});
end

% The user must specify the folowing functions
% see xregusermod/weibul for an example

%***************************************************************
% DYNAMIC functions
%***************************************************************

% vars= i_simvars(U,b)  % simulink variable names
% [vars,vals]= i_simconstants(U,b)  % simulink constants variable names
% [U,ic]= i_initcond(U,b,X,Y); % initial conditions

%***************************************************************
% xregusermod functions
%***************************************************************

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

%---------------------------------------------------------------
% i_simvars simulink variable names 
%---------------------------------------------------------------
function vars= i_simvars(U,b,varargin);
% define as a cell array of variable names
vars = {'tau','x', 'delay'};

%---------------------------------------------------------------
% i_simconstants simulink constant variable names 
%---------------------------------------------------------------
function [vars,vals]= i_simconstants(U,b,varargin);
% define as a cell array of variable names
vars = {};
% values 
vals = [];

%---------------------------------------------------------------
% i_initcond initial conditions 
%---------------------------------------------------------------
function [ic]= i_initcond(U,b,X,Y);
% define as a cell array of variable names
if nargin==4
   % data dependent initial conditions
   ic= [];
end
ic=[];


%---------------------------------------------------------------
% i_numparams number of parameters 
%---------------------------------------------------------------
function n= i_numparams(U,b,varargin);
% you must specify this or initial
n= 3;

%---------------------------------------------------------------
% i_nfactors number of input factors 
%---------------------------------------------------------------
function n= i_nfactors(U,b,varargin);
% you must specify this (include time as a factor)
n= 2;

%---------------------------------------------------------------
% i_initial initial parameter values
%---------------------------------------------------------------
function [param,OK]= i_initial(U,b,X,Y)

param= [0.5 0.5 1.0]';
OK=1;

%% READING DELAY FROM DATA
if nargin==4 & length(double(Y))==length(double(X)) 
   try
      filtVal=0.25;
	  
	  y = double(Y);
	  x = double(X(:,1)); %% time vector
	  y = filtfilt([0 filtVal],[1 filtVal-1],y);
	  [intercepts,p] = pointselect(U,y,x);
	  if ~isempty(intercepts)
		  intA = intercepts(1,:);
		  
		  u = double(X(:,2)); %% input vector
		  u = filtfilt([0 filtVal],[1 filtVal-1],u);
		  [intercepts,p] = pointselect(U,u,x);
		  intB = intercepts(1,:);
		  
		  numInt = min(length(intA),length(intB));
		  intA=intA(1:numInt); intB=intB(1:numInt);
		  delay = mean(abs(intA-intB));
	  else
		  delay = 0.1;
	  end
	  param = [param(1:end-1); delay];
   end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optional Functions are below here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------------------------------------
% i_constraints constraint definition for least squares fitting
%---------------------------------------------------------------
function [LB,UB,A,c,nlcon,optparams]= i_constraints(U,b,X,Y)
%
% Lower Bounds, Upper Bounds  
% make sure these are column vectors
LB=[eps 0 0]'; 
UB=[Inf 1 Inf]';

% only bounds are used for local regression at present

% don't use bounds with linear constraints if you want to use large scale optimisation

% Linear A, Linear b  (A*b<c)
A= [];
c= [];

% Number of NonLinear constraints
% you must define 'nlconstraints' if nlcon>0
nlcon= 0;

% Note that fmincon will be used if A and b is empty or nlcon>0
% otherwise lsqnonlin is used

% optional parameters for cost function
optparams= [];

%---------------------------------------------------------------
% i_nlconstraints  evaluate nonlinear constraints
%---------------------------------------------------------------
function g= i_nlconstraints(U,b,X,Y);

g=[];

      
%---------------------------------------------------------------
% i_foptions 
%---------------------------------------------------------------
function fopts= i_foptions(U,b,fopts)

% always base this on input fopts
fopts= optimset(fopts,...
   'Display','iter');

      
%---------------------------------------------------------------
% i_jacobian analytic jacobian (if defined)
%---------------------------------------------------------------
function J= i_jacobian(U,b,X)

% return empty matrix if not defined
J= [];

      
%---------------------------------------------------------------
% i_labels user parameter names 
%---------------------------------------------------------------
function c= i_labels(U,b)


% return empty matrix if not defined
c= {'\tau','x', 'delay'};

%---------------------------------------------------------------
% i_char display equation string
%---------------------------------------------------------------
function str= i_char(U,b)
      
str=[];

%---------------------------------------------------------------
% i_str_func one line summary of function
%---------------------------------------------------------------
function str= i_str_func(U,b)
str= [];

      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optional local regresion functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------------------------------------
% i_rfnames  response feature names 
%---------------------------------------------------------------
function [rname,defs]= i_rfnames(U,b)
% this doesn't need to be defined  even if you have defined user-specified rfs.

% response feature names 
rname= [];
defs= 1:numParams(U);
      
%---------------------------------------------------------------
% i_rfvals evaluate response features and gradient
%---------------------------------------------------------------
function [rf,dG]= i_rfvals(U,b)
% Note: model parameters are automatically available as response features

% this is an example of how to implement a nonlinear response feature
% response feature definition
rf= [];
      
if nargout>1
   % delrf/delbi
   dG= [];   
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
p= [];
