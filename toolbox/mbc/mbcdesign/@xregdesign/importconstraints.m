function [d,ok]=importconstraints(d,action,varargin)
%IMPORTCONSTRAINTS  GUI for importing constraints into a design
%
%  [D,OK]=IMPORTCONSTRAINTS(D,DES_LIST)
%
%  OK==0 if cancel is pressed.
%  OK==1 if OK pressed but no changes made.
%  OK==2 if OK pressed and changes made to design.
%  OK==3 if OK pressed and constraints were immediately applied to the
%  design.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.4 $  $Date: 2004/04/04 03:27:14 $

if nargin<2
   action={};  % empty list of optional constraints
end

if ~ischar(action)
   varargin=[{action} varargin];
   action='figure';
end

switch lower(action)
case 'figure'
   [d,ok]=i_createfig(d,varargin{:});
end
return




function  [dout,ok]=i_createfig(d,des_list);
figh=xregdialog('Name','Import Constraints','tag','cancel','resize','off');
xregcenterfigure(figh,[500 300]);

ptr=xregGui.RunTimePointer(d);
ptr.LinkToObject(figh);


lyt=i_createlyt(figh,ptr,des_list);

% add ok, cancel
okbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');
cancbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','Cancel',...
   'callback','set(gcbf,''visible'',''off'');');
helpbtn=mv_helpbutton(figh,'xreg_desConImport');

mainlyt=xreggridbaglayout(figh,'dimension',[2 4],...
   'rowsizes',[-1 25],...
   'colsizes',[-1 65 65 65],...
   'gapy',10,'gapx',7,...
   'mergeblock',{[1 1],[1 4]},...
   'elements',{lyt,[],[],okbtn,[],cancbtn,[],helpbtn},...
   'border',[7 7 7 7]);

figh.LayoutManager=mainlyt;
set(mainlyt,'packstatus','on');
figh.showDialog(okbtn);
% The xregDialog handles the blocking of this function

tg=get(figh,'tag');
if strcmp(tg,'ok')
   changes=i_finalise(lyt);
   if changes
      dout=ptr.info;
      ok=1+changes;
   else
      dout=d;
      ok=1;
   end
else
   ok=0;
   dout=d;
end
delete(figh);

return



function lyt=i_createlyt(figh,p,des_list)
udptr=xregGui.RunTimePointer;
udptr.LinkToObject(figh);

ud.desptr=p;
ud.deslist=des_list;
ud.constraints={};
ud.sources={};
ud.nullstring='';

txt=uicontrol('parent',figh,...
   'style','text',...
   'string','Import from:',...
   'horizontalalignment','left',...
   'hittest','off',...
   'enable','inactive');
ud.sourcetype=uicontrol('parent',figh,...
   'style','popupmenu',...
   'string',{'Current designs','Design Editor file (*.mvd)'},...
   'backgroundcolor',[1 1 1],...
   'callback',{@i_setsource,udptr});
ud.filetxt=uicontrol('parent',figh,...
   'style','text',...
   'string','Source file:',...
   'horizontalalignment','left',...
   'hittest','off',...
   'enable','off');
ud.filename=uicontrol('parent',figh,...
   'style','edit',...
   'string','',...
   'horizontalalignment','left',...
   'enable','off',...
   'callback',{@i_updateconlist,udptr});
ud.fileopen=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','...',...
   'enable','off',...
   'callback',{@i_openfile,udptr});
ud.deletepoints = uicontrol('parent',figh,...
   'style','checkbox',...
   'string','Apply new constraints to current design');
descriptxt=uicontrol('parent',figh,...
   'style','text',...
   'string','Select one or more constraints to import:',...
   'horizontalalignment','left',...
   'hittest','off',...
   'enable','inactive');
list=xregGui.listview([0 0 1 1],double(figh),{'ColumnClick','xreglvsorter'});
list.view=3;
list.labeledit=1;
list.fullrowselect=1;
list.multiselect=1;
list.hideselection=0;
list.Parent=double(figh);
list.GridLines=1;
ch=list.columnheaders;
cheader= ch.Add;
cheader.text='Description';
cheader.width=200;
cheader= ch.Add;
cheader.text='Source';
cheader.width=120;
cheader= ch.Add;
cheader.text='Type';
cheader.width=120;

ud.conlist=list;

grd=xreggridlayout(figh,...
   'packstatus','off',...
   'correctalg','on',...
   'dimension',[2 1],...
   'gapy',5,...
   'rowsizes',[15 -1],...
   'elements',{descriptxt,actxcontainer(ud.conlist)});
frm=xregframetitlelayout(figh,...
   'title','Available Constraints',...
   'innerborder',[15 5 5 5],...
   'center',grd);
