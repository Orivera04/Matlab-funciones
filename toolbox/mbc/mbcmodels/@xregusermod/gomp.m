function varargout= gomp(U,x,varargin)
% xregusermod/gomp
%
% varargout= gomp(U,x,varargin)
%   
% To use this function the command 
%   U2= mvcheckin(xregusermod,'gomp',xtest)
% must be run. The last argument is a column based input matrix to
% test the function. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:01:13 $



% don't change this section of code
b= double(U);
if isa(x,'double')
   % shortcut for fast eval 
   y=zeros(size(x));
   
   y= b(1)*exp(-exp(-b(3)*(x-b(2))));
   y(x<0)=NaN;
   
   % this line must not be changed
   varargout{1}= y;
else
   % x specifies what sub- function to evaluate
   % prefix function name by i_
   [varargout{1:nargout}]= feval(['i_',lower(x)],U,b,varargin{:});
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mandatory functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------------------------------------
% i_nfactors number of input factors 
%---------------------------------------------------------------
function n= i_nfactors(U,b,varargin);
n= 1;
%---------------------------------------------------------------
% i_numparams number of parameters 
%---------------------------------------------------------------
function n= i_numparams(U,b,varargin);
n= 3;

%---------------------------------------------------------------
% i_initial initial parameter values
%---------------------------------------------------------------
function [param,OK]= i_initial(U,b,X,Y)

OK=1;

if nargin==4
   %% so we have data to make a better initial guess
   Y=double(Y);
   X=double(X);
   yok= Y>0;
   Y= Y(yok);
   X= X(yok,:);
	
	if ~isempty(Y)
   
		%% default bounds
		minbound=[eps eps eps]';
		maxbound=[inf inf inf]';
		
		% Initial estimate of alpha
         % Initial estimate of alpha
         mY=max(Y);
         r= mY-min(Y);
         % find out if there a number of points very close to the maximum y
         % we are then likely to be very close to the asymtote
         f=    min(length(find(Y-mY > -r*0.01))+1,5);
         alpha= (1 + 10^(-f))*mY;
		
		% Make X matrix for regression
		Xcol = X(:);
		Xs = [ones(size(Xcol)) Xcol];
		
		% Find residuals
		ylin= log(-log(Y./alpha));
		p= Xs\ylin;
		
		kappa= -p(2);
		gamma= p(1)/kappa;
		
		% Returned parameter initial values
		param= [alpha gamma kappa]';
		
		toosmall=find(param<minbound);
		toobig=find(param>maxbound);
		
		param(toosmall)=minbound(toosmall);
		param(toobig)=maxbound(toobig);
		OK= OK & isreal(param);   
	else
		OK= 0;
		param= [NaN NaN NaN]';
	end
		
else
   param=[1 1 1];  %default set
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optional functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------------------------------------
% i_constraints constraint definition for least squares fitting
%---------------------------------------------------------------
function [LB,UB,A,c,nlcon,optparams]= i_constraints(U,b,varargin)
%
% Lower Bounds, Upper Bounds  
LB=[eps eps eps]';
UB=[inf inf inf]';

A= [];
c= [];

% Number of NonLinear constraints
nlcon= 0;

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

x = x(:);

a=b(1);
g=b(2);
k=b(3);

ekg= exp(-k.*(x-g));
Ja= exp(-ekg);
Jg= -a*k*exp(-k*x+k*g-ekg);
Jk= a*(x-g).*exp(-k*x+k*g-ekg);

J= [Ja Jg Jk];

%---------------------------------------------------------------
% i_labels user parameter names 
%---------------------------------------------------------------
function c= i_labels(U,b)


c = {'\alpha','\gamma','\kappa'};

%---------------------------------------------------------------
% i_char display equation string
%---------------------------------------------------------------
function str= i_char(U,b,fopts)

s= get(U,'symbol');
% this can contain TeX expressions supported by HG text objects
str=sprintf('%.3g exp(-exp( -%.3g*(%s - %.3g) ) )',b([1 3]), detex(s{1}) , b(2));

%   y= b(1)*exp(-exp(-b(3)*(x-b(2))));

%---------------------------------------------------------------
% i_str_func one line summary of function
%---------------------------------------------------------------
function str= i_str_func(U,b)

s= get(U,'symbol');
% this can contain TeX expressions supported by HG text objects
lab= labels(U);
%str= sprintf('%s - (%s - %s)*exp(-(%s*x)^{%s})',lab{1},lab{1},lab{2},lab{3},lab{4});

str= [lab{1},'*exp(-exp(-',lab{3},'*(',detex(s{1}),' - ',lab{2},')))'];


%---------------------------------------------------------------
% i_rfnames  response feature names 
%---------------------------------------------------------------
function [rname, default] = i_rfnames(U,b)
% this doesn't need to be defined  even if you have defined user-specified rfs.

% response feature names 
rname= {'maxgr'};

if nargout>1
    default = [1 2 4]; %{'alpha','gamma','kappa*alpha/e'};
end

%---------------------------------------------------------------
% i_rfvals evaluate response features and gradient
%---------------------------------------------------------------
function [rf,dG]= i_rfvals(U,b)
% Note: model parameters are automatically available as response features

rf= b(3)*b(1)/exp(1);
      
if nargout>1
   % delrf/delbi
   dG= [b(3)/exp(1), 0, b(1)/exp(1)];
end   


%---------------------------------------------------------------
% i_reconstruct nonlinear reconstruction
%---------------------------------------------------------------
function p= i_reconstruct(U,b,Yrf,dG,rfuser)
% rfuser is an index to the user defined response features
% e.g. rfuser = [1 3 4 5]  tells us which rfs we are coming in with
% so you can figure out which rf's are which
% rfuser <= length(b) means the rf is a parameter

% this solves for linear response features which can be estimated independently 
% of the nonlinear rf.
p= Yrf/dG';

if any(rfuser>size(p,2)) %% we don't just have the params
   if ~any(rfuser==1)
      %% we do not have alpha
      %% we have kappa, so find alpha
      f=find(dG(:,1));
      % find kappa
      p(:,1)=exp(1)*Yrf(:,f)./p(:,3);
  elseif ~any(rfuser==3)
      %% we do not have kappa
      %% we have alpha, so find kappa
      f=find(dG(:,3));
      % find kappa
      p(:,3)=exp(1)*Yrf(:,f)./p(:,1);
   end
end



%---------------------------------------------------------------
% i_evalbuild simulink evaluation block
%---------------------------------------------------------------
function Blk = i_evalbuild(U, b, sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

Blk= add_block('models2/LocalMod/gompEval',[sys,'/gompEval']);

% break library link
set_param(Blk,'linkstatus','none');


%---------------------------------------------------------------
% i_slrecon simulink reconstruction block
%---------------------------------------------------------------
function blk= i_slrecon(U, b, LUM, sname)
% GOMP/SLRECON -  adds the appropriate reconstruct block

blk= add_block(['Models2/Reconstruct/gompRecon'],...
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