function f= units(D,Stage,NewNames);
% DESIGNDEV/UNITS
% 
% f= units(D,Stage);
% D= units(D,Stage,NewNames);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:04:15 $

d= DesignDev2Cell(D);
if nargin>1
	d= d(Stage);
end
if nargin<=2;
	f= {};
	for i=1:length(d)
		des= d{i}.DesignTree.designs{1};
		m= model(des);
		[n,s,u]= nfactors(m);
		f= [f; u(:)];
	end
else
	Dall= DesignDev2Cell(D);
	d= Dall(Stage);
	k=1;
	for i=1:length(d)
		% update designtree models
		dtree= d{i}.DesignTree.designs;
		% base model
		m= model(dtree{1});
		
		n= nfactors(m);
		nm= NewNames(k:k+n-1);
		xi= xinfo(m);
		xi.Units= nm;
		
		for j=1:length(dtree)
			md= xinfo(model(dtree{j}),xi);
			dtree{j}= model(dtree{j},md);
		end
		d{i}.DesignTree.designs= dtree;
		
		k= k+n;
	end
	Dall(Stage)= d;
	f= Cell2DesignDev(Dall);
end