function hands= globalbuttons(m,fH,View)
% XREGMODEL/GLOBALBUTTONS  global buttons

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/04/04 03:30:18 $



if ishandle(fH)
   action='create';
else
   action=fH;
end
switch lower(action)
case 'create'
   hands ={};
case 'id'
   hands='model';
   
case 'toolbar'
   hands = [];
   
case 'utilities'
   hands=[];
   
end