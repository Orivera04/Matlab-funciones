function [s,ColHead]= childstats(L,SubList)
%LOCALMULTI/CHILDSTATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:39:51 $

mdls= get(L,'models');
Nmdls= length(mdls);
if nargin<2
   SubList=cell(Nmdls,1);
end

chead= cell(Nmdls,1);
for i=1:Nmdls
   [MinOrMax,List,UseAsSummary] = summary(mdls{i});
   chead{i}= List(UseAsSummary~=0);
   if length(chead{i})~=length(SubList{i})
      % Make stats all nans
      SubList{i}= NaN*zeros(1,length(chead{i}));
   end
end
OK= ~cellfun('isempty',SubList);

if any(OK)
	OK= find(OK(:)');
	chead= chead(OK);
	
	ColHead= chead{1};

	n= length(OK);
	% find common stats
	ib= cell(n-1,1);
	j=1;
	for i=OK(2:end)
		j=j+1;
		[ColHead,ia,ib{j-1}]=intersect(ColHead,chead{j});
	end
	lenSub= cellfun('prodofsize',SubList(OK));
	lenCol= cellfun('prodofsize',chead);
	
	if all(lenSub==length(ColHead))  
		% all stats the same
		ch= colhead(mdls{OK(end)});
		if ~isempty(ib)
			[i,ib1]=sort(ib{end});
			ColHead= ColHead(ib1);
		end

		s= zeros(length(SubList),length(ColHead));
		s(:)=NaN;
		s(OK,:)= cat(1,SubList{:});
	elseif all(lenCol ==lenSub) 
		s= zeros(length(SubList),length(ColHead));
		s(:)=NaN;
		% Width= ones(1,length(ColHead))/length(ColHead);
		[ColHead,ia,ib1]=intersect(ColHead,chead{1});  
		% rearrange using first row to define order of stats 
		s(OK(1),:) = SubList{OK(1)}(OK(1),ib1);
		j=2;
		for i=OK(2:end)
			if ~isempty(SubList{i}) 
				[c,ia,ib]=intersect(ColHead,chead{j});  
				s(i,:)= SubList{i}(1,ib);
			end
			j=j+1;
		end
		% Sort output
		[ib1,ib1]= sort(ib1);
		ColHead= ColHead(ib1);
		s=s(:,ib1);
	else
		ColHead={};
		s= zeros(length(ch),0);
	end
    
else
	ColHead={};
   s= zeros(length(ch),0);
end

