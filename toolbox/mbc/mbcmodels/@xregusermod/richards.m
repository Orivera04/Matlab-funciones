function varargout= richards(U,x,varargin)
% USERMOD/RICHARDS template for user defined functions
%
% varargout= richards(U,x,varargin)
%   
% To use this function the command 
%   U2= mvcheckin(usermod,'weibul',xtest)
% must be run. The last argument is a column based input matrix to
% test the function. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:01:40 $

% don't change this section of code
b= double(U);
if isa(x,'double')
    % shortcut for fast eval 
    
    % function definition
    % make sure this is vectorised
    if 1-3e-6 < b(4) & b(4) < 1+3e-6
        y = b(1)*exp(-exp(-b(3)*(x-b(2))));
    else
        y= b(1)*(1+ (b(4)-1)*exp(-b(3)*(x-b(2))) ).^(1/(1-b(4)));
    end
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
n= 4;

%---------------------------------------------------------------
% i_initial initial parameter values
%---------------------------------------------------------------
function [param,OK]= i_initial(U,p,X,Y)

if nargin>2
    OK=1;
    
    minbound=[eps eps eps 2^4*eps]';
    maxbound=[inf inf inf inf]';
    % data dependent initial parameter values
    Y=double(Y);
    X=double(X);
    
    % Initial estimate of alpha
    mY=max(Y);
    r= mY-min(Y);
    % find out if there a number of points very close to the maximum y
    % we are then likely to be very close to the asymtote
    f=    min(length(find(Y-mY > -r*0.01))+1,5);
    alpha= (1 + 10^(-f))*mY;
    
    
    % try delta=2
    delta=2;
    % Get regression matrix
    Xs= [ones(size(X(:))) X(:)];
    y1= -log(((Y./alpha).^(1-delta)-1)./(delta-1));
    p= Xs\y1;
    p1= [alpha,-p(1)/p(2) p(2) delta]';
    R1= update(U,p1);
    s1= sum((Y-eval(R1,X)).^2);
    
    % try delta=0.5
    delta=0.5;
    % Get regression matrix
    y2= -log(((Y./alpha).^(1-delta)-1)./(delta-1));
    p= Xs\y2;
    p2= [alpha,-p(1)/p(2) p(2) delta]';
    R2= update(U,p2);
    s2= sum((Y-eval(R2,X)).^2);
    
    % choose best solution
    if s1<s2
        param=p1;
    else
        param=p2;
    end
    
    toosmall=find(param<minbound);
    toobig=find(param>maxbound);
    
    param(toosmall)=minbound(toosmall);
    param(toobig)=maxbound(toobig);
    
    OK= OK & isreal(param);
else
    
    %% defaults from spec
    param= [1 1 1 2]';
    OK=1;
end

%---------------------------------------------------------------
% i_constraints constraint definition for least squares fitting
%---------------------------------------------------------------
function [LB,UB,A,c,nlcon,optparams]= i_constraints(U,b,varargin)
%
% Lower Bounds, Upper Bounds  
% make sure these are column vectors
LB=[eps eps eps 2^4*eps]';
UB=[inf inf inf inf]';

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
%---------------------------------------------------------------
function fopts= i_foptions(U,b,fopts)

fopts= optimset(fopts,...
    'Display','none');


%---------------------------------------------------------------
% i_jacobian analytic jacobian (if defined)
%---------------------------------------------------------------
function J= i_jacobian(U,b,x)

x = x(:);

a=b(1);
g=b(2);
k=b(3);
d=b(4);

ekg= exp(-k.*(x-g));
ekg2= ekg*(d-1);

J= zeros(length(x),4);

if 1-3e-6 < b(4) & b(4) < 1+3e-6
    J(:,1)= exp(-ekg);
    J(:,2)= -a*k*exp(-k*x+k*g-ekg);
    J(:,3)= a*(x-g).*exp(-k*x+k*g-ekg);
    J(:,4)= 0.5*a*exp(-ekg).*ekg.^2;
