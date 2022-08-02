function buildall(r,kernels);
% run through all xregoptmgr options 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 07:54:19 $

if nargin==1
	kernels=0;
end

mbH= MBrowser;
p= mbH.CurrentNode;

r= p.model;
if ~isa(r,'xregrbf')
	error('Current model must be an RBF');
end

klist= {@multiquadric,@recmultiquadric,@gaussian,...
        @thinplate,@logisticrbf,...
        @wendland,@wendland,@wendland,@wendland,...
        @linearrbf, @cubicrbf };
cont= [0 0 0 0 0 0 2 4 6 0 0];

if kernels
	for i=1:length(cont)
		set(r,'kernel',klist{i});
		set(r,'cont',cont(i));
		p.model(r);
		pm= modeldev(r,p);
		% add to tree
		mbH.treeview(pm,'add');
		
		om  = getFitOpt(r);
		recurseOM(pm,{om},mbH);
	end
else
	om  = getFitOpt(r);
	recurseOM(p,{om},mbH);
end
%  now redraw node
mbH.RedrawNode;

function recurseOM(p,omstack,mbH)

om  = omstack{end};
alt = getAltMgrs(om);
n= length(omstack);
r= p.model;
set(r,'fitalg','rbffit');

for i=1:length(alt);
	om= chooseAltMgr(om,i,r);
	omstack{n}= om;
	% make sib
	pm= modeldev(r,p);
	pm.name(alt{i});
	% add to tree
	mbH.treeview(pm,'add');
	disp(pm.fullname)
	
	slist= suboptimMgrs(om);
	if isempty(slist);
		% reached bottom so need to fit
		
		% recurse back up omstack
		oleaf = omstack{n};
		for j= n-1:-1:1
			sj= suboptimMgrs(omstack{j});
			oleaf= set(omstack{j}, sj{1}, oleaf);
		end
		r= setFitOpt(r,oleaf);
		% update om
		pm.model(r);
		% fit model
		pm.fitmodel;
		pm.cleanup;
	else
		% recurse on sub om
		som= get(om,slist{1});
		omstack{n+1}= som;
		recurseOM(pm,omstack,mbH)
	end
end

if p.numChildren>1
	% now choose best model
	Stats= p.childstats;
	[s,bm]= min(Stats(:,end-1),[],1);
	c= p.children(bm(1));
	p.BestModel(c);
end


