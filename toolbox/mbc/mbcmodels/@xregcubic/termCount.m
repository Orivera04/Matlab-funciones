function mvp= termCount(mvp,order,MaxInteract);
%TERMCOUNT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:46:42 $




if nfactors(mvp)>1
	% Number of cubic, quadratics, linear factors 
	mord= max([order,3]);
	reord=[];
	for i=0:mord
		reord= [find(order==i) reord];
	end
	% Factors must be reordered from highest to lowest order
	% Note flipup(sort(order)) is not used as order is changed too much
	mvp.reorder= reord;
	
	N= zeros(1,mord);
	N(end)= sum(order==mord);
	for i= mord-1:-1:1
		N(i)= sum(order>=i);
	end
	mvp.N = N;
	
	
	% This loop is the standard nested loop for xregcubic
	% Here it is used to count number of coefficients 
	% This could be generalised with a recursive function
	N2=N;
	N2(MaxInteract+1:end)=0;
	len= i_counter(N2,1,1);
	
	len= len + sum(N(MaxInteract+1:end));
	
	mvp.MaxInteract= MaxInteract;
else
	if ~isempty(order)
		len= order+1;
		mvp.MaxInteract= order;
		mvp.N= zeros(1,max(order,3));
		mvp.N(1:order)= 1;
		mvp.reorder=1;
	else
		mvp.MaxInteract= 0;
		mvp.N= zeros(1,3);
		len=0;
	end
end

mvp= update(mvp,1:len);


% recusive counter
function len= i_counter(N,lvl,st)

mord= length(N);
len=1;
for i=st:N(lvl)
	if lvl<mord;
		len= len + i_counter(N,lvl+1,i);
	else
		len= len+1;
	end
end