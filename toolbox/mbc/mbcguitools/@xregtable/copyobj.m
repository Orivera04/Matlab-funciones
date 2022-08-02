function newobj=copyobj(obj,fig)
% COPYOBJ  Create a copy of an object in a new figure
%
%   NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object
%   OBJ in the figure FIG.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:32:29 $

% Created 23/2/2000

% copy data structure
newobj=obj;
fud=get(obj.frame.handle,'userdata');
newfud=fud;
%copy background and assorted extra ui elements

newobj.frame.handle=double(copyobj(handle(obj.frame.handle),fig));
newfud.frame.handle=newobj.frame.handle;
newobj.hslider.handle=double(copyobj(handle(obj.hslider.handle),fig));
newfud.hslider.handle=newobj.hslider.handle;
newobj.vslider.handle=double(copyobj(handle(obj.vslider.handle),fig));
newfud.vslider.handle=newobj.vslider.handle;
newobj.dslider.handle=double(copyobj(handle(obj.dslider.handle),fig));
newfud.dslider.handle=newobj.dslider.handle;
newfud.objecthandle=double(copyobj(handle(fud.objecthandle),fig));

newobj.parent=fig;
newfud.parent=fig;

% link to new object
builtin('set',newfud.objecthandle,'userdata',newobj);

oldh=sprintf('%20.15f',fud.objecthandle);
ptchhndl=sprintf('%20.15f',newfud.objecthandle);

% set slider callbacks
set(newobj.vslider.handle,'callback',...
   ['vsliderscroll(get(' ptchhndl ',''Userdata''));']);
set(newobj.hslider.handle,'callback',...
   ['hsliderscroll(get(' ptchhndl ',''Userdata''));']);

% move all cell handles across:
% need to move, change callback strings, userdata parent field,
% and uiprops structure

% set up big array of handles
hndls=zeros(fud.rows.number,fud.cols.number);
hndls(1:fud.rows.fixed,1:fud.cols.fixed)=fud.cells.fcornerhandles;
hndls(fud.rows.fixed+1:end,1:fud.cols.fixed)=fud.cells.flefthandles;
hndls(1:fud.rows.fixed,fud.cols.fixed+1:end)=fud.cells.ftophandles;
sz=size(fud.cells.shandles);
hndls(fud.rows.fixed+1:fud.rows.fixed+sz(1),fud.cols.fixed+1:fud.cols.fixed+sz(2))=fud.cells.shandles;

% filter zeros and text items: these indexes are useful later though
hind=(hndls~=0);
hindtxt=false(size(hind));
if length(fud.cells.ctype)
   hindtxt(1:size(fud.cells.ctype,1),1:size(fud.cells.ctype,2))=(fud.cells.ctype==1);
end
h=hndls(hind & ~hindtxt);
if ~isempty(h)
   h=double(copyobj(handle(h),fig));
   % redo callbacks
   cbstr=get(h,'callback');
   cbstr=strrep(cbstr,oldh,ptchhndl);
   set(h,{'callback'},cbstr);
   % userdata
   uds=get(h,'userdata');
   for n=length(uds):-1:1
      uds{n}.parent=newobj.frame.handle;
   end
   set(h,{'userdata'},uds);
   % put h back into hndls
   hndls(hind & ~hindtxt)=h;
end

% sort out text object references
txth=findobj(fud.objecthandle,'type','text');
newtxth=findobj(newfud.objecthandle,'type','text');

% assume child object handles maintain the same order in the copy
h=hndls(hindtxt);
% find index vector linking txth to h, then apply to newtxth
[tmp,i]=unique(txth);
[tmp,i2]=unique(h);
[tmp,i2]=sort(i2);
newtxth=newtxth(i(i2));
hndls(hindtxt)=newtxth;

% resplit hndls into new object
newfud.cells.fcornerhandles=hndls(1:fud.rows.fixed,1:fud.cols.fixed);
newfud.cells.flefthandles=hndls(fud.rows.fixed+1:end,1:fud.cols.fixed);
newfud.cells.ftophandles=hndls(1:fud.rows.fixed,fud.cols.fixed+1:end);

newfud.cells.shandles=hndls(fud.rows.fixed+1:fud.rows.fixed+sz(1),fud.cols.fixed+1:fud.cols.fixed+sz(2));

% do uiprops callback strings
fud.cells.defaultuip.callback=['cellcb(get(' ptchhndl ',''userdata''));'];

for n=1:length(newfud.cells.uiprops)
   if isfield(newfud.cells.uiprops{n},'callback')
      newfud.cells.uiprops{n}.callback=strrep(newfud.cells.uiprops{n}.callback,oldh,ptchhndl);
   end
end

set(newobj.frame.handle,'userdata',newfud);















