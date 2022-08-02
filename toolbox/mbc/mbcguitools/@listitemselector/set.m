function varargout=set(varargin);
% SET   Set interface for the listitemselector object
%
%   [SL1,SL2,SL3]=SET(SL1,SL2,SL3,...,'Property','Value',...) sets the properties
%   to the values indicated.  Current properties include:
%      'Visible' - 'on'/'off'
%      'Position' - 4 element position vector
%      'Parent' - Re-parent object
%      'Enable' - 'on'/'off'
%      'Buttonsep' - spacing betweeen the buttons and the list boxes
%      'itemlist' - list of strings or numbers to select from
%      'selectionstyle' - 'single' or 'multiple'
%      'selectedtitle' - Title string to put over the selected listbox
%      'unselectedtitle' - Title string to put over the unselected listbox
%      'callback'   -  Callback string to evaluate whenever the selection is
%                      changed.
%      'userdata'   -  Field for storing data
%      'selectfcn'  -  String to evaluate whenever an item is selected in either
%                      list.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:08 $


% sort out inputs:
objfind=1;
while objfind
   if strcmp(class(varargin{objfind}),'listitemselector')
      sl(objfind)=varargin(objfind);
      objfind=objfind+1;
   else
      varargin=varargin(objfind:end);
      objfind=0;
   end   
end

   
if ~iscell(sl)
   sl={sl};
end

for k=1:length(sl)
   wrksl=sl{k};
   for n=1:2:length(varargin)-1
            
      switch lower(varargin{n})
      case 'visible'
         % visible
         if strcmp(lower(varargin{n+1}),'off')
            set([wrksl.baselist;wrksl.sellist;wrksl.addall;wrksl.addone;wrksl.remone;...
                  wrksl.remall;wrksl.unselttl;wrksl.selttl],'visible','off');
         elseif strcmp(lower(varargin{n+1}),'on')
            ud=get(wrksl.baselist,'userdata');
            hndls=[wrksl.baselist;wrksl.sellist;wrksl.addall;wrksl.addone;wrksl.remone;wrksl.remall];
            if ud.titles
               hndls=[hndls;wrksl.unselttl;wrksl.selttl];
            end
            set(hndls,'visible','on');
         end
         
      case 'position'
         % position
         i_position(wrksl,varargin{n+1});
      case 'parent'
         % check for a figure handle
         if ishandle(varargin{n+1})
            if strcmp(get(varargin{n+1},'type'),'figure')
               set([wrksl.baselist;wrksl.sellist;wrksl.addall;wrksl.addone;wrksl.remone;wrksl.remall],'parent',varargin{n+1});
            end
         end
      case 'enable'
         % enable
         if strcmp(varargin{n+1},'on')
            h=[wrksl.baselist;wrksl.sellist];
            ud=get(wrksl.baselist,'userdata');
            if ~isempty(ud.sel)
               h=[h; wrksl.remone;wrksl.remall];
            end
            if ~isempty(ud.unsel)
               h=[h; wrksl.addone;wrksl.addall];
            end
            set(h,'enable','on');
         elseif strcmp(varargin{n+1},'off')
            set([wrksl.baselist;wrksl.sellist;wrksl.addall;wrksl.addone;wrksl.remone;wrksl.remall],'enable','off');
         end   
      case 'buttonsep'
         ud=get(wrksl.baselist,'userdata');
         ud.buttonsepdist=varargin{n+1};
         set(wrksl.baselist,'userdata',ud);
         i_position(wrksl,ud.position);
      case 'itemlist'
         val=get(wrksl.baselist,'value');
         if val>length(varargin{n+1})
            set(wrksl.baselist,'value',1);
         end
         ud=get(wrksl.baselist,'userdata');
         ud.reallist=varargin{n+1};
         ud.sel=[];
         ud.unsel=1:length(ud.reallist);
         % convert input to character representation if necessary
         if isnumeric(varargin{n+1})
            ud.charlist=ud.reallist;
         elseif iscell(varargin{n+1})
            % attempt to convert cell array of objects using char
            ud.charlist=ud.reallist;
            for n=1:length(ud.reallist)
               try
                  ud.charlist{n}=char(ud.charlist{n});
               catch
                  ud.charlist{n}='????';
               end               
            end  
         end
         set(wrksl.baselist,'string',ud.charlist);
         set(wrksl.sellist,'string','','value',1);
         set(wrksl.baselist,'userdata',ud);
         % disable removal buttons
         set([wrksl.remone,wrksl.remall],'enable','off');
         if ~isempty(ud.unsel)
            set([wrksl.addone,wrksl.addall],'enable','on');
         end
         
      case 'selectionstyle'
         if strcmp(varargin{n+1},'single')
            set([wrksl.baselist;wrksl.sellist],'max',1,'min',0);
         elseif strcmp(varargin{n+1},'multiple')
            set([wrksl.baselist;wrksl.sellist],'max',2,'min',0);
         end
      case 'selectedtitle'
         if ischar(varargin{n+1})
            set(wrksl.selttl,'string',varargin{n+1});
            ud=get(wrksl.baselist,'userdata');
            ttls=ud.titles;
            if isempty(varargin{n+1})
               if isempty(get(wrksl.unselttl,'string'))
                  ud.titles=0;
               else
                  ud.titles=1;
               end
            else
               ud.titles=1;
            end
            set(wrksl.baselist,'userdata',ud);
            if ttls~=ud.titles
               % force a redraw
               i_position(wrksl,get(wrksl,'position'));
            end
         end
      case 'unselectedtitle'
         if ischar(varargin{n+1})
            set(wrksl.unselttl,'string',varargin{n+1});
            ud=get(wrksl.baselist,'userdata');
            ttls=ud.titles;
            if isempty(varargin{n+1})
               if isempty(get(wrksl.selttl,'string'))
                  ud.titles=0;
               else
                  ud.titles=1;
               end
            else
               ud.titles=1;
            end
            set(wrksl.baselist,'userdata',ud);
            if ttls~=ud.titles
               % force a redraw
               i_position(wrksl,get(wrksl,'position'));
            end
         end
      case 'callback'
         ud=get(wrksl.baselist,'userdata');
         ud.callback=varargin{n+1};
         set(wrksl.baselist,'userdata',ud);
      case 'userdata'
         ud=get(wrksl.baselist,'userdata');
         ud.userdata=varargin{n+1};
         set(wrksl.baselist,'userdata',ud);
      case 'selectfcn'
         ud=get(wrksl.baselist,'userdata');
         ud.selectfcn=varargin{n+1};
         set(wrksl.baselist,'userdata',ud);
      otherwise
         set([wrksl.baselist;wrksel.sellist],varargin{n},varargin{n+1});      
      end
   end
   
   sl{k}=wrksl;
