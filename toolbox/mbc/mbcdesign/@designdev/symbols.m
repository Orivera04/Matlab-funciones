function f= symbols(D,Stage,NewNames);
% DESIGNDEV/SYMBOLS
% 
% f= symbols(D,Stage);
% D= symbols(D,Stage,NewNames);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:04:14 $

d= DesignDev2Cell(D);
if nargin>1
	d= d(Stage);
end
if nargin==2;
	f= {};
	for i=1:length(d)
		des= d{i}.DesignTree.designs{1};
		m= model(des);
		[n,s]= nfactors(m);
		f= [f; s(:)];
	end
else
	Dall= DesignDev2Cell(D);
	d= Dall(Stage);
	j=1;
	for i=1:length(d)
		% update designtree models
		dtree= d{i}.DesignTree.designs;
		% base model
		m= model(dtree{1});
		
		n= nfactors(m);
		nm=NewNames(j:j+n-1);
		m= set(m,'symbols',nm);
		d{i}.BaseModel= m;
		
		for j=1:length(dtree)
			md= set( model(dtree{j}),'symbols',nm);
			dtree{j}= model(dtree{j},md);
		end
		d{i}.DesignTree.designs= dtree;
		
		j= j+n;
	end
	Dall(Stage)= d;
	f= Cell2DesignDev(Dall);
end
	