lyt=xreggridbaglayout(figh,'dimension',[11 4],...
   'rowsizes',[4 15 3 7 3 15 2 7 20 10 -1],...
   'colsizes',[70 180 20 -1],...
   'gapx',5,...
   'mergeblock',{[1 3],[2 3]},...
   'mergeblock',{[5 7],[2 2]},...
   'mergeblock',{[5 7],[3 3]},...
   'mergeblock',{[9 9],[1 4]},...
   'mergeblock',{[11 11],[1 4]},...
   'elements',{[],txt,[],[],[],ud.filetxt,[],[],ud.deletepoints,[],frm,...
      ud.sourcetype,[],[],[],ud.filename,[],[],[],[],[],[],...
      [],[],[],[],ud.fileopen},...
   'userdata',udptr);


udptr.info=ud;

% populate list with initial settings
i_gen_con_list(udptr);
i_populate_list(udptr);

return





function i_setsource(src,evt,udptr)
% enable/disable file edit box
ud=udptr.info;
switch get(src,'value')
case 1
   set([ud.filename;ud.filetxt;ud.fileopen],'enable','off');
   sc=xregGui.SystemColorsDbl;
   set(ud.filename,'backgroundcolor',sc.CTRL_BACK);
case 2
   set([ud.filename;ud.filetxt;ud.fileopen],'enable','on');
   set(ud.filename,'backgroundcolor',[1 1 1]);
end

% update list box
i_gen_con_list(udptr);
i_populate_list(udptr);
return

function i_updateconlist(src,evt,udptr)
% update list box after filename change
i_gen_con_list(udptr);
i_populate_list(udptr);
return

function i_openfile(src,evt,udptr)
% callback from file choosing button
ud=udptr.info;
spec='*.mvd';

defp = fullfile(xregGetDefaultDir('Designs'), spec);

[f,p]=uigetfile(defp);
if f~=0
   set(ud.filename,'string',fullfile(p,f));
   i_gen_con_list(udptr);
   i_populate_list(udptr);
   
end
return



function i_gen_con_list(udptr)
ud=udptr.info;
switch get(ud.sourcetype,'value')
case 1
   % design list
   cons={};
   src={};
   if ~isempty(ud.deslist)
      mastermdl=model(ud.desptr.info);
      masternf=nfactors(mastermdl);
      mastertgt=gettarget(mastermdl);
      for n=1:length(ud.deslist)
         mdl=model(ud.deslist{n});
         if (abs(nfactors(mdl)-masternf)<.01) & all(abs(gettarget(mdl)-mastertgt)<10*eps)
            C=constraints(ud.deslist{n});
            if ~isempty(C)
               cons=[cons constraints(C)];
               src=[src repmat({name(ud.deslist{n})},1,length(C))];
            end
         end
      end
   end
   if isempty(cons)
      ud.nullstring='No suitable constraints to import';
   else
      ud.nullstring='';
   end
   ud.constraints=cons;
   ud.sources=src;
   
case 2
   % design file
   filename=get(ud.filename,'string');
   if ~isempty(filename)
      [d,ok]=importfromfile(ud.desptr.info,filename);
      if ok
         mdl=model(d);
         if all(abs(gettarget(mdl)-gettarget(model(ud.desptr.info)))<10*eps)
            C=constraints(d);
            if ~isempty(C)
               ud.constraints=constraints(C);
               ud.sources=repmat({'File'},1,length(ud.constraints));
               if isempty(ud.constraints)
                  ud.nullstring='No constraints in file';
               else
                  ud.nullstring='';
               end
            else
               ud.constraints={};
               ud.nullstring='No constraints in file';
            end
         else
            ud.nullstring='Incorrect design ranges in file';
            ud.constraints={};
         end
      else
         ud.constraints={};
         ud.nullstring='Unable to load design from file';
      end
   else
      ud.constraints={};
      ud.nullstring='No file specified';
   end
end
udptr.info=ud;
return




function i_populate_list(udptr)
ud=udptr.info;

mdl=model(ud.desptr.info);
fact=get(mdl,'symbol');
fact=fact(:)';
list=ud.conlist;
li=list.listitems;
li.Clear;
cons=ud.constraints;
src=ud.sources;
if isempty(cons)
   list.enabled=0;
   item=li.Add;
   item.text=ud.nullstring;
else
   list.enabled=1;
   for n=1:length(cons)
      con=cons{n};
      item=li.Add;
      item.text=tostring(con,fact);
      item.key=sprintf('K%d',n);
      set(item,'subitems',1,src{n});
      set(item,'subitems',2,typename(con));
   end
end
return


function changes=i_finalise(lyt)
udptr=get(lyt,'userdata');
ud=udptr.info;
changes=0;
if ~isempty(ud.constraints)
    sel=ud.conlist.selecteditemindex;
    if all(sel>0)
        li=ud.conlist.listitems;   
        for n=1:length(sel)
            item= li.Item(sel(n));
            sel(n)=sscanf(item.key,'K%d');
        end
        % add new constraints to design
        ud.desptr.info=addConstraint(ud.desptr.info,ud.constraints(sel));
        changes = 1;
        if get(ud.deletepoints, 'value')
            ud.desptr.info = applyconstraints(ud.desptr.info);
            changes = 2;
        end
    end
end
return

