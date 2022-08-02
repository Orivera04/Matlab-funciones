function varargout= expgrowth(U,x,varargin)
% xregusermod/EXPGROWTH
%
% varargout= expgrowth(U,x,varargin)
%   
% To use this function the command 
%   U2= mvcheckin(xregusermod,'expgrowth',xtest)
% must be run. The last argument is a column based input matrix to
% test the function. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:06 $



% don't change this section of code
b= double(U);
if isa(x,'double')
   % shortcut for fast eval 
   
   % function definition
   % make sure this is vectorised
   y= b(1) - (b(1)-b(2)).*exp(-b(3)*x);
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
		minbound=[2*eps eps eps]';
		maxbound=[inf inf inf]';
		
        % Initial estimate of alpha
        mY=max(Y);
        r= mY-min(Y);
        % find out if there a number of points very close to the maximum y
        % we are then likely to be very close to the asymtote
        f=    min(length(find(Y-mY > -r*0.01))+1,5);
        alpha= (1 + 10^(-f))*mY;
        
		% Get regression matrix
		Xs = [ones(size(X(:))) X(:)];
		% Find residuals
		ylin= log(alpha-Y);
		p= Xs\ylin;
		beta= alpha-exp(p(1));
		kappa= -p(2);
		% Returned parameter initial values
		param(:,1)= [alpha beta kappa]';
		update(U,param(:,1));
		s(1)= sum((Y-eval(U,X)).^2);
		
		% Initial estimate of alpha
		alpha=0.99*min(Y);
		
		% Make X matrix for regression
		Xs = [ones(size(X(:))) X(:)];
		%% Xs= linx2fx(U,X);
		
		% QR Decomposition
		%[Q,R]=qr(Xs,0);
		% Find residuals
		ylin= log(Y-alpha);
		%p= R\(Q'*ylin);
		p= Xs\ylin;
		beta= alpha+exp(p(1));
		kappa= -p(2);
		% Returned parameter initial values
		param(:,2)= [alpha beta kappa]';
		update(U,param(:,2));
		s(2)= sum((Y-eval(U,X)).^2);
		
		[mi,ind]=min(s);
		param= param(:,ind);
		
		%% final checks that all is well
		OK= OK & isreal(param);
		
		toosmall=find(param<minbound);
		toobig=find(param>maxbound);
		
		param(toosmall)=minbound(toosmall);
		param(toobig)=maxbound(toobig);
	else
		OK= 0;
		param= [NaN NaN NaN]';
	end
   
else
   param=[2 1 1];  %default set
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
LB=[2*eps eps eps]';
UB=[inf inf inf]';

A= [-1 1 0];
c= [0];

% Number of NonLinear constraints
nlcon= 0;

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

ekx= exp(-b(3)*x);

Ja= 1-ekx;
Jb= ekx;
Jk= (b(1)- b(2)).*x.*ekx;

J= [Ja Jb Jk];


%---------------------------------------------------------------
% i_labels user parameter names 
%---------------------------------------------------------------
function c= i_labels(U,b)


c = {'\alpha','\beta','\kappa'};

%---------------------------------------------------------------
% i_char display equation string
%---------------------------------------------------------------
function str= i_char(U,b,fopts)
      
s= get(U,'symbol');
% this can contain TeX expressions supported by HG text objects
str=[sprintf('%.3g - (%.3g-%.3g)*exp(- %.3g*',b([1 1 2 3])), detex(s{1}) ')'];

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
%str= sprintf('%s - (%s - %s)*exp(-(%s*x)^{%s})',lab{1},lab{1},lab{2},lab{3},lab{4});

str= [lab{1},' - (',lab{1} '- ',lab{2},')*exp(-',lab{1},'*',detex(s{1}),')'];


%---------------------------------------------------------------
% i_rfnames  response feature names 
%---------------------------------------------------------------
function [rname, default] = i_rfnames(U,b)
% this doesn't need to be defined  even if you have defined user-specified rfs.

% response feature names 
rname= [];

if nargout>1
    default =  [1:3]; %{'alpha','beta','kappa'};
end

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
% rfuser <= length(b) means the rf is the parameter rfuser

% this solves for linear response features which can be estimated independently 
% of the nonlinear rf.
%  if all response features are linear you don't need to define 'reconstruct'
p= Yrf/dG';
p(:,1)= max(p(:,1),0);
p(:,2)= max(p(:,2),0);
p(:,3)= max(p(:,3),0);

%---------------------------------------------------------------
% i_evalbuild simulink evaluation block
%---------------------------------------------------------------
function Blk = i_evalbuild(U, b, sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

Blk= add_block('models2/LocalMod/expGrowthEval',[sys,'/expGrowthEval']);

% break library link
set_param(Blk,'linkstatus','none');


%---------------------------------------------------------------
% i_slrecon simulink reconstruction block
%---------------------------------------------------------------
function blk= i_slrecon(U, b, LUM, sname)
% GOMP/SLRECON -  adds the appropriate reconstruct block

blk= add_block(['Models2/Reconstruct/linearRecon'],...
   [sname,'/Reconstruct']);

% break library link
set_param(blk,'linkstatus','none');