function  repack(obj,varargin)
%  Synopsis
%     function  repack(obj)
%
%     obj is the packObject
%     
%  Description
%     This function reapplies the packing command to the objects in question
%
%  See Also
%     methods container
%     methods gridLayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:07 $


p=get(obj.xreggridlayout,'position');

ib=obj.g.info.ib;
cs=[max(0,p(3)*0.5-ib(1)) ib(1)+ib(3) max(0,p(3)*0.5-ib(3))];
rs=[max(0,p(4)*0.5-ib(4)) ib(2)+ib(4) max(0,p(4)*0.5-ib(2))];

set(obj.xreggridlayout,'rowsizes',rs,'colsizes',cs);