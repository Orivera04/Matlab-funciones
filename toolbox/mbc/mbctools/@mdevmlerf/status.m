function s= status(md,s,varargin)
%STATUS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:52 $


if nargin==1
	s= status(md.modeldev);
else
	
	if s~=2 
		md = status(md.modeldev,s,varargin{:});
	else
		md.modeldev= status(md.modeldev,s,varargin{:});
	end
	
	mbH= MBrowser;
   if mbH.GUIExists
      % this updates the icon on the modelbrowser tree.
      try 
         mbH.doDrawTree(address(md));
      end
   end
	pointer(md);
	s= md;
end
