function [om,ok]= forwardselect(m);
% XREGLINEAR/FORWARDSELECT forward selction stepwise

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:49:30 $

om= contextimplementation(xregoptmgr,m,@i_run,[],'Forward Selection',@forwardselect);
% swap the two lines below to enable more algorithms!
% om = setAltMgrs(om,{@minpress,@forwardsel,@backwardsel,@ols});

om= AddOption(om,'alpha',95,{'numeric',[70 100]},'Alpha (%)');               % significance level
om= AddOption(om,'MaxIter',50,{'int',[1 1000]},'Maximum Iterations');             % field to maximum number of iterations
om= AddOption(om,'RemoveAll',1,'boolean','Remove all terms first'); % flag to skip initial fit
om= AddOption(om,'isinitialised',0,'boolean',[],false); % flag to skip initial fit
om= AddOption(om,'guidisplay',0,'boolean',[],false);       % called from gui so display intermediate results

ok=1;

function [m,cost,OK,NewStats,B]= i_run(m,om,x0,varargin);

disp   = get(om,'guidisp');
alpha= get(om,'alpha');
maxiter= get(om,'MaxIter');
OK=1;
if disp
	% from stepwise gui
	ud= x0;
	CritVals= ud.crit;
	crit= CritVals;
else
	if ~get(om,'isInitialised')
		[m,OK]= leastsq(m,varargin{:});
	end
	Nobs = size(m.Store.y,1);
	crit= i_Calctinv(alpha,1:Nobs);
end

if OK
	if get(om,'RemoveAll')
		% All Terms left out of model
		OutModel = true(size(m));
		[m,OK,NewStats,B]= stepwise(m,OutModel);
	else
		% use current terms
		[m,OK,NewStats,B]= stepwise(m);
	end
	
	[Bint,CritVals]= i_CIntervals(B,crit,alpha);
	InSig = Bint(:,1)<0 & Bint(:,2)>0;
	
	count=1;
	SigTerms= Terms(m);
	while OK & ~all( SigTerms(~InSig) ) & count < maxiter
		SigTerms = SigTerms | ~InSig;
		
		[m,OK,NewStats,B]= stepwise(m,~SigTerms);
		
		[Bint,CritVals]= i_CIntervals(B,crit,alpha);
		% detemine statistically insignificant terms in model
		InSig = Bint(:,1)<0 & Bint(:,2)>0;
		
		SigTerms= Terms(m);
		
		count= count + 1;
	end	
	
	% 
	cost= NewStats(1,end);
else
	cost=Inf;
	NewStats=[];
	B=[];
end


function [Bint,crit]= i_CIntervals(B,CritVals,alpha)

beta= B(:,1);
crit= zeros(size(beta));
df= B(:,3);
intdf= df==fix(df);
crit(df(intdf)>1)= CritVals(df(intdf)>1);
if ~all(intdf) 
	if ~any(df(~intdf)<10)
		% use linear interpolation for non-integer
		fdf= floor(df(~intdf));
		cdf= ceil(df(~intdf));
		crit(~intdf)= CritVals(fdf)+ (df(~intdf)-fdf)./(cdf-fdf).*(CritVals(cdf)-CritVals(fdf));
	else
		% except if df <10, when you should recalculate tinv
		sigprob= 1-alpha/2/100;
		crit(~intdf)=  i_Calctinv(sigprob,df(~intdf));
	end
end
% calculate confidence intervals and tcrit values
Bint= [B(:,1)-crit.*B(:,2) B(:,1)+crit.*B(:,2)];



%------------------------------------------------------------------------
% SUBFUNCTION i_Calctinv
%------------------------------------------------------------------------
function crit= i_Calctinv(alpha,df);

sigprob= 1-alpha/200;
df= df(:);
crit= zeros(size(df));
if max(df)>100
   crit(df<100)  = tinv(sigprob,df(df<100));
   crit(df>=100) = norminv(sigprob);
else
   crit=  tinv(sigprob,df);
end


