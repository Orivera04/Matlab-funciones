function obj = repack(obj)
%  Synopsis
%     function obj = repack(obj)
%
%     obj is the xregpanellayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:34 $


persistent linespace
if isempty(linespace)
    linespace=[1 1 -2 -2];
end
cdata=get(obj.xregcontainer,'containerdata');
h = cdata.elements;
pos= cdata.innerposition;

% do the 3d etched lines
obj.panel.position = pos;

% pass on sizes to subobjects
% this object only supports one contained object.  Any others are ignored
if length(h)
    ud = obj.rtP.info;
    pos=pos+linespace+ud.borders;
    pos(3:4)=max([1 1],pos(3:4));
    set(h{1},'position',pos);
end
