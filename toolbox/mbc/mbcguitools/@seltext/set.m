function varargout=set(varargin)
%SELTEXT/SET   Set interface for the seltext object
%   Classic set function for the seltext object
%   properties are:
%
%      Position      :     4-element position vector
%      Visible       :   'on'/'off'
%      Backgroundcolor:  color vector
%      Selectedcolor :   color vector
%      Selected      :   'on'/'off'
%      Callback      :   String
%      Interruptible :   'on'/'off'
%      Userdata
%      
%   All other properties are passed through to the axestext control.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:20:34 $

%  Created 6/10/00


% Bail if we've not been given a seltext object
objfind=1;
while objfind
   if strcmp(class(varargin{objfind}),'seltext')
      obj(objfind)=varargin(objfind);
      objfind=objfind+1;
   else
      varargin=varargin(objfind:end);
      objfind=0;
   end   
end


if ~iscell(obj)
   obj={obj};
end

for k=1:length(obj)
   wrkobj=obj{k};
   
   % loop over varargin
   for n=1:2:(nargin-2)
      switch lower(varargin{n})
      case 'position'
         i_drawtext(wrkobj,varargin{n+1});
         i_drawback(wrkobj,varargin{n+1});
         ud=get(wrkobj.back,'userdata');
         ud.position=varargin{n+1};
         set(wrkobj.back,'userdata',ud);
      case 'visible'
         set(wrkobj.axestext,'visible',varargin{n+1});
         set(wrkobj.back,'visible',varargin{n+1});
      case 'backgroundcolor'
         ud=get(wrkobj.back,'userdata');
         ud.bgcolor=varargin{n+1};
         set(wrkobj.back,'userdata',ud);
         if ~ud.selected
            set(wrkobj.back,'facecolor',varargin{n+1});
         end
      case 'selectedcolor'
         ud=get(wrkobj.back,'userdata');
         ud.selcolor=varargin{n+1};
         set(wrkobj.back,'userdata',ud);
         if ud.selected
            set(wrkobj.back,'facecolor',varargin{n+1});
         end
      case 'selected'
         ud=get(wrkobj.back,'userdata');
         sel=strmatch(varargin{n+1},['off';'on '])-1;
         
         if sel~=ud.selected
            ud.selected=sel;
            set(wrkobj.back,'userdata',ud);
            if sel
               set(wrkobj.back,'facecolor',ud.selcolor);
            else
               set(wrkobj.back,'facecolor',ud.bgcolor);
            end
            set(wrkobj.axestext,'color',1-get(wrkobj.axestext,'color'));
         end
      case 'callback'
         ud=get(wrkobj.back,'userdata');
         ud.callback=varargin{n+1};
         set(wrkobj.back,'userdata',ud);
         if ud.enable
            set(wrkobj.back,'buttondownfcn',varargin{n+1});
         end
      case 'interruptible'
         set(wrkobj.back,'interruptible',varargin{n+1});
      case 'enable'
         ud=get(wrkobj.back,'userdata');
         val=strmatch(lower(varargin{n+1}),['off';'on '],'exact')-1;
         if val~=ud.enable
            ud.enable=val;
            if val
               % re-enable
               set(wrkobj.back,'buttondownfcn',ud.callback);
               if ud.selected
                  set(wrkobj.axestext,'color',1-ud.fgcolor);
               else
                  set(wrkobj.axestext,'color',ud.fgcolor);
               end
            else
               set(wrkobj.back,'buttondownfcn','');
               set(wrkobj.axestext,'color',[.5 .5 .5]);
            end
            set(wrkobj.back,'userdata',ud);
         end
      case 'color'
         ud=get(wrkobj.back,'userdata');
         ud.fgcolor=varargin{n+1};
         set(wrkobj.axestext,'color',varargin{n+1});
         set(wrkobj.back,'userdata',ud);
      case 'value'
         
      case 'userdata'
         ud=get(wrkobj.back,'userdata');
         ud.userdata=varargin{n+1};
         set(wrkobj.back,'userdata',ud);
         
      otherwise
         set(wrkobj.axestext,varargin{n},varargin{n+1});
      end
   end
   obj{k}=wrkobj;
end
% resurrect outputs
nargout=length(obj);
varargout=obj;
return



function i_drawback(obj,pos);
rend=get(get(get(obj.back,'parent'),'parent'),'renderer');
switch lower(rend)
case 'painters'
   pos=pos+[0 -1 0 0];
otherwise
   pos=pos+[0 -1 -1 0];   
end
set(obj.back,'position',pos);
return



function i_drawtext(obj,pos);
set(obj.axestext,'position',pos+[1 0 -1 0]);
return













