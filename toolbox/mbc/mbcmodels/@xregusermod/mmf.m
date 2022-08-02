function varargout= mmf(U,x,varargin)
% xregusermod/MMF template for user defined functions
%
% varargout= mmf(U,x,varargin)
%   
% To use this function, the command 
%   U2= mvcheckin(xregusermod,'funcname',xtest)
% must be run. The last argument is a colomn based input matrix to
% test the function. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:01:27 $

b= double(U);
if isa(x,'double')
    % shortcut for fast eval 
    
    % function definition
    % make sure this is vectorised
    y= b(1) - (b(1)-b(2))./(1+(b(3)*x).^b(4));
    y(x<0)=NaN;
    % this line must not be changed
    varargout{1}= y;
else
    % x specifies what function to evaluate
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
n= 4;

%---------------------------------------------------------------
% i_initial initial parameter values
%---------------------------------------------------------------
function [param,OK]= i_initial(U,p,X,Y)
% initial parameter values

if nargin==4
    % data dependent initial parameter values
    OK=1;
    % Bounds from spec.
    minbound=[2*eps eps eps eps]';
    maxbound=[inf inf inf inf]';
    
    if nargin==1 | isempty(X) | isempty(Y);
        param=[2 1 1 1]';  %default set
        return
    end
    Y=double(Y);
    X=double(X);
    
    % Remove any X,Y ==0
    xind= X==0;
    yind= Y==0;
    badind= or(xind,yind);
    Y(badind)=[];
    X(badind,:)=[];
    
    % Initial estimate of alpha
    mY=max(Y);
    r= mY-min(Y);
    % find out if there a number of points very close to the maximum y
    % we are then likely to be very close to the asymtote
    f=    min(length(find(Y-mY > -r*0.01))+1,5);
    alpha= (1 + 10^(-f))*mY;
    
    mY=min(Y);
    % find out if there a number of points very close to the maximum y
    % we are then likely to be very close to the asymtote
    f=    min(length(find(Y-mY < r*0.01))+1,5);
    beta= (1 - 10^(-f))*mY;
    
    % Create regression matrix
    Xs=[ones(size(X(:))) log(X(:))];
    
    % QR Decomposition
    %[Q,R]=qr(Xs,0);
    % Transform Y
    % Find residuals
    ylin= log((Y-beta)./(alpha-Y));
    %p= R\(Q'*ylin);
    p= Xs\ylin;
    
    delta=p(2);
    kappa=exp(p(1)/delta);
    
    
    % Returned parameter initial values
    param= [alpha beta kappa delta]';
    
    toosmall=find(param<minbound);
    toobig=find(param>maxbound);
    
    param(toosmall)=minbound(toosmall);
    param(toobig)=maxbound(toobig);
    
    OK= OK & isreal(param);
    
else
    param= [2 1 1 1]';
    OK=1;
end


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

% Lower Bounds, Upper Bounds  
% make sure these are column vectors
LB=[2*eps eps eps eps]';
UB=[inf inf inf inf]';

% only bounds are used for local regression at present

% Linear A, Linear b  (A*b<c)
A= [-1 1 0 0];
c= [0];
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

a=b(1);
bb=b(2);
k=b(3);
d=b(4);

kxd= (k*x).^d;

Ja= 1-1./(1+kxd);
Jb=1./(1+kxd);
Jk=(a-bb)./(1+kxd).^2.*kxd*d/k;
Jd=(a-bb)./(1+kxd).^2.*kxd.*log(k*x);

J= [Ja Jb Jk Jd];

% this line must not be changed
%---------------------------------------------------------------
% i_labels user parameter names 
%---------------------------------------------------------------
function c= i_labels(U,b)
% user parameter names 

c={'\alpha','\beta','\kappa','\delta'};

%---------------------------------------------------------------
% i_char display equation string
%---------------------------------------------------------------
function str= i_char(U,b,fopts)
% display equation string

s= get(U,'symbol');
% this can contain TeX expressions supported by HG text objects
str=sprintf('%.3g - (%.3g-%.3g)/(1+(%.3g*x)^{%.3g})',b([1 1 2 3 4]));
str = strrep(str,'/x^',['/',detex(s{1}),'^']);

%---------------------------------------------------------------
% i_str_func one line summary of function
%---------------------------------------------------------------
function str= i_str_func(U,b,TeX)
% one line summary of function
s= get(U,'symbol');
if nargin==2 | TeX
	s= detex(s);
end
lab= labels(U);

str = [lab{1},' - (',lab{1},'-',lab{2},')/(1+(',lab{3},'*',s{1},')^{',lab{4},'})'];

%---------------------------------------------------------------
% i_rfnames  response feature names 
%---------------------------------------------------------------
function [rname, default]= i_rfnames(U,b)
% response feature names 
rname= {'(Delta-1)/(2*Delta)'};

if nargout>1
    default = [1 2 3 5]; %{'alpha','beta','kappa','(Delta-1)/(2*Delta)'};
end

%---------------------------------------------------------------
% i_rfvals evaluate response features and gradient
%---------------------------------------------------------------
function [rf,dG]= i_rfvals(U,b)
% Note: model parameters are automatically available as response features

% this is an example of how to implement a nonlinear response feature
% response feature definition
rf= (b(4)-1)/(2*b(4));

if nargout>1
    % delrf/delbi
    dG=[0 0 0 1/(2*b(4)^2)];
end

%---------------------------------------------------------------
% i_reconstruct nonlinear reconstruction
%---------------------------------------------------------------
function p= i_reconstruct(U,b,Yrf,dG,rfuser)
% local reconstruction
% rfuser is an index to the user defined response features
% so you can figure out which rf's are which

% this solves for linear response features which can be estimated independently 
% of the nonlinear rf.
%  if all response features are linear you don't need to define 'reconstruct'
p= Yrf/dG';

%% must have alpha, beta, kappa
%% may have delta or the deltaRF
f=find(dG(:,4));
if ~any(rfuser==4)
    %% we have the deltaRF
    p(:,end)= 1./(1-2*Yrf(:,f));
end

% k and delta must be +ve
p(:,3:4)= max(p(:,3:4),eps*16);

% this line must not be changed


%---------------------------------------------------------------
% i_evalbuild simulink evaluation block
%---------------------------------------------------------------
function Blk = i_evalbuild(U, b, sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

Blk= add_block('models2/LocalMod/mmfEval',[sys,'/mmfEval']);

% break library link
set_param(Blk,'linkstatus','none');


%---------------------------------------------------------------
% i_slrecon simulink reconstruction block
%---------------------------------------------------------------
function blk= i_slrecon(U, b, LUM, sname)
% GOMP/SLRECON -  adds the appropriate reconstruct block

blk= add_block(['Models2/Reconstruct/mmfRecon'],...
   [sname,'/Reconstruct']);

% break library link
set_param(blk,'linkstatus','none');