function T= MakeTemplate(T,IncludeDesigns,IncludeResponses,Tname);
% MDEVTESTPLAN/MAKETEMPLATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:07:23 $


if nargin<2
	IncludeDesigns=1;
end
if nargin<3
	IncludeResponses=1;
end

m= children(T,'model');
for i=1:length(m)
	m{i}= reset(m{i});
end

T= detach(T);
if T.DataLink~=0
	% strip sweepset filter
    T.DataLink= xregpointer;
end
OldP= address(T);

% put on heap in a new location
p= xregpointer( T );
T= info(p);


if nargin>3
    % rename testplan
	T= name(T,Tname);
end

if T.Matched
	% data exists so remove it
	T= AssignData(T,{xregpointer,xregpointer});

	T.Matched   = 0;
	T.Responses = m;
	
	% remove data designs 
	dtree= T.DesignDev(end).DesignTree;
	delDes= false(size(dtree.designs)) ;
	for i=2:length(dtree.designs);
		% really anything with the words Actual Design
		delDes(i) = ~isempty( findstr( name(dtree.designs{i}) ,'Actual Design') );
	end
	% delete designs from tree
	dtree.designs(delDes)= [];
	dtree.parents(delDes)= [];
	if delDes(dtree.chosen)
		% select root design as best
		dtree.chosen=1;
	end
	T.DesignDev(end).DesignTree= dtree;
end

T.ConstraintData = xregpointer;

if ~IncludeDesigns
	for i=1:length(T.DesignDev);
		dtree= T.DesignDev(i).DesignTree;
		dtree.designs = dtree.designs(1);
		dtree.chosen  = 1;
		dtree.parents = dtree.parents(1);
		T.DesignDev(i).DesignTree= dtree;
	end
end
if ~IncludeResponses
	T.Responses= [];
end

% detach from parent and remove 
p= address(T);
T= detach(T);

% remove from heap
p.info=[];
freeptr(p);

