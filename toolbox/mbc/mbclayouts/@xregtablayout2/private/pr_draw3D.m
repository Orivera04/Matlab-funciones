function pr_draw3d(obj)
% PR_DRAWsD   Private drawing function for tabs
%
%   PR_DRAW3D(OBJ) draws the tabs for the tablayout OBJ
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:37:15 $


ud=get(obj.whiteline,'userdata');
if ud.buttonloc==0
   pos=get(obj,'innerposition')-[2 2 -4 -24]-ud.innerborder;  % the extra points are taken already for the tabs!
elseif ud.buttonloc==1
   pos=get(obj,'innerposition')-[2 22 -4 -24]-ud.innerborder;  % the extra points are taken already for the tabs!
end

t_ext = ud.tabextents;
sel = get(obj.xregcardlayout,'currentcard');

% first check the extents don't go beyond the current position width
% if they do, then scale extents to fit as best as possible.
sum_t_ext =sum(t_ext);
if sum_t_ext>(pos(3)-2)
   t_ext = (pos(3)-2).*t_ext./sum_t_ext;
end

ntabs = length(t_ext);
len_to_sel = [1 cumsum(t_ext)];

rendmode=get(get(obj.axes,'parent'),'renderer');

p4=pos(4);
p3=pos(3);

switch lower(rendmode)
case 'painters'
   switch ud.buttonloc
   case 0
      [whtx, whty, ltx, lty, drkx, drky, blkx, blky, ptchx, ptchy]=i_painters0(len_to_sel,ntabs,sel,p3,p4);
   case 1
      [whtx, whty, ltx, lty, drkx, drky, blkx, blky, ptchx, ptchy]=i_painters1(len_to_sel,ntabs,sel,p3,p4);
   end
   
otherwise
   switch ud.buttonloc
   case 0
      [whtx, whty, ltx, lty, drkx, drky, blkx, blky, ptchx, ptchy]=i_zbuffer0(len_to_sel,ntabs,sel,p3,p4);
   case 1
      [whtx, whty, ltx, lty, drkx, drky, blkx, blky, ptchx, ptchy]=i_zbuffer1(len_to_sel,ntabs,sel,p3,p4);
   end
end



set([obj.bgpatch;obj.lightline;obj.whiteline;obj.darkline;obj.blackline],...
               'visible','off');
% draw lines
set(obj.whiteline,'xdata',whtx+pos(1)-1,'ydata',whty+pos(2)-1);
set(obj.darkline,'xdata',drkx+pos(1)-1,'ydata',drky+pos(2)-1);
set(obj.blackline,'xdata',blkx+pos(1)-1,'ydata',blky+pos(2)-1);
set(obj.lightline,'xdata',ltx+pos(1)-1,'ydata',lty+pos(2)-1);
set(obj.bgpatch,'xdata',ptchx+pos(1)-1,'ydata',ptchy+pos(2)-1,'zdata',-1*ones(size(ptchx)));


if ud.visible
   set([obj.bgpatch;obj.whiteline;obj.lightline;obj.darkline;obj.blackline],...
      'visible','on');
end




function [whtx, whty, ltx, lty, drkx, drky, blkx, blky, ptchx, ptchy]=i_painters0(len_to_sel,ntabs,sel,p3,p4)
% this renderer misses the final pixel off lines!
% data for main frame
whtx = [1 1 len_to_sel(sel) NaN len_to_sel(sel+1)+3 p3];
whty = [2 p4-20 p4-20  NaN p4-20 p4-20];
ltx = [2 2 len_to_sel(sel)+2 NaN len_to_sel(sel+1)+2 p3-1];
lty = [3 p4-21 p4-21 NaN p4-21 p4-21];
drkx = [p3-1 p3-1 1];
drky = [p4-21 2 2];
blkx = [p3 p3 0];
blky = [p4-20 1 1];
ptchx = [p3 p3 1 1];
ptchy = [p4-20 1 1 p4-20];

