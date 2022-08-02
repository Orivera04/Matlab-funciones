function obj = repack(obj)
%  Synopsis
%     function obj = repack(obj)
%     
%  Description
%     This function reapplies the packing command to the objects in question

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:36:39 $

cdata=get(obj.xregcontainer,'containerdata');
h = cdata.elements;
pos= cdata.innerposition;
ud = obj.ptr.info;

decpos = cell(3,1);
decpos{2} = [pos(1)+1 pos(2)+pos(4)-ud.titleheight-1 pos(3)-2 ud.titleheight];
decpos{3} = decpos{2} + [3 2 -5 -4]+ ud.titleborder;
if ud.divider
    % Outer panel directly surrounds the inner panel
    decpos{1} = decpos{2} + [-1 -1 2 2];
    
    % Set position of divider strip that will overlay any background patch
    ud.dividerhandle.position = [pos(1) decpos{1}(2)-2 pos(3) 2];
else
    % Outer panel goes around teh center object
    decpos{1} = pos;
end

set([obj.outerpanel;obj.ttlpanel;obj.title],{'position'},decpos);
% pass on sizes to subobjects
% this object only supports one contained object.  Any others are ignored
if length(h)
    if ud.divider
        pos = pos + [0 0 0 -4-ud.titleheight];
    else
        pos = pos+[1 1 -2 -2-ud.titleheight];
    end
    pos(3:4) = max([1 1],pos(3:4));
    set(h{1},'position',pos);
end
