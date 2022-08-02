function [om,OK]=iterateridge(m)
% XREGRBF/ITERATERIDGE iterates to select reguarisation parameter 
%
%  Lambda selection algorithm for RBFs. Implemented as an xregoptmgr. This
%  is normally a sub xregoptmgr (of e.g trialwidths). This routine is
%  faster than iteraterols.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.12.4.3 $  $Date: 2004/02/09 07:54:51 $

[omNestCent,OK] = rols(m); 


om= contextimplementation(xregoptmgr,m,@i_iterateridge,[],'IterateRidge',@iterateridge);
om = setAltMgrs(om,{@iterateridge,@iteraterols,@stepitrols});
% fit parameters
om = AddOption(om,'CenterSelectionAlg',omNestCent,'xregoptmgr', 'Center selection algorithm',2);% 
om = AddOption(om,'MaxNumIter',10,{'int',[1,100]},'Maximum number of updates');%number of iterations
om= AddOption(om,'Tolerance',0.005,{'numeric',[eps 1]},'Minimum change in log10(GCV)');% stopping criterion
om= AddOption(om,'nTestValues',5,{'int',[0,100]}, 'Number of initial test values for lambda');%number of initial test values of lambda - helps avoid local minima
om= AddOption(om,'CheapMode',1,'boolean', 'Do not reselect centers for new width');% 1 for a cheaper version
om= AddOption(om,'PlotFlag',0,'boolean','Display');%plot flag
om= AddOption(om,'cost',Inf,{'numeric',[-Inf,Inf]},[],logical(0));% field to store cost (GCV), not gui-settable

OK = 1;

function  [m,cost,OK,varargout]=i_iterateridge(m,om,x0,x,y,varargin)
% iterate lambda routine for ridge regression using eigenvalues
% the initial centers are determined using rols.

% once a set of centers and a width has been selected, iteraterols will iterate the lambda parameter to minimise
% a model critierion such as GCV

%  created by Tanya Morton 19/9/2000
%  MathWorks Ltd

%  Inputs:
%				m - rbf object with centers
%				X - matrix of data points 
%				y - target values

% Outputs 
%			   m - new rbf object
%              cost - log10(GCV)
%parameters %%%%%%%%%%%%%%%%%%%%% 
ntest = get(om,'nTestValues'); % number of test values of lambda
niter = get(om,'MaxNumIter'); % number of iterations 
plotflag = get(om,'PlotFlag'); 
centalg = get(om,'CenterSelectionAlg');
cheapflag = get(om,'CheapMode');
tol = get(om,'Tolerance');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%
lambda= get(m,'lambda');
if ~isequal(cheapflag,1) | strcmp(lower(getFitOpt(m,'name')),'iterateridge')
   [m,cost,OK] = run(centalg,m,[],x,y);% rechoose the centers
else
   GCV= calcGCV(m,x,y);
end


% Get the parameters stored in m
width = m.width;%width of the radial basis function
if any(width <0) 
   [m,OK] = defaultwidth(m,x);%set the default width
end 


N = size(x,1);%number of data points

H = x2fx(m,x);
plothand = [];

%from Recent Advances in RBF Networks, Mark Orr, http://www.anc.ed.ac.uk/~mjo/rbf.html   
try 
    [U,D,V] = svd(H);
    D= D(1:size(D,2),:);
catch
    warndlg(lasterr);
end    

threshold = 2*eps*D(1,1).^2;
eigvals = max(diag(D).^2, threshold);
%eigvals = [eigvals; zeros(size(H,1)-size(H,2),1)];

% project y onto the eigenbasis
ytilde = U'*y;

ncenters = size(m.centers,1);
i=1;
diff = Inf;