end
% resurrect outputs
nargout=length(sl);
varargout=sl;


return



function i_position(sl,pos)
ud=get(sl.baselist,'userdata');

rpos=pos;
if ud.titles
   % reserve 18 pixels for titles
   pos(4)=pos(4)-16;
end


% decide btn heights and separations
if pos(4)<154
   btnsep=floor(pos(4)./15.4);
   btnh=floor(btnsep.*2.6);
else
   btnh=26;
   btnsep=10;
end

if pos(3)<(btnh+2*ud.buttonsepdist+2) | btnh<1
   return
end



vis=get(sl.baselist,'visible');
set([sl.baselist;sl.sellist;sl.addall;sl.addone;sl.remone;sl.remall;sl.unselttl;sl.selttl],'visible','off');

set(sl.baselist,'position',[pos(1) pos(2) (pos(3)-btnh-2*ud.buttonsepdist)./2 pos(4)]);
set(sl.sellist,'position',[pos(1)+pos(3)./2+ud.buttonsepdist+btnh./2 pos(2) (pos(3)-btnh-2*ud.buttonsepdist)./2 pos(4)]);
set(sl.addall,'position',[pos(1)+.5*pos(3)-.5*btnh  pos(2)+.5*pos(4)+1.5*btnsep btnh btnh]);
set(sl.addone,'position',[pos(1)+pos(3)./2-btnh./2  pos(2)+.5*pos(4)+2.5*btnsep+btnh btnh btnh]);
set(sl.remone,'position',[pos(1)+pos(3)./2-btnh./2  pos(2)+.5*pos(4)-1.5*btnsep-btnh btnh btnh]);
set(sl.remall,'position',[pos(1)+pos(3)./2-btnh./2  pos(2)+.5*pos(4)-2.5*btnsep-2*btnh btnh btnh]);
set(sl.selttl,'position',[pos(1)+pos(3).*0.5+10+btnh.*0.5 pos(2)+pos(4) (pos(3)-btnh-20).*0.5 16]);
set(sl.unselttl,'position',[pos(1) pos(2)+pos(4) (pos(3)-btnh-20).*0.5 16]);

if strcmp(vis,'on')
   hndls=[sl.baselist;sl.sellist;sl.addall;sl.addone;sl.remone;sl.remall];
   if ud.titles
      hndls=[hndls;sl.selttl;sl.unselttl];
   end
   set(hndls,'visible','on');
end

ud.position=rpos;
set(sl.baselist,'userdata',ud);
return
