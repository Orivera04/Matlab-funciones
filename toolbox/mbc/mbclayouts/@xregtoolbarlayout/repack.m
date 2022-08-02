function obj = repack(obj)
%  Synopsis
%     function obj = repack(obj)
%     
%  Description
%     This function reapplies the packing command to the objects in question

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:25 $



cdata=get(obj.xregcontainer,'containerdata');
h = cdata.elements;
pos= cdata.innerposition;
tbHT=obj.tb.DesiredHeight;
sw=obj.rtP.info.SpacerW;

pnlpos = [pos(1) pos(2)+pos(4)-tbHT-2 pos(3) tbHT+2];
set(obj.panel,'position',pnlpos);
set(obj.tb, 'position', pnlpos+[1 1 -2 -2]);
if sw
   vis=get(obj.panel,'visible');
   set(obj.spacer,'visible',vis,'position',[pos(1) pos(2)+pos(4)-tbHT-2-sw pos(3) sw]);   
else
   set(obj.spacer,'visible','off'); 
end

% pass on sizes to subobjects
% this object only supports one contained object.  Any others are ignored
if length(h)
   set(h{1},'position',pos-[0 0 0 tbHT+2+sw]);
end