% loop over all tabs
for n = 1:ntabs
   lsn=len_to_sel(n);
   lsn1=len_to_sel(n+1);
   if n==sel
      % selected tab: bigger
      whtx = [whtx NaN lsn+[0 0 2] lsn1+2];
      whty = [whty NaN p4-[20 2 0 0]];
      ltx = [ltx NaN lsn+[1 1 2] lsn1+2];
      lty = [lty NaN p4-[20 2 1 1]];
      drkx = [drkx NaN lsn1+[2 2]];
      drky = [drky NaN p4-[20 1]];
      blkx = [blkx NaN lsn1+[3 3 1]];
      blky = [blky NaN p4-[20 2 1]];
      ptchx = [ptchx lsn+[0 0 2] lsn1+[1 3 3]];
      ptchy = [ptchy p4-[20 2 0 0 2 20]];
   elseif n==(sel-1)
      % tab before selected - lose right edge
      whtx = [whtx NaN lsn+[2 2 4] lsn1];
      whty = [whty NaN p4-[20 4 2 2]];
      ltx = [ltx NaN lsn+[3 3 4] lsn1];
      lty = [lty NaN p4-[20 4 3 3]];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-1 1 1]];
      ptchy = [ptchy p4-[20 4 2 2 4 20]];
   elseif n==(sel+1)
      % tab after selected - lose left edge
      whtx = [whtx NaN lsn+4 lsn1];
      whty = [whty NaN p4-[2 2]];
      drkx = [drkx NaN lsn1+[0 0]];
      drky = [drky NaN p4-[19 3]];
      blkx = [blkx NaN lsn1+[1 1 -1]];
      blky = [blky NaN p4-[19 4 3]];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-1 1 1]];
      ptchy = [ptchy p4-[20 4 2 2 4 20]];
   else
      % normal unselected tab
      whtx = [whtx NaN lsn+[2 2 4] lsn1];
      whty = [whty NaN p4-[20 4 2 2]];
      ltx = [ltx NaN lsn+[3 3 4] lsn1];
      lty = [lty NaN p4-[20 4 3 3]];
      drkx = [drkx NaN lsn1+[0 0]];
      drky = [drky NaN p4-[19 3]];
      blkx = [blkx NaN lsn1+[1 1 -1]];
      blky = [blky NaN p4-[19 4 3]];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-1 1 1]];
      ptchy = [ptchy p4-[20 4 2 2 4 20]];
   end
end
return



function [whtx, whty, ltx, lty, drkx, drky, blkx, blky, ptchx, ptchy]=i_painters1(len_to_sel,ntabs,sel,p3,p4)
% this renderer misses the final pixel off lines!
% data for main frame
whtx = [1 1 p3];
whty = [22 p4 p4];
ltx = [2 2 p3-1];
lty = [23 p4-1 p4-1];
if sel==1
   drkx = [len_to_sel(sel+1)+3 p3-1 p3-1];
   drky = [22 22 p4];
   blkx = [len_to_sel(sel+1)+4 p3 p3];
   blky = [21 21 p4+1];  
else
   drkx = [2 len_to_sel(sel)+1 NaN len_to_sel(sel+1)+3 p3-1 p3-1];
   drky = [22 22 NaN 22 22 p4];
   blkx = [1 len_to_sel(sel) NaN len_to_sel(sel+1)+4 p3 p3];
   blky = [21 21 NaN 21 21 p4+1]; 
end
ptchx = [p3 p3 1 1];
ptchy = [21 p4 p4 21];

