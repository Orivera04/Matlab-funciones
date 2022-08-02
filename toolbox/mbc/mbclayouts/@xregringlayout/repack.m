function  repack(obj)
%  Synopsis
%     function  repack(obj)
%     
%  Description
%     This function reapplies the packing command to the objects in question
%
%  See Also
%     methods xregcontainer
%     methods xregringlayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:44 $

ud=obj.g.info;
h = get(obj.xregcontainer,'elements');
p = get(obj,'position');
rmax = min(p(3),p(4))/2 * ud.radiusratio;
centerBox = p(1:2) + p(3:4)/2;


l = length(h);
if l>0
   pos1 = get(h{1},'position');
   set(h{1},'position',[(centerBox - pos1(3:4)/2) pos1(3:4)]);
end
range = linspace(0,2*pi,l-1) + ud.phase;
k=1;
for th = range
   k = k + 1;
   poshk = get(h{k},'position');
   posnewhk = centerBox + rmax*[cos(th) sin(th)] - poshk(3:4)/2;
   posnewhk = [posnewhk poshk(3:4)];
   set(h{k},'position',posnewhk);
end
