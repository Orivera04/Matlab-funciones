function s=status(mdev,s,Climb)
%STATUS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:11:00 $

if nargin>1
	% set the status
	if nargin<3
		Climb=1;
	end

	
	pCurrent= address(mdev);
	p= Parent(mdev);
	if p~=0 & Climb~=0
		mdevParent=info(p);
		hb= hasBest(mdev);
		if hb & numChildren(mdevParent)==1 & s==1 & ...
				(~isa(mdevParent,'mdevtestplan')) & ~isa(mdevParent,'mdev_local')
			% has best model + only one child + set status to 1
			% copy up tree and make best model
			
			mdev.Status=s;
			pointer(mdev);
		
			mdevParent=BestModel(mdevParent,pCurrent,pCurrent);
			% change status to 2
			mdev=info(mdev);
			mdev.Status=2;
			pointer(mdev);
			
			% recurse up tree
			mdevParent= status(mdevParent,s);

		elseif isbest(mdev) & s~=2
			% 
			mdev.Status=s;
			pointer(mdev);
			% unassign best model for parent
			mdevParent= BestModel(mdevParent,xregpointer,pCurrent);
			% recurse up tree
			mdevParent= status(mdevParent,s);
		else 
			mdev.Status=s;
			pointer(mdev);
		end
	else
		mdev.Status=s;
		pointer(mdev);
   end
	
	% make sure you return the dynamic copy of the mdev object
	mdev=info(mdev);
	mbH= MBrowser;
   if mbH.GUIExists
      % this updates the icon on the modelbrowser tree.
      try 
         mbH.doDrawTree(address(mdev));
      end
   end
   s= mdev;
else
	% output the status
   s= mdev.Status;
end
   
