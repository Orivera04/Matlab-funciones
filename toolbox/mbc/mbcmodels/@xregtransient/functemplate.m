function varargout= functemplate(U,x,varargin)
% DYNAMIC/FUNCTEMPLATE template for user defined functions
%
% varargout= functemplate(U,x,varargin)
%   
% To use this function the command 
%   U2= mvcheckin(xregusermod,funcname,xtest)
% must be run. The last argument is a column based input matrix to
% test the function. 
% This function is not normally called directly.
%
% See also xregusermod/weibul

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:58:51 $

% don't change this section of code
b= double(U);
if isa(x,'double')
   % shortcut for fast eval 
   % not used for dynamic models
   
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
% they must match the wkspce variables required by the associated simulink model
vars = {'In1','In2'};

%---------------------------------------------------------------
% i_simconstants simulink constant variable names 
%---------------------------------------------------------------
function [vars,vals]= i_simconstants(U,b,varargin);
% define as a cell array of variable names
% they must match the wkspce variables required by the associated simulink model
vars = {};
% values 
vals = [];

%---------------------------------------------------------------
% i_initcond initial conditions 
%---------------------------------------------------------------
function [ic]= i_initcond(U,b,X,Y);

ic=[];

%% future development may take in i_initcond(U,b,X,Y) and assume 
%% steady state dState/dt = f(State,b) = 0 to solve for State given initial b

%---------------------------------------------------------------
% i_numparams number of parameters 
%---------------------------------------------------------------
function n= i_numparams(U,b,varargin);
% you must specify this or initial
n= 2;

%---------------------------------------------------------------
% i_nfactors number of input factors 
%---------------------------------------------------------------
function n= i_nfactors(U,b,varargin);
% you must specify this (include time as a factor)
% must match inputs required by Simulink model
n= 2;

%---------------------------------------------------------------
% i_initial initial parameter values
%---------------------------------------------------------------
function [param,OK]= i_initial(U,b,X,Y)
% column vector of initial values
% could include a routine to make good guess of vals given data X,Y
if nargin>2
   % data dependent initial parameter values??
   param= [0.5 0.5]';
% flag to say this data is worth fitting
   OK=1;
   
else
   %% defaults from spec
   param= [0.5 0.5]';
% flag to say this data is worth fitting
   OK=1;
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
LB=[0 0]'; 
UB=[Inf 1]';

% only bounds are used for local regression at present

% don't use bounds with linear constraints if you want to use large scale optimisation

% Linear A, Linear b  (A*b<c)
A= [];
c= [];

% Number of NonLinear constraints
% you must define the 'nlconstraints' function below if nlcon>0
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
% i_foptions  optimisation options
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
c= [];

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
function [rname,def]= i_rfnames(U,b)
% this doesn't need to be defined  even if you have defined user-specified rfs.

% response feature names 
rname= [];
def=  1:numParams(U);
      
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
