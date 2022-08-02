function [om,OK]=iteraterols(m)
% XREGRBF/ITERATEROLS iterates rols to select reguarization parameter 
%
%  Lambda selection algorithm for RBFs. Implemented as an xregoptmgr. This
%  is normally a sub xregoptmgr (of e.g trialwidths)
%
%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.11.4.3 $  $Date: 2004/02/09 07:54:52 $

[omNestCent,OK] = rols(m); % make the xregoptmgr for rols 
omNestCent = setAltMgrs(omNestCent,{@rols});% give a choice of center selection algorithms 

om= contextimplementation(xregoptmgr,m,@i_iteraterols,[],'IterateRols',@iteraterols);
om = AddOption(om,'CenterSelectionAlg',omNestCent,'xregoptmgr', 'Center selection algorithm',2);%

% fit parameters

om = AddOption(om,'MaxNumIter',10,{'int',[1,100]}, 'Maximum number of iterations');%number of iterations
om= AddOption(om,'Tolerance',0.005,{'numeric',[eps 1]}, 'Minimum change in log10(GCV)');% stopping criterion
om= AddOption(om,'nTestValues',5,{'int',[0,100]},'Number of initial test values for lambda');%number of test values of lambda
om= AddOption(om,'CheapMode',1,'boolean', 'Do not reselect centers for new width');
om= AddOption(om,'PlotFlag',0,'boolean', 'Display');%plot flag
om= AddOption(om,'cost',Inf,{'numeric',[-Inf,Inf]},[],logical(0));% field to store cost (GCV), not gui-settable
OK = 1;


function  [m,cost,OK,varargout]=i_iteraterols(m,om,x0,x,y,varargin)

% iteraterols will iterate the lambda parameter to minimise
% a model critierion such as GCV or MML
% a different set of centers will be chosen for each value of lambda

%  Inputs:
%				m - rbf object with centers
%				x - matrix of data points 
%				y - target values

% Outputs 
%			   m - new rbf object

%parameters %%%%%%%%%%%%%%%%%%%%% 
plotflag = get(om,'PlotFlag'); % whether to plot or not - set to 0 if using uOptRols or OptRols with this routine
ntest = get(om,'nTestValues'); % number of test values of lambda
niter = get(om,'MaxNumIter'); % number of iterations
tol = get(om,'Tolerance');
cheapflag = get(om,'CheapMode');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
centalg = get(om,'CenterSelectionAlg');

lambda= get(m,'lambda');
m2= m;
m2.centers= x;
PHI= x2fx(m2,x);
if ~isequal(cheapflag,1) 
   % re-choose the centers for the new width
   [m,cost,OK] = run(centalg,m,[],x,y);
   GCV= 10^cost;
else
   GCV= calcGCV(m,x,y);
end

if ntest > 0
   % test several lambda values to determine a rough start-point (based on GCV)
   lamx = logspace(-10,1,ntest);
   log10GCVy = [];
   for i = 1:length(lamx);
      set(m,'lambda',lamx(i));
      % rechoose the centers
      [ms,log10GCVy(i),OK] = run(centalg,m,[],x,y,PHI);  
   end
   [junk,index] = min(log10GCVy);
   newlam = lamx(index); % best lambda from the vector  
else 
   newlam = max(get(m,'lambda'),1e-12);
end    

oldGCV = Inf;
i=1;
diff = Inf;
while i <= niter  & diff> tol & newlam >= 1e-12 & newlam <= 10
   % search for new lambda
   lambda(i) = newlam;
   set(m,'lambda',newlam);
   [m,cost,OK,newlam] = run(centalg,m,[],x,y,PHI);
   GCV(i)= 10^cost;
   % [GCV(i), newlam] = i_calcGCV(W,y,lambda(i));
   if GCV(i)>0
      diff = abs(log10(oldGCV)-log10(GCV(i))); 
   else
      diff = Inf;
   end
   oldGCV = GCV(i); 
   i = i+1;
end
[bestGCV,ind] = min(GCV);
bestlambda =lambda(ind);
set(m,'lambda',bestlambda);
% update the centers for the new lambda
[m,cost,OK] = run(centalg,m,[],x,y,PHI); 
OK =1;

if plotflag == 1 
   plothand =figure('menubar','none',...
      'toolbar','none',...
      'doublebuffer','on',...
      'numbertitle','off',...
      'name','Results of IterateRols',...
      'color',get(0,'defaultuicontrolbackgroundcolor'));
   a = axes('parent',plothand,'XScale','log','ButtonDownFcn', 'mv_zoom');
   line('parent',a,'XData',lambda,'YData',log10(GCV),'Color','r','Marker','o','LineStyle','-');
   line('parent',a,'XData',lambda(1),'YData',log10(GCV(1)),'Color','k','Marker','o','MarkerFaceColor','k','LineStyle','none');
   line('parent',a,'XData',bestlambda,'YData',log10(bestGCV),'Color','g','Marker','*','LineStyle','none');
   mbctitle(a,['Results of IterateRols for Width = ' num2str(m.width)]);
   mbcxlabel(a,'lambda');
   mbcylabel(a,'log10(GCV)');      
end    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [GCV,newlam] = i_calcGCV(m,x,y,lambda,centalg, cheapflag)

N = size(x,1);
% calculate GCV see Intro to rbf networks, M. Orr, pg 25 
% and iterating for the next step
set(m,'lambda',lambda);

%rechoose the centers for the new lambda
[m,cost,OK,newlam] = run(centalg,m,[],x,y);

GCV= 10^cost;
newlam= newlam;



function [GCV,newlam] = i_calcGCV2(W,y,lam);

dw= sum(W.*W,1);
N= length(y);

ee = sum(y.*y) - sum( (((y'*W).^2)./(lam +dw)).*((2*lam + dw)./(lam + dw)));

% calculate df here rather than in qrdecomp
df = N - sum(dw./(dw+lam'));% N - gamma

nu = sum(dw./(dw+lam).^2);
wAw = sum( ((y'*W).^2) ./ ((dw+lam).^3) );
if abs(wAw) > eps & abs(df) > sqrt(eps)
   GCV = N*ee/(df)^2; 
   newlam = (nu/df)*ee/wAw;
else   
   GCV = Inf;
   newlam = 0;   
end            


return

