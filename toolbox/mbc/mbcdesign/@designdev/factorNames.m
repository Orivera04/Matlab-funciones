function f= factorNames(D,Stage,NewNames);
% DESIGNDEV/FACTORNAMES
% 
% f= factorNames(D,Stage);
% D= factorNames(D,Stage,NewNames);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:04 $

d= DesignDev2Cell(D);
if nargin>1
	d= d(Stage);
end
if nargin<=2;
	f= {};
	for i=1:length(d)
		des= d{i}.DesignTree.designs{1};
		m= model(des);
		f= [f; factorNames(m)];
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
		
		for j=1:length(dtree)
			md= factorNames( model(dtree{j}) , nm);
			dtree{j}= model(dtree{j},md);
		end
		d{i}.DesignTree.designs= dtree;
		
		% update design
		md= model(d{i}.design);
		md= factorNames(md,nm);
		d{i}.design= model(d{i}.design,md);
		
		k= k+n;
	end
	Dall(Stage)= d;
	f= Cell2DesignDev(Dall);
end