% loop over all tabs
for n = 1:ntabs
   lsn=len_to_sel(n);
   lsn1=len_to_sel(n+1);
   if n==sel
      % selected tab: bigger
      whtx = [whtx NaN lsn lsn];
      whty = [whty NaN 3 22];
      ltx = [ltx NaN lsn+1 lsn+1];
      lty = [lty NaN 3 23];
      drkx = [drkx NaN lsn+2 lsn1+[3 NaN 3 3]];
      drky = [drky NaN  2 2 NaN 3 22];
      blkx = [blkx NaN lsn+[1 2] lsn1+[2 3 4 4]];
      blky = [blky NaN 2 1 1 2 3 21];
      ptchx = [ptchx lsn+[0 0 2] lsn1+[1 3 3]];
      ptchy = [ptchy 21 3 1 1 3 21];
   elseif n==(sel-1)
      % tab before selected - lose right edge
      whtx = [whtx NaN lsn+[2 2]];
      whty = [whty NaN 5 21];
      ltx = [ltx NaN lsn+[3 3]];
      lty = [lty NaN 5 21];
      drkx = [drkx NaN lsn+4 lsn1];
      drky = [drky NaN 4 4];
      blkx = [blkx NaN lsn+[3 4] lsn1];
      blky = [blky NaN 4 3 3];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-2 0 0]];
      ptchy = [ptchy 21 5 3 3 5 21];
   elseif n==(sel+1)
      % tab after selected - lose left edge
      drkx = [drkx NaN lsn+4 lsn1+[0 1 1]];
      drky = [drky NaN 4 4 5 21];
      blkx = [blkx NaN lsn+4 lsn1+[0 2 2]];
      blky = [blky NaN 3 3 5 21];
      ptchx = [ptchx lsn+[3 3 5] lsn1+[-1 1 1]];
      ptchy = [ptchy 21 5 3 3 5 21];
   else
      % normal unselected tab
      whtx = [whtx NaN lsn+[2 2]];
      whty = [whty NaN 5 21];
      ltx = [ltx NaN lsn+[3 3]];
      lty = [lty NaN 5 21];
      drkx = [drkx NaN lsn+4 lsn1+[0 1 1]];
      drky = [drky NaN 4 4 5 21];
      blkx = [blkx NaN lsn+[3 4] lsn1+[0 2 2]];
      blky = [blky NaN 4 3 3 5 21];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-1 1 1]];
      ptchy = [ptchy 21 5 3 3 5 21];
   end
end
return



function [whtx, whty, ltx, lty, drkx, drky, blkx, blky, ptchx, ptchy]=i_zbuffer0(len_to_sel,ntabs,sel,p3,p4)
% zbuffer works correctly.  OpenGL is too broken to fix!

% data for main frame
whtx = [1 1 len_to_sel(sel) NaN len_to_sel(sel+1)+3 p3-1];
whty = [2 p4-20 p4-20  NaN p4-20 p4-20]; 
ltx = [2 2 len_to_sel(sel)+1 NaN len_to_sel(sel+1)+2 p3-2];
lty = [3 p4-21 p4-21 NaN p4-21 p4-21];
drkx = [p3-1 p3-1 2];
drky = [p4-21 2 2];
blkx = [p3 p3 1];
blky = [p4-20 1 1];
ptchx = [p3 p3 1 1];
ptchy = [p4-20 1 1 p4-20];

% loop over all tabs
for n = 1:ntabs
   lsn=len_to_sel(n);
   lsn1=len_to_sel(n+1);
   if n==sel
      % selected tab: bigger
      whtx = [whtx NaN lsn+[0 0 2] lsn1+1];
      whty = [whty NaN p4-[20 2 0 0]];
      ltx = [ltx NaN lsn+[1 1 2] lsn1+1];
      lty = [lty NaN p4-[20 2 1 1]];
      drkx = [drkx NaN lsn1+[2 2]];
      drky = [drky NaN p4-[20 2]];
      blkx = [blkx NaN lsn1+[3 3 2]];
      blky = [blky NaN p4-[20 2 1]];
      ptchx = [ptchx lsn+[0 0 2] lsn1+[1 3 3]];
      ptchy = [ptchy p4-[20 2 0 0 2 20]];
   elseif n==(sel-1)
      % tab before selected - lose right edge
      whtx = [whtx NaN lsn+[2 2 4] lsn1-1];
      whty = [whty NaN p4-[20 4 2 2]];
      ltx = [ltx NaN lsn+[3 3 4] lsn1-1];
      lty = [lty NaN p4-[20 4 3 3]];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-1 1 1]];
      ptchy = [ptchy p4-[20 4 2 2 4 20]];
   elseif n==(sel+1)
      % tab after selected - lose left edge
      whtx = [whtx NaN lsn+4 lsn1-1];
      whty = [whty NaN p4-[2 2]];
      ltx = [ltx NaN lsn+4 lsn1-1];
      lty = [lty NaN p4-[3 3]];
      drkx = [drkx NaN lsn1+[0 0]];
      drky = [drky NaN p4-[19 4]];
      blkx = [blkx NaN lsn1+[1 1 0]];
      blky = [blky NaN p4-[19 4 3]];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-1 1 1]];
      ptchy = [ptchy p4-[20 4 2 2 4 20]];
   else
      % normal unselected tab
      whtx = [whtx NaN lsn+[2 2 4] lsn1-1];
      whty = [whty NaN p4-[20 4 2 2]];
      ltx = [ltx NaN lsn+[3 3 4] lsn1-1];
      lty = [lty NaN p4-[20 4 3 3]];
      drkx = [drkx NaN lsn1+[0 0]];
      drky = [drky NaN p4-[19 4]];
      blkx = [blkx NaN lsn1+[1 1 0]];
      blky = [blky NaN p4-[19 4 3]];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-1 1 1]];
      ptchy = [ptchy p4-[20 4 2 2 4 20]];
   end
