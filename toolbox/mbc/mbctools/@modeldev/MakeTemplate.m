function mlist= MakeTemplate(mdev,fname);
%MAKETEMPLATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:09:40 $




DesignDir = xregGetDefaultDir('Designs');
if nargin== 1
	[fname,pth]= uiputfile(fullfile(DesignDir, '*.mbm'),'Model Template');
	if isnumeric(fname)
		mlist={};
		return
	end
end

[p,f,e]= fileparts(fullfile(pth,fname));
fname= fullfile(p,[f,'.mbm']);
mlist= children(mdev,'model');
save('-mat',fname,'mlist');

