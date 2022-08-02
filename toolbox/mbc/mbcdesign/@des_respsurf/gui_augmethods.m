function [s,defnum]=gui_augmethods(d);
%GUI_AUGMETHODS  Return structure of augmentation methods
%
%  [S,DEFAULT]=GUI_AUGMETHODS(D)
%
%  See also:  GUI_ADDPOINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 07:03:38 $

[s,defnum]=gui_augmethods(d.xregdesign);

if isoptimcapable(d) & rankcheck(d)
   [tp,info]=DesignType(d);
   if tp==1
      % redefine defnum
      if isempty(info)
         x=1;
      else
         x=strmatch(info,{'D-optimal','V-optimal','A-optimal'},'exact');
         if isempty(x)
            x=1;
         end
      end
      defnum=[length(s)+1 x];
   end
   s=[s struct('Name',{{'D-Optimal','V-Optimal','A-Optimal'}},...
         'CreateFcn',{@i_createoptim},...
         'FinaliseFcn',{@i_finaliseoptim},...
         'NPointsFcn',{@i_NPoptim})];
end
return





function L = i_createoptim(F,pD)

udh=xregGui.RunTimePointer;
udh.LinkToObject(F);
des=pD.info;

ud.despointer=pD;

ud.Npts=xregGui.labelcontrol('parent',F,...
   'visible','off',...
   'string','Number of points:',...
   'labelsizemode','absolute',...
   'labelsize',100,...
   'controlsizemode','absolute',...
   'controlsize',60,...
   'gap',5,...
   'Control',xregGui.clickedit('parent',F,...
   'value',1,...
   'dragincrement',1,...
   'clickincrement',1,...
   'min',1,...
   'max',1000,...
   'rule','int',...
   'visible','off'));
ud.candset=xregGui.labelcontrol('parent',F,...
   'visible','off',...
   'string','Candidate Set:  ',...
   'controlsize',65,...
   'gap',5,...
   'Control',xregGui.uicontrol('parent',F,...
   'style','pushbutton',...
   'string','Edit...',...
   'visible','off',...
   'callback',{@i_editcset,udh}));
L=xreggridbaglayout(F,'dimension',[2 1],...
   'packstatus','off',...
   'rowsizes',[20 25],...
   'gapy',5,...
   'elements',{ud.Npts,ud.candset},...
   'userdata',udh);

ud=i_setcstext(ud);
udh.info=ud;



function ud=i_setcstext(ud)
des=ud.despointer.info;
str=['Candidate set:  ' CandidateSetInformation(candspace(des)) ', ' sprintf('%d',ncand(des)) ' points.'];
set(ud.candset,'string',str);


function i_editcset(src,evt,udh)
ud=udh.info;
des=ud.despointer.info;
des=gui_candspace(des);
ud.despointer.info=des;
ud=i_setcstext(ud);



function i_finaliseoptim(L,pD,sel)
udh=get(L,'userdata');
ud=udh.info;

des=pD.info;
np=get(ud.Npts.Control,'value');
switch sel
case 1
   des=daugment(des,np);
case 2   
   des=vaugment(des,np);
case 3
   des=aaugment(des,np);
end
pD.info=des;


function np=i_NPoptim(L,pD,np)
udh=get(L,'userdata');
ud=udh.info;
if nargin>2
   ud.Npts.Control.value=np;
else
   np=ud.Npts.Control.value;
end
