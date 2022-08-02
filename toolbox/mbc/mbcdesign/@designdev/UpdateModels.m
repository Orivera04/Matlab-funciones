function DDev= UpdateModels(DDev,m,Stage)
% DESIGNDEV/UPDATEMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:55 $

NF= nfactors(DDev);
Dcell= DesignDev2Cell(DDev);
if nargin==3
	d= Dcell{Stage};
	NF= NF(Stage);
else
	d= Dcell;
	Stage = ':';
end	

if sum(NF)~= nfactors(m)
	if length(d)==1
		des= designobj(m);
		
		d{1}.DesignTree.designs={des};
		d{1}.DesignTree.parents=0;
		d{1}.DesignTree.chosen=1;  
	else
		error('Changing number of factors is not supported for multiple stages')
	end
else
	Xall= xinfo(m);
	[Bnds,g,Tgt]= getcode(m);
	j=1;
	for i=1:length(d)
		Mi= getModel(d{i});
		nf= nfactors(Mi);
		
		ind= j:j+nf-1;
		
		% coding info
		Bi= Bnds(ind,:);
		Gi= g(ind);
		Ti= Tgt(ind,:);
		
		% Input Info
		Xi= Xall;
		Xi.Names   = Xall.Names(ind);
		Xi.Symbols = Xall.Symbols(ind);
		Xi.Units   = Xall.Units(ind);
		
		des= d{i}.DesignTree.designs;
		for k= 1:length(des)
			md= model(des{k});
			
			md= setcode(md,Bi,Gi,Ti);
			md= xinfo(md,Xi);
			des{k}= model(des{k},md);
		end
		d{i}.DesignTree.designs= des;
		
		j= j+nf;
	end
end


Dcell(Stage)= d;
DDev= Cell2DesignDev(Dcell);

