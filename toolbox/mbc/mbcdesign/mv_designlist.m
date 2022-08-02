function [out,ok]=mv_designlist(des,varargin)
% MV_DESIGNLIST   GUI for selecting a subset of designs
%
%   [OUT,OK] = MV_DESIGNLIST(IN,STR) displays a listbox containing the
%   list of designs in IN and allows the user to select a subset
%   which is returned in OUT.  The optional STR is a string to display
%   above the list of designs.  OK indicates whether the OK button was
%   pressed (OK=1) or Cancel (OK=0).
%
%   IN may be a design, a cell array of designs, a pointer to a 
%   design or a cell array of pointers to designs.  OUT will be
%   of the same form as IN.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.4 $  $Date: 2004/04/04 03:27:16 $


action='create'; 

switch lower(action)
case 'create'
   [out,ok]=i_create(des,varargin{:});
end
return

   
   

function [out,ok]=i_create(des,str);
% creation routine.  This function blocks execution before returning the output

if nargin<2
   str=['Select the designs by Shift-clicking and Ctrl-clicking:'];
end
ud.input=des;


% screen des list to allow only linear designs
% ensure des is a cell
if isempty(des)
   des=[];
end


keep=false(1,length(des));
for n=1:length(des)
   keep(n)=isoptimcapable(des(n).info);
end
des=des(keep);


% if des is empty then popup a warning dialog.
if isempty(des)
   h=warndlg('There are no designs to choose from!','Warning','modal');
   waitfor(h);
   out=[];
   ok=0;
   return
end

scsz=get(0,'screensize');

figh=xregdialog('name','Select Designs',...
   'tag','DesignChooser',...
   'position',[scsz(3)*0.5-280 scsz(4)*0.5-150 560  230]);

% controls: just a text item and an ActiveX listbox
ud.text=uicontrol('parent',figh,...
   'style','text',...
   'horizontalalignment','left',...
   'string',str);
% list box is set up with icons and multiple columns
list=xregGui.listview([0 0 50 50],double(figh),{'ColumnClick','xreglvsorter'});
ud.img=xregGui.ILmanager;
ud.img.IL.maskcolor=255*256;
bmp2ind(ud.img,'blank.bmp');
list.InsertSmallIcons(ud.img.IL);
list.view=3;
list.labeledit=1;
list.multiselect=1;
list.hideselection=0;
list.Parent=double(figh);
list.GridLines=1;
list.FullRowSelect=1;
ch=list.columnheaders;

heads={'Name','Design Type','Number of Points'};
w=[150 200 50];


cheader= ch.Add;
cheader.text='Name';
cheader.width=w(1);
for n=2:length(heads)
   cheader= ch.Add;
   cheader.text=heads{n};
   cheader.width=w(n);
end
cheader.tag='num';


lis=list.listitems;
% add each design
for n=1:length(des)
   if isa(des(n),'xregGui.RunTimePointer')
      % dereference
      d=des(n).info;
   else
      d=des{n};
   end
   d=setlock(d,0);
   li=lis.Add;
   li.smallicon=bmp2ind(ud.img,iconfile(d));
   li.text=name(d);
   li.tag=n;
   set(li,'subitems',1,getstyleinfo(d));
   set(li,'subitems',2,sprintf('%d',npoints(d)));
end
% select first design as default
lis.Item(1).Selected = 1;
% sort by name
list.sorted=1;
ud.sortcol=0;
ud.input=des;
ud.list=actxcontainer(list);

ud.OK=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');',...
   'position',[0 0 65 25]);
ud.cancel=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','Cancel',...
   'callback','set(gcbf,''visible'',''off'');',...
   'position',[0 0 65 25]);

ud.flw=xregflowlayout(figh,'orientation','RIGHT/BOTTOM',...
   'border',[0 10 -7 10],...
   'elements',{ud.cancel,ud.OK},...
   'gap',7,'packstatus','off');
ud.brd1=xregborderlayout(figh,...
   'center',ud.list,...
   'north',ud.text,...
   'south',ud.flw,...
   'innerborder',[0 45 0 30]);
% use another border for a frame - the borderlayout doesn't support
% the border property properly at all
ud.brd2=xregborderlayout(figh,...
   'center',ud.brd1,...
   'innerborder',[10 0 10 15]);

figh.LayoutManager=ud.brd2;
set(ud.brd2,'packstatus','on');
set(figh,'userdata',ud);
figh.showDialog(ud.OK);

tg=get(figh,'tag');
if strcmp(tg,'ok')
   % get selected indices
   inds=ud.list.selecteditemindex;
   if inds==-1
      out=[];
      ok=0;
   else 
      % convert to original indices from tags
      for n=1:length(inds)
         inds(n)=lis.Item(inds(n)).Tag;
      end
      out=ud.input(inds);
      ok=1;
   end
else
   out=[];
   ok=0;
end
delete(figh);
return