function varargout= logistic(U,x,varargin)
% xregusermod/LOGISTIC template for user defined functions
%
% varargout= logistic(U,x,varargin)
%   
% To use this function the command 
%   U2= mvcheckin(xregusermod,'funcname',xtest)
% must be run. The last argument is a colomn based input matrix to
% test the function. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 08:01:23 $

b= double(U);
if isa(x,'double')
    % shortcut for fast eval 
    
    % function definition
    % make sure this is vectorised
    y=b(1)./(1+exp(-b(3)*(x-b(2))));
    
    % this line must not be changed
    varargout{1}= y;
else
    % x specifies what sub- function to evaluate
    % prefix function name by i_
    [varargout{1:nargout}]= feval(['i_',lower(x)],U,b,varargin{:});
end


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
n= 3;

%---------------------------------------------------------------
% i_initial initial parameter values
%---------------------------------------------------------------
function [param,OK]= i_initial(U,p,X,Y)
% initial parameter values

if nargin==4
    % data dependent initial parameter values
    OK=1;
    % Bounds from spec.
    minbound=[0 0 0]';
    maxbound=[inf inf inf]';
    
    if nargin==1 | isempty(X) | isempty(Y);
        param=[2 1 1]';  %default set
        return
    end
    Y=double(Y);
    X=double(X);
    
    % Initial estimate of alpha
    mY=max(Y);
    r= mY-min(Y);
    % find out if there a number of points very close to the maximum y
    % we are then likely to be very close to the asymtote
    f=    min(length(find(Y-mY > -r*0.01))+1,5);
    alpha= (1 + 10^(-f))*mY;
         
    % Get regression matrix
    Xs= [ones(size(X)) X];
    % Transform Y
    ylin= log((alpha-Y)./Y);
    % Find gamma and kappa
    p= Xs\ylin;
    
    kappa=-p(2);
    gamma=p(1)/kappa;     
    
    % Returned parameter initial values
    param= [alpha gamma kappa]';
    
    toosmall=find(param<minbound);
    toobig=find(param>maxbound);
    
    param(toosmall)=minbound(toosmall)+eps;
    param(toobig)=maxbound(toobig)-eps;
    
    OK= OK & isreal(param);
else
    param= [2 1 1]';
    OK=1;
end

%---------------------------------------------------------------
% optional functions
%---------------------------------------------------------------
% optional functions
% case 'jacobian',          % analytic jacobian
% case 'constraints'        % define parameter constraints
% case 'nlconstraints'      % evaluate nonlinear constraints
% case 'char'               % display string for function
% case 'str_func'           % one line summary of function
% case 'initial'            % initial parameter values initial(U,x,y)

% local regression optional functions

% case 'rfvals'             % response feature evaluation
% case 'reconstruct'        % local model reconstruction

%---------------------------------------------------------------
% i_constraints constraint definition for least squares fitting
%---------------------------------------------------------------
function [LB,UB,A,c,nlcon,optparams]= i_constraints(U,b,varargin)
% constraint definition for least squares fitting
%
% Lower Bounds, Upper Bounds  
% make sure these are column vectors
LB=[eps eps eps]';
UB=[Inf Inf Inf]';

% only bounds are used for local regression at present

% Linear A, Linear b  (A*b<c)
A= [];
c= [];
% Number of NonLinear constraints
nlcon= 0;

% Note that fmincon will be used if A and b is empty or nlcon>0
% otherwise lsqnonlin is used

% optional parameters for cost function
optparams= [];

%---------------------------------------------------------------
% i_foptions fitting options
%---------------------------------------------------------------
function fopts= i_foptions(U,b,fopts)

fopts= optimset(fopts,...
   'Display','none');

%---------------------------------------------------------------
% i_jacobian analytic jacobian (if defined)
%---------------------------------------------------------------
function J= i_jacobian(U,b,x)
% analytic jacobian (if defined)
x = x(:);

% return empty matrix if not defined