end
return




function [whtx, whty, ltx, lty, drkx, drky, blkx, blky, ptchx, ptchy]=i_zbuffer1(len_to_sel,ntabs,sel,p3,p4)
% this renderer misses the final pixel off lines!
% data for main frame
whtx = [1 1 p3];
whty = [22 p4 p4];
ltx = [2 2 p3-1];
lty = [23 p4-1 p4-1];
if sel==1
   drkx = [len_to_sel(sel+1)+3 p3-1 p3-1];
   drky = [22 22 p4-1];
   blkx = [len_to_sel(sel+1)+4 p3 p3];
   blky = [21 21 p4];  
else
   drkx = [2 len_to_sel(sel) NaN len_to_sel(sel+1)+2 p3-1 p3-1];
   drky = [22 22 NaN 22 22 p4-1];
   blkx = [1 len_to_sel(sel)-1 NaN len_to_sel(sel+1)+3 p3 p3];
   blky = [21 21 NaN 21 21 p4]; 
end
ptchx = [p3 p3 1 1];
ptchy = [21 p4 p4 21];

% loop over all tabs
for n = 1:ntabs
   lsn=len_to_sel(n);
   lsn1=len_to_sel(n+1);
   if n==sel
      % selected tab: bigger
      whtx = [whtx NaN lsn lsn];
      whty = [whty NaN 3 21];
      ltx = [ltx NaN lsn+1 lsn+1];
      lty = [lty NaN 3 22];
      drkx = [drkx NaN lsn+2 lsn1+[1 NaN 2 2]];
      drky = [drky NaN  2 2 NaN 3 22];
      blkx = [blkx NaN lsn+[1 2] lsn1+[1 2 3 3]];
      blky = [blky NaN 2 1 1 2 3 21];
      ptchx = [ptchx lsn+[0 0 2] lsn1+[1 3 3]];
      ptchy = [ptchy 21 3 1 1 3 21];
   elseif n==(sel-1)
      % tab before selected - lose right edge
      whtx = [whtx NaN lsn+[2 2]];
      whty = [whty NaN 5 20];
      ltx = [ltx NaN lsn+[3 3]];
      lty = [lty NaN 5 20];
      drkx = [drkx NaN lsn+4 lsn1-1];
      drky = [drky NaN 4 4];
      blkx = [blkx NaN lsn+[3 4] lsn1-1];
      blky = [blky NaN 4 3 3];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-2 0 0]];
      ptchy = [ptchy 21 5 3 3 5 21];
   elseif n==(sel+1)
      % tab after selected - lose left edge
      drkx = [drkx NaN lsn+4 lsn1+[-1 0 0]];
      drky = [drky NaN 4 4 5 21];
      blkx = [blkx NaN lsn+4 lsn1+[-1 1 1]];
      blky = [blky NaN 3 3 5 21];
      ptchx = [ptchx lsn+[3 3 5] lsn1+[-1 1 1]];
      ptchy = [ptchy 21 5 3 3 5 21];
   else
      % normal unselected tab
      whtx = [whtx NaN lsn+[2 2]];
      whty = [whty NaN 5 20];
      ltx = [ltx NaN lsn+[3 3]];
      lty = [lty NaN 5 20];
      drkx = [drkx NaN lsn+4 lsn1+[-1 0 0]];
      drky = [drky NaN 4 4 5 21];
      blkx = [blkx NaN lsn+[3 4] lsn1+[-1 1 1]];
      blky = [blky NaN 4 3 3 5 21];
      ptchx = [ptchx lsn+[2 2 4] lsn1+[-1 1 1]];
      ptchy = [ptchy 21 5 3 3 5 21];
   end
end
return
