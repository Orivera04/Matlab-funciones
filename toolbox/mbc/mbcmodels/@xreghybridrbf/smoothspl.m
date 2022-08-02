function [om,OK]= smoothspl(m,x);
%SMOOTHSPL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:48:24 $
 
if nargin == 1
    N = 100;
else
    N = size(x,1); % number of data points
end    
om= contextimplementation(xregoptmgr,m,@i_smoothspl,[],'smoothspl',@smoothspl);
om= AddOption(om,'PlotFlag',0,'boolean');% 1 for plotting
om= AddOption(om,'MaxNCenters',N,{'int',[N N]},[],false);% percentage of data taken as centers - default 20 centers
om= AddOption(om,'PercentCandidates',100,{'numeric',[100 100]},[],false);% number of candidate centers,take min(N,200)
om= AddOption(om,'cost',Inf,{'numeric',[-Inf,Inf]},[],false);% field to store cost (GCV), not gui-settable

OK = 1;

function [m,cost,OK,varargout] = i_smoothspl(m,om,x0,x,y,varargin)


%  fit algorithm for a smoothing spline. 
%  Implemented from Chapter 2.1 of
%	Hardy, S. (1998) Smoothing Spline Methods for Response Surfaces: 
% 	Smoothing Test and Model Selection,

%  requires number of global factors <8 for the moment  
%  created by Tanya Morton 19/10/2000
%  MathWorks Ltd

%  Inputs:
%				m - rbf object with centers
%				x - matrix of data points 
%				y - target values

% Outputs 
%			   m - new rbf object

set(m,'qr','smooth');
m.rbfpart = set(m.rbfpart,'centers',x);
ncenters = size(x,1);
t = size(m.linearmodpart,1);% number of xreglinear terms

lambda = get(m,'lambda');   

if lambda <= 0 
    warning('Lambda must be positive for smoothing splines. Setting lambda = 1e-4');
    set(m,'lambda',1e-4);
    lambda = 1e-4;
end
    
width = get(m.rbfpart,'width');%width of the radial basis function
N = size(x,1);%number of data points
if width <0 | length(width) > 1
   [m.rbfpart,OK] = defaultwidth(m.rbfpart,x);%set the default width
end 


%set up rbf regression matrix M
FX = x2fx(m,x); % make the regression matrix with both poly + rbf terms
M = FX(:,t+1:end);%rbf regression matrix
T = FX(:,1:t);%polynomial regression matrix (t terms)


[F1,R,OK]= qrdecomp(T);%find F1 (Q) and R
F2 = null(T');%find a matrix orthogonal to the column space i.e. F2'*T=0
J = [T M*F2];
H = zeros(ncenters,ncenters);
H(t+1:ncenters,t+1:ncenters) = F2'*M*F2;
R = chol(J'*J +1e-14*eye(size(J,1)));
B = inv(R);% so inv(B'*B)= X'*X
[U,D,V] = svd(B*H*B');
G = B*inv(U);
w= G*inv(eye(size(D)) +lambda*D)*G'*J'*y; % this requires that M and hence H is pd

P = inv(J'*J + lambda(end)*H);
w = P*J'*y;%compute the parameters
polyBeta = w(1:t,:);
rbfBeta = F2*w(t+1:ncenters,:);
Beta = [polyBeta; rbfBeta];
m.linearmodpart = update(m.linearmodpart, polyBeta);
m.rbfpart = update(m.rbfpart, rbfBeta);

m = update(m,Beta);
TermStatus = 3*ones(t + ncenters,1);%set all of them to 3
m = set(m,'status',TermStatus);
m.linearmodpart = set(m.linearmodpart,'status',TermStatus(1:t,1));
m.rbfpart = set(m.rbfpart,'status',TermStatus(t+1:end,1));


cost = log10(calcGCV(m,x,y));% calculate GCV
setFitOpt(m,'cost',cost);
