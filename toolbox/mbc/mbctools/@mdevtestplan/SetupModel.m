function OK = SetupModel(mdev)
% MDEVTESTPLAN/SETUPMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:07:27 $



mbH=MBrowser;
p=mbH.CurrentNode;
View=mbH.GetViewData(p.guid);
OK=1;

T= p.info;

NStages= length(T.DesignDev);
Stage= find(strcmp(get(View.hHSM.hBorder,'selected'),'on'));
if NStages==1 & isempty(Stage)
   Stage= find(strcmp(get(View.hHSM.pBorder,'selected'),'on'));
   if  Stage>NStages
      Stage= NStages;
   end
end
if ~isempty(Stage) 
   fcall= get(View.hHSM.Menu(1),'callback');
   feval(fcall,[],[],Stage);
end
	