Ja= 1./(1+exp(-b(3)*(x-b(2))));
Jg= -b(1)./(1+exp(-b(3)*(x-b(2)))).^2*b(3).*exp(-b(3)*(x-b(2)));
Jk= -b(1)./(1+exp(-b(3)*(x-b(2)))).^2.*(-x+b(2)).*exp(-b(3)*(x-b(2)));

J=[Ja Jg Jk];

%---------------------------------------------------------------
% i_labels user parameter names 
%---------------------------------------------------------------
function c= i_labels(U,b)

% user parameter names 

c={'\alpha','\gamma','\kappa'};

%---------------------------------------------------------------
% i_char display equation string
%---------------------------------------------------------------
function str= i_char(U,b,fopts)
% display equation string

s= get(U,'symbol');
% this can contain TeX expressions supported by HG text objects
str= sprintf('%.3g/(1+exp(-%.3g*(%s-%.3g)))',b([1 3]),detex(s{1}),b(2));


%---------------------------------------------------------------
% i_str_func one line summary of function
%---------------------------------------------------------------
function str= i_str_func(U,b,TeX)
% one line summary of function

s= get(U,'symbol');
if nargin==2 | TeX
	s= detex(s);
end

% this can contain TeX expressions supported by HG text objects
lab= labels(U);
str= sprintf('%s/(1+exp(-%s*(%s-%s)))',lab{[1 3]},s{1},lab{2});

%---------------------------------------------------------------
% i_rfnames  response feature names 
%---------------------------------------------------------------
function [rname, default] = i_rfnames(U,b)
% response feature names 
rname= {'maxgr'};

if nargout>1
    default = [1 2 4];% {'alpha','gamma','Kappa*Alpha/4'};
end

%---------------------------------------------------------------
% i_rfvals evaluate response features and gradient
%---------------------------------------------------------------
function [rf,dG]= i_rfvals(U,b)
% Note: model parameters are automatically available as response features

% this is an example of how to implement a nonlinear response feature
% response feature definition
rf= b(1)*b(3)/4;

if nargout>1
    % delrf/delbi
    dG= [b(3)/4 0 b(1)/4];   
end

%---------------------------------------------------------------
% i_reconstruct nonlinear reconstruction
%---------------------------------------------------------------
function p= i_reconstruct(U,b,Yrf,dG,rfuser)
% local reconstruction
% rfuser is an index to the user defined response features
% so you can figure out which rf's are which
% rfuser(i) = 0 if the rf is a parameter

% this solves for linear response features which can be estimated independently 
% of the nonlinear rf.
%  if all response features are linear you don't need to define 'reconstruct'
p= Yrf/dG';

% find which response feature is a user defined
f= find(rfuser>size(p,2));
if ~any(rfuser==3)
    % we don't have kappa
    p(:,3)= Yrf(:,f)*4./p(:,1);
elseif ~any(rfuser==1)
    % we don't have alpha
    p(:,1)= Yrf(:,f)*4./p(:,3);
end


%---------------------------------------------------------------
% i_evalbuild simulink evaluation block
%---------------------------------------------------------------
function Blk = i_evalbuild(U, b, sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

Blk= add_block('models2/LocalMod/logisticEval',[sys,'/logisticEval']);

% break library link
set_param(Blk,'linkstatus','none');


%---------------------------------------------------------------
% i_slrecon simulink reconstruction block
%---------------------------------------------------------------
function blk= i_slrecon(U, b, LUM, sname)
% GOMP/SLRECON -  adds the appropriate reconstruct block

blk= add_block(['Models2/Reconstruct/logRecon'],...
   [sname,'/Reconstruct']);

% break library link
set_param(blk,'linkstatus','none');

rfuser= get(LUM, 'feat.index');

vars = {'KnownParam'};
if ~any(rfuser==3)
	values{1} = '1'; 
elseif ~any(rfuser==1)
	values{1} = '3'; 
end
AddVariablesToMask(blk, vars, values);