else
    J(:,1)= (1+ekg2).^(1/(1-d));
    J(:,2)=-a.*(1+ekg2).^(-d/(d-1)).*k.*ekg;
    J(:,3)=a.*(1+ekg2).^(-d/(d-1)).*(x-g).*ekg;
    
    lekg= log(1+ekg2);
    J(:,4)=a*(1+ekg2).^(-d/(d-1)).*( lekg + ...
        lekg.*ekg*(d-1) - ekg2 )/(d-1).^2;
end


%---------------------------------------------------------------
% i_labels user parameter names 
%---------------------------------------------------------------
function c= i_labels(U,b)


c= {'\alpha','\gamma','\kappa','\delta'};

%---------------------------------------------------------------
% i_char display equation string
%---------------------------------------------------------------
function str= i_char(U,b,fopts)

% this can contain TeX expressions supported by HG text objects
a=b(1);
g=b(2);
k=b(3);
d=b(4);
str=sprintf('%.3g*[1+(%.3g - 1)*exp(-%.3g*(x - %.3g))]^{1/(1 - %.3g)}',[a d k g d]);

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
str=sprintf('%s*[1 + (%s-1)*exp(-%s*(%s-%s))]^{1/(1-%s)}',lab{1},lab{4},lab{3},detex(s{1}),lab{2},lab{4});

% used for local regression only 
% all are optional


%---------------------------------------------------------------
% i_rfnames  response feature names 
%---------------------------------------------------------------
function [rname, default] = i_rfnames(U,b)
% this doesn't need to be defined  even if you have defined user-specified rfs.

% response feature names 
rname= {'Kappa/(2*(Delta+1))'};

if nargout>1
    default = [1 2 3 5]; %{'alpha','gamma','kappa','Kappa/(2*(Delta+1))'};
end


%---------------------------------------------------------------
% i_rfvals evaluate response features and gradient
%---------------------------------------------------------------
function [rf,dG]= i_rfvals(U,b)
% Note: model parameters are automatically available as response features

% this is an example of how to implement a nonlinear response feature
% response feature definition
rf= b(3)/(2*(b(4)+1));

if nargout>1
    % delrf/delbi
    dG=[0, 0, 1/(2*(b(4)+1)), -b(3)/(2*(b(4)+1)^2)];
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

% delta estimate
p= Yrf/dG';
f= find(rfuser>size(p,2));

alpha=p(:,1);
gamma=p(:,2);
kappa=p(:,3);
delta=p(:,4);
% find the correct y value
if ~any(rfuser==3)
    %% we do not have kappa
    kappa = 2*Yrf(:,f).*(delta+1);
elseif ~any(rfuser==4)
    %% we do not have delta
    % find delta
    delta=(kappa./(2*Yrf(:,f)))-1;
end

p= [alpha gamma kappa delta];


%---------------------------------------------------------------
% i_evalbuild simulink evaluation block
%---------------------------------------------------------------
function Blk = i_evalbuild(U, b, sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

Blk= add_block('models2/LocalMod/richardEval',[sys,'/richardEval']);

% break library link
set_param(Blk,'linkstatus','none');


%---------------------------------------------------------------
% i_slrecon simulink reconstruction block
%---------------------------------------------------------------
function blk= i_slrecon(U, b, LUM, sname)
% GOMP/SLRECON -  adds the appropriate reconstruct block
rfuser= get(LUM, 'feat.index');

if ~any(rfuser==3)
    %% we do not have kappa
	blk= add_block(['Models2/Reconstruct/richReconKappa'], [sname,'/Reconstruct']);
elseif ~any(rfuser==4)
    %% we do not have delta
    % find delta
	blk= add_block(['Models2/Reconstruct/richReconDelta'], [sname,'/Reconstruct']);
end

% break library link
set_param(blk,'linkstatus','none');