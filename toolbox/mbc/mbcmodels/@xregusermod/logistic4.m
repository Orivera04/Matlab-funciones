function varargout= logistic4(U,x,varargin)
% xregusermod/LOGISTIC4 template for user defined functions
%
% varargout= logistic4(U,x,varargin)
%   
% To use this function the command 
%   U2= mvcheckin(xregusermod,'funcname',xtest)
% must be run. The last argument is a colomn based input matrix to
% test the function. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:01:24 $

b= double(U);
if isa(x,'double')
    % shortcut for fast eval 
    
    % function definition
    % make sure this is vectorised
    y= b(2) - (b(2)-b(1))./( 1 + x.^(-b(3))*exp(b(3)*b(4)) );
	y(x < 0) = NaN;
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
% initial parameter values

if nargin==4
    % data dependent initial parameter values
    OK=1;
    % Bounds from spec.
    minbound=[eps eps eps eps]';
    maxbound=[inf inf inf inf]';
    
    if nargin==1 | isempty(X) | isempty(Y);
        param= [3 1 2 1]';  %default set
        return
    end
    Y=double(Y);
    X=double(X);
    X= X(Y>0);
    Y= Y(Y>0);
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
    ylin= log((Y-beta)./(alpha-Y));
    % Find gamma and kappa
    p= Xs\ylin;
    
    kappa= p(2);
    gamma= -p(1)/kappa ;     
    
    % Returned parameter initial values
    param= [alpha beta kappa gamma]';
    
    toosmall=find(param<minbound);
    toobig=find(param>maxbound);
    
    param(toosmall)=minbound(toosmall)+eps;
    param(toobig)=maxbound(toobig)-eps;
    
    OK= OK & isreal(param);
else
    param= [3 1 2 1]';
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
LB=[eps eps eps eps]';
UB=[inf inf inf inf]';

% only bounds are used for local regression at present

% Linear A, Linear b  (A*b<c)
A= [-1 1 0 0];
   % ;0 1 0 -1; -1 0 0 1];
c= 0;
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
a=b(1);
bb=b(2);
k=b(3);
g=b(4);

ekg1=exp(-k.*(log(x)-g));
ekg2= exp(k.*g)./(x.^k);

J= zeros(length(x),4);
J(:,1) = 1./(1+ekg2);
J(:,2) = 1-1./(1+ekg2);
J(:,3) = (bb-a)./(1+ekg1).^2.*(-log(x)+g).*ekg1;
J(:,4) = (bb-a)./(1+ekg1).^2.*k.*ekg1;

%---------------------------------------------------------------
% i_labels user parameter names 
%---------------------------------------------------------------
function c= i_labels(U,b)
% user parameter names 

c={'\alpha','\beta','\kappa','\gamma'};

%---------------------------------------------------------------
% i_char display equation string
%---------------------------------------------------------------
function str= i_char(U,b,fopts)
% display equation string

s= get(U,'symbol');
b(4)= (b(3)*b(4));
% this can contain TeX expressions supported by HG text objects
str=sprintf('%.3g - (%.3g-%.3g)/(1+exp(%.3g)/x^{%.3g})',b([2 1 2 4 3]));
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

str = sprintf('%s - (%s-%s)/(1+exp(%s)/x^{%s})',lab{[2 1 2 4 3]});
str = strrep(str,'/x^',['/',s{1},'^']);

%---------------------------------------------------------------
% i_rfnames  response feature names 
%---------------------------------------------------------------
function [rname, default] = i_rfnames(U,b)
% response feature names 
rname= {'log(infl)'};

if nargout>1
    default = [1 2 3 4]; %{'Alpha','Beta','Kappa','Gamma','log(infl)'};
end

%---------------------------------------------------------------
% i_rfvals evaluate response features and gradient
%---------------------------------------------------------------
function [rf,dG]= i_rfvals(U,b)
% Note: model parameters are automatically available as response features

% this is an example of how to implement a nonlinear response feature
% response feature definition
if b(3)>1
   rf= ( b(3)*b(4)-log((1+b(3))/(b(3)-1)) )/b(3);
else
   rf= NaN;
end

if nargout>1
    % delrf/delbi
    if b(3)>1
       dG= [0, 0, (2*b(3)-log((1+b(3))/(b(3)-1))+log((1+b(3))/(b(3)-1))*b(3)^2)/(b(3)^4-b(3)^2), 1];   
    else
       dG= [0 0 1 1];
    end
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

%      feat=features(U);
%      f= strcmp(feat,'log(infl)');
f= find(rfuser>size(p,2));

if any(rfuser>size(p,2)) %% we have the other respFeat
    if ~any(rfuser==4)
        % we do not have gamma
        % make sure k>1
        p(:,3)= max(p(:,3),1+16*eps);
        
        p(:,4)= Yrf(:,f) + log( (1+p(:,3))./(p(:,3)-1))./p(:,3);
        
    elseif  ~any(rfuser==3)  %% unsupported reconstruction
        % we need to get kappa - this is a nightmare
        % localusermod will throw this out as a possible rf combination
        p(:,3) = Inf;
    end
end


%---------------------------------------------------------------
% i_evalbuild simulink evaluation block
%---------------------------------------------------------------
function Blk = i_evalbuild(U, b, sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

Blk= add_block('models2/LocalMod/logistic4Eval',[sys,'/logistic4Eval']);

% break library link
set_param(Blk,'linkstatus','none');


%---------------------------------------------------------------
% i_slrecon simulink reconstruction block
%---------------------------------------------------------------
function blk= i_slrecon(U, b, LUM, sname)
% GOMP/SLRECON -  adds the appropriate reconstruct block

rfuser = get(LUM, 'feat.index');

if any(rfuser > length(b))
   % we have kappa
   blk= add_block(['Models2/Reconstruct/log4Recon'],...
      [sname,'/Reconstruct']);
  % Special consideration for the third Response Feature which isn't really
  % linear
   set_param(blk,'linkstatus','none');
   AddVariablesToMask(blk,{'Log4LinTerms'}, {'[1 2]'});
else
   % Linear Reconstruct
   blk= add_block(['Models2/Reconstruct/linearRecon'],...
      [sname,'/Reconstruct']);
end

% break library link
set_param(blk,'linkstatus','none');