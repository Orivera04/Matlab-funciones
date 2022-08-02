function pdatum= datumlink(mdev)
% MODELDEV/DATUMLINK  link to other Datum

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:09 $

% datumlink is defined at the Response Model Node (Level 3 of MBrowser tree)
p= address(mdev);
q= p.Parent;
if q~=0;
	par= q.Parent;
	if par ~= 0
		while par.Parent~=0;
			p= q;
			q= par;
			par=par.Parent;
		end
		pdatum= p.dataptr('Data');
	else
		% level 2
		pdatum= xregpointer;
	end
else
	% level 1
	pdatum= xregpointer;
end

