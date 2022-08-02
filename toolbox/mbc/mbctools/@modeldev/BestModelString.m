function s= BestModelString(mdev);
% MODELDEV/BESTMODELSTRING

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:24 $

s='';
p= mdev.BestModel;
if p==0
	if numChildren(mdev)>0
		s='No best model is selected';
	else
		% at bottom of tree - try to find which model is best
		mdp=mdev;
		isBest= 1;
		while isBest & mdp.Status==2;
			pchild= address(mdp);
			mdp= info(Parent(mdp));
			bm= mdp.BestModel;
			if isa(bm,'xregpointer') 
				isBest= bm==pchild;
			elseif bm~=0
				% local regression node
				rind= ResponseFeatures(mdp);
				if ~isempty(rind)
					isBest= any(children(mdp,rind(bm,:)+RFstart(mdp.Model))==pchild);
				end
			else
				isBest= 0;
			end
		end
		isBest= isBest & address(mdp)~=address(mdev);
		if isBest
			bmodel= BestModel(mdp);
			if isa(bm,'twostage') | isa(bm,'localmod')
				s= [name(mdev), ' is part of the twostage model for ''',fullname(mdp),''''];
			else
				s= [name(mdev), ' is the best model for ''',fullname(mdp),''''];
			end
		else
			s='';
		end
	end
else
	s= ['''',p.fullname ,''' is the best model for ',name(mdev)];
end
