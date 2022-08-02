function out=propertypage(obj,action,varargin);
% PROPERTYPAGE  Create a property gui for CandidateSet
%
%
%   This should be overloaded by child classes
%
%   Interface:  Lyt=propertypage(cs,'layout',fig);
%               Lyt=propertypage(cs,'update',lyt,p_cs,model);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:02:09 $


switch lower(action)
case 'layout'
   out=i_createlyt(varargin{:});
case 'update'
   out=i_update(varargin{:});
end
return




function lyt=i_createlyt(figh,varargin)

% create new layout in figure
ud.pointer=[];
ud.figure=figh;
ud.model=[];
ud.callback='';
if nargin>1
   for n=1:2:length(varargin)
      switch lower(varargin{n})
      case 'callback'
         ud.callback=varargin{n+1};
      end
   end
end


ud.current=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'string','Current candidate list size: n points',...
   'horizontalalignment','left');
ud.txt(3)=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'string','Data source:',...
   'position',[0 0 75 15],...
   'horizontalalignment','left');
ud.txt(4)=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'string','Replace current data with new data:',...
   'position',[0 0 185 15],...
   'horizontalalignment','left');
ud.txt(5)=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'string','Augment current data with new data:',...
   'position',[0 0 185 15],...
   'horizontalalignment','left');
srcs={'MATLAB workspace';'mat file'};  %;'Mapview dataset'}
ud.datasrc=uicontrol('parent',figh,...
   'style','popupmenu',...
   'string',srcs,...
   'value',1,...
   'visible','off',...
   'backgroundcolor','w',...
   'position',[0 0 125 20]);
ud.newdata=uicontrol('parent',figh,...
   'style','pushbutton',...
   'visible','off',...
   'string','Replace',...
   'position',[0 0 65 25]);
ud.adddata=uicontrol('parent',figh,...
   'style','pushbutton',...
   'visible','off',...
   'string','Augment',...
   'position',[0 0 65 25]);
str=['Use the buttons above to load a custom candidate set.  The candidate list must',...
      ' have at least one point.'];
ud.txt(6)=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'string',str,...
   'userdata',xregdesign,...
   'horizontalalignment','left');
div1=xregGui.dividerline(figh,'visible','off');

udh=ud.current;
% callbacks
set(ud.newdata,'callback',{@i_newdata,udh});
set(ud.adddata,'callback',{@i_adddata,udh});

% layouts
flw1=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.txt(3),ud.datasrc},'packstatus','off');
flw2=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.txt(4),ud.newdata});
flw3=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.txt(5),ud.adddata});

lyt=xreggridlayout(figh,'correctalg','on',...
   'dimension',[8 1],...
   'rowsizes',[25 10 30 30 -1 10 15 30],...
   'elements',{flw1,[],flw2,flw3,[],div1,ud.current,ud.txt(6)});

ud.layout=lyt;
set(udh,'userdata',ud);
return


function lyt=i_update(lyt,p,m)
% update current layout
udh=get(lyt,'elements');
udh=udh{7};
ud=get(udh,'userdata');
ud.pointer=p;
ud.model=m;
ud=i_setvalues(ud);
set(udh,'userdata',ud);
return


function ud=i_setvalues(ud)
np=npoints(ud.pointer.info);
if np==1
   set(ud.current,'string',['Current candidate list size: ' sprintf('%d',np) ' point.']);
else
   set(ud.current,'string',['Current candidate list size: ' sprintf('%d',np) ' points.']);  
end
return



function i_newdata(obj,nul,udh)
ud=get(udh,'userdata');

% internal function for getting data
[data ok]=i_getdata(ud);

if ok
   ud.pointer.info=set(ud.pointer.info,'data',data);
   ud=i_setvalues(ud);
   set(udh,'userdata',ud);
   i_firecb(ud);
end
return


function i_adddata(obj,nul,udh)
ud=get(udh,'userdata');

% internal function for getting data
[data ok]=i_getdata(ud);

if ok
   % add new data
   ud.pointer.info=set(ud.pointer.info,'data',[get(ud.pointer.info,'data'); data]);
   ud=i_setvalues(ud);
   set(udh,'userdata',ud);
   i_firecb(ud);
end
return


function [x,ok]=i_getdata(ud);
% popup appropriate gui for getting new data in

popval=get(ud.datasrc,'value');
nf=nfactors(ud.pointer.info);
switch popval
case 1
   % workspace
   [x,ok]=mv_getmatrix([NaN nf],'double');
case 2
   % mat file
   % load dialog, then check contents for matching matrices
   [f,p]=uigetfile('*.mat','Load candidate data');
   if f==0
      x=[];
      ok=0;
      return
   end
   
   vars=load([p f]);
   fnms=fieldnames(vars);
   S.type='.';
   opt=true(length(fnms),1);
   for i=1:length(fnms)
      S.subs=fnms{i};
      x=subsref(vars,S);
      % check each data for type and size
      if ~strcmp(class(x),'double') | size(x,2)~=nf
         opt(i)=0;
      end
   end
   
   if sum(opt)==1
      % only one matching matrix
      S.subs=fnms{find(opt)};
      x=subsref(vars,S);
      ok=1;
   elseif any(opt)
      % multiple options in file
      [selind,ok]=mv_listdlg('liststring',fnms(opt),'selectionmode','single','name','Select Matrix',...
         'uh',25,'listsize',[160 200]);
      if ok
         fd=find(opt);
         selind=fd(selind);
         S.subs=fnms{selind};
         x=subsref(vars,S);
      else
         x=[];
      end
   else
      errordlg('There are no matrices of the appropriate size in this file!','modal');
      x=[];
      ok=0;
   end
case 3
   % mapview dataset
   % ?????
   x=[0 0 0 0];
   ok=1;
   
   
end

if ok
   % code data
   x=code(ud.model,x);
end
return






function i_firecb(ud)
if ischar(ud.callback)
   evalin('base',ud.callback);
else
   str=[ud.callback(1) {ud.layout,[]} ud.callback(2:end)];
   feval(str{:});
end
return
