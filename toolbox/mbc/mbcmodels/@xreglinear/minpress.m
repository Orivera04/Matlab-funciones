function [om,ok]= minpress(m);
% XREGLINEAR/MINPRESS minimum press least squares fit

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:49:46 $

om= contextimplementation(xregoptmgr,m,@i_minpress,[],'Minimise PRESS',@minpress);

om= AddOption(om,'MaxIter',50,{'int',[1 1000]},'Maximum Iterations');% field to maximum number of iterations
om= AddOption(om,'guidisplay',0,'boolean',[],false);% field to store cost (GCV)
om= AddOption(om,'isinitialised',0,'boolean',[],false);% flag to skip initial fit

ok=1;

function [m,cost,OK,NewStats,B]= i_minpress(m,om,x0,varargin);

disp   = get(om,'guidisplay');
if disp
	ud= x0;
end

OK=1;
maxiter= get(om,'MaxIter');
if ~get(om,'isInitialised')
	[m,OK]= leastsq(m,varargin{:});
end

if OK
	[m,OK,NewStats,B]= stepwise(m);
	% Determine Best Next Step
	NextPress= B(:,end);
	[MinPress,PressInd]= nanmin(NextPress);
	count=1;
	% Limit search to a maximum of 50 steps
	while MinPress < NewStats(1,end) & count<maxiter
		% Do step
		[m,OK,NewStats,B]= stepwise(m,PressInd);
		% Determine Best Next Step
		if OK
			NextPress= B(:,end);
			[MinPress,PressInd]= nanmin(NextPress);
			% Update History Plot
			if disp
				% intermediate display
				feval(ud.UpdateHistory, NewStats,m,gcbf, ud.Hand.HistAxes);
				% Update Anova and Stats Tables
				gui_diagstats(m, 'display',ud.Stats);
				drawnow
			end
		else
			break;
		end
		count=count+1;
	end
	if ~OK
		% recalculate previous iteration (it was OK)
		[m,OK,NewStats,B]= stepwise(m);
	end
	cost= NewStats(1,end);
else
	cost=Inf;
	NewStats=[];
	B=[];
end
	
