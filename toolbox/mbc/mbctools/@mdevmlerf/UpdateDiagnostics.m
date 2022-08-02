function mdev= UpdateDiagnostics(mdev,DS);
%UPDATEDIAGNOSTICS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:05:32 $



mdev.DiagStats=DS;

mdev.modeldev= status(mdev.modeldev,1,0);
pointer(mdev);
mbH= MBrowser;
if mbH.GUIExists
	% this updates the icon on the modelbrowser tree.
	try 
		mbH.doDrawTree(address(mdev));
	end
end