if plotflag == 1 %make a plot of GCV against lambda
    lamx = logspace(-10,0,50);
    [GCVy,newlamx] = i_calcGCV(lamx,eigvals,ytilde, N);
    plothand =figure('menubar','none',...
        'toolbar','none',...
        'doublebuffer','on',...
        'numbertitle','off',...
        'name','Results of IterateRidge',...
        'color',get(0,'defaultuicontrolbackgroundcolor'));
    a = axes('parent',plothand,'ButtonDownFcn', 'mv_zoom','XScale','log');
    line('parent',a,'XData',lamx,'YData',log10(GCVy),'Color','b');
    mbctitle(a,['Results of IterateRidge for Width = ' num2str(m.width)]);
    mbcxlabel(a,'Lambda');
    mbcylabel(a,'log10(GCV)');
end

if ntest > 0 
    %test several lambda values
    lamx = logspace(-10,0,ntest);% upper bound changed from 1 to 0
    [GCVy,newlamx] = i_calcGCV(lamx,eigvals,ytilde, N);
    [GCV,index] = min(GCVy);
    newlam = lamx(index); % best lambda from the vector
else
    newlam = max(1e-12,get(m,'lambda'));
end    
oldGCV = Inf;% lowest GCV out of tested lambdas
while i <= niter  & diff> tol & newlam >= 1e-12 & newlam <= 10
    lambdaseq(i) = newlam;
    [GCVseq(i), newlam] = i_calcGCV(lambdaseq(i), eigvals, ytilde,N);
    if GCVseq(i)>0
       diff = abs(log10(GCVseq(i)) - log10(oldGCV));
    else
       diff= Inf;
    end
    oldGCV = GCVseq(i); 
    i = i+1;
end    
      

if plotflag == 1 
   if isempty(plothand)
      plothand =figure('menubar','none',...
         'toolbar','none',...
         'doublebuffer','on',...
         'numbertitle','off',...
         'name','Results of IterateRidge',...
         'color',get(0,'defaultuicontrolbackgroundcolor'));
      a = axes('parent',plothand,'ButtonDownFcn', 'mv_zoom','XScale','log'); 
      axes(a);
      xlabel('lambda');
      ylabel('log10(GCV)');
      title('Results of IterateRidge');
   end
   line('parent',a,'XData',lambdaseq,'YData',log10(GCVseq),'Color','r','Marker','x','LineStyle','-');
   line('parent',a,'XData',lambdaseq(1),'YData',log10(GCVseq(1)),'Color','k','Marker','o','MarkerFaceColor','k','LineStyle','none');
   line('parent',a,'XData',lambdaseq(end),'YData',log10(GCVseq(end)),'Color','g','Marker','*','LineStyle','none');
end
lambda =lambdaseq(end);
set(m,'lambda',lambda);
cost = log10(GCVseq(end));

m = update(m,[1:size(m.centers,1)]);% set the coefficients to be the right length

set(m,'qr','ridge');
[Q,R,OK]= qrdecomp(m,H);
b= R\(Q'*y);
m = update(m,b);% set the coefficients to be the right length

% [m,OK] = calcWeights(m,x,y); % initialise the model and get the coefficients

OK =1;  
   

function [GCV,newlam] = i_calcGCV(lambda, eigvals, ytilde,N)
% calculate GCV using eigenvalues from optimising the widths.....

p = size(eigvals,1);
eigvalslong = [eigvals; zeros(N-p,1)];
ytildeshort = ytilde(1:p);

for i = 1:length(lambda)        
    % need to make this calculation more accurate when eigvals close to zero
    nu = sum(eigvals./(eigvals + lambda(i)).^2);
    denom = sum(lambda(i)./((eigvalslong + lambda(i)))); %N - gamma
    wAw = sum(eigvals.*(ytildeshort.^2)./(eigvals + lambda(i)).^3);
    ee = sum(lambda(i)^2*(ytilde.^2)./(eigvalslong + lambda(i)).^2);
    newlam(i) = (nu/denom)*ee/wAw;
    GCV(i)  = N*ee/((denom)^2);
end
return


