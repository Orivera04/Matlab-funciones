function MON= monomials(m);
%MONOMIALS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:45:26 $



if nfactors(m)>1
	N= m.N;
	m.N(m.MaxInteract+1:end)=0;
	MON= i_recurse(m,1,1);
	nx= sum(N(m.MaxInteract+1:end));
	if nx>0
		p= length(MON);
		MON= [MON cell(1,nx)];
		for i=m.MaxInteract+1:length(N)
			for j=1:N(i)
				p=p+1;
				MON{p}= j*ones(1,i);
			end
		end
	end
else
	MON= cell(1,size(m,1));
	for i=1:length(MON)
		MON{i}= ones(1,i-1);
	end
end


function Y= i_recurse(m,lvl,st)

mord= length(m.N);
Y={[]};
for i=st:m.N(lvl)
	if lvl < mord
		Yi= i_recurse(m,lvl+1,i);
		p= length(Y)+1;
		Y= [Y cell(1,length(Yi))];
		for j=1:length(Yi)
			Y{p}= [i Yi{j}];
			p=p+1;
		end		
	else
		Y= [Y {i}];
	end
end