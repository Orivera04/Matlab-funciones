function T=labels(mvp,TeX,reord)
% xregcubic/LABELS coefficient labels for xregcubic
% 
% T=labels(mvp {,TeX,reord})

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:45:24 $



if nargin<2
	TeX=1;
end

% % labels are stored in base model class
labs= get(mvp,'symbol');
if TeX
   labs= detex(labs);
end

if nfactors(mvp)<=1
	np= size(mvp,1);
	T= cell(np,1);
	T{1}= '1';
	if np>1
		T{2}= labs{1};
	end
	for i=2:np-1
		T{i+1}= [labs{1},'^',int2str(i)];
	end
else
	% reorder in descending order
	labs= labs(mvp.reorder);
	T= newlabels(mvp,labs);
end

if nargin<3 || ( nargin>2 && reord)
   T= T(termorder(mvp));
end


% ---------------------------------------
function T= newlabels(m,labs)
% reorder in descending order

MON= monomials(m);
T=cell(length(MON),1);
T{1}= '1';
for i=2:length(MON)
	t= unique(MON{i});
	T{i}= '';
	for j=1:length(t)
		k= t(j);
		f= find(k==MON{i});
		if length(f)==1
			T{i}= [T{i},'*',labs{k}];
		else
			T{i}= [T{i},'*',labs{k},'^',int2str(length(f))];
		end
	end
	T{i}(1)=[];
end

% ---------------------------------------
function T= oldlabels(mvp,labs)

% Constant Term
T={'1'};
for j=1:mvp.N(1)
   % 1st order term 
   T= [T ; labs(j) ];
   for k=j:mvp.N(2)
      % 2nd order terms
      if j==k
         % quadratic term
         T= [T ; {[labs{j},'^2']} ];
      else
         % 2nd order cross term
         T= [T ; {[labs{j},'*',labs{k}]} ];
      end
      for i=k:mvp.N(3)
         % 3rd order terms
         if i==k
            if j==i
               % cubic term
               T= [T ; {[labs{i},'^3']} ];
            else
               % linear x quadratic cross term 
               T= [T ; {[labs{j} '*',labs{i},'^2']} ];
            end
         else
            if j==k
               % quadratic x linear cross term 
               T= [T ; {[labs{j},'^2*',labs{i}]} ];
            else
               % 3rd order cross term
               T= [T ; {[labs{j},'*',labs{k},'*',labs{i}]}];
            end
         end
      end
   end
end
