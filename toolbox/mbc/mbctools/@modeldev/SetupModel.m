function OK = SetupModel(mdev)
%SETUPMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:09:52 $



mbH= MBrowser;

p= address(mdev);



OldModel= model(mdev);
if modelstage(mdev)>1
   [m,OK]=gui_ModelSetup(OldModel,'criteria','global');
else
   [m,OK]=gui_ModelSetup(OldModel);
end	
drawnow

if OK & mbH.SelectNode(xregpointer,1)
   OldMdev= mdev;
   try
      OldName=name(OldModel);
      if ~isempty(strmatch(OldName,name(mdev))) &  ~strcmp(name(m),OldName)
         mdev= name(mdev,name(m));
      end
      mdev= model(mdev,m);
      OK= fitmodel(mdev);
   catch
      xregerror('Model Fit Error'); 
      xregpointer(OldMdev);
   end
   mbH.SelectNode(address(mdev),1);
end




