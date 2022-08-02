function tidytree
%TIDYTREE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 06:49:11 $

mbH= MBrowser;
p= mbH.CurrentNode;
resp= questdlg('Where best models have been selected all sub-models will be deleted. Do you want to continue?','Clean-up Tree','Yes','No','Yes');
if strcmp(resp,'Yes')
    OK= mbH.SelectNode(0);
    if OK
        p.tidytree(mbH);
    end
    OK= mbH.SelectNode(p);
end