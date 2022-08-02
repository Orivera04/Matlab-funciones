function varargout=set(varargin)
%ROLLER/SET   Set interface for the roller object
%   Classic set function for the roller object
%   properties are:
%                  String: 2 element cell array
%                  Value: 1 or 0
%                  Position: 4 element vector
%                  Visible: on/off
%                  Callback: string for callback.  You may
%                            optionally include the strings
%                            %VALUE% and %OBJECT% in the callback
%                            to be passed the current value 
%                            and object respectively.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:27 $


% Bail if we've not been given a roller object
objfind=1;
while objfind
   if strcmp(class(varargin{objfind}),'roller')
      rl(objfind)=varargin(objfind);
      objfind=objfind+1;
   else
      varargin=varargin(objfind:end);
      objfind=0;
   end   
end


if ~iscell(rl)
   rl={rl};
end

for k=1:length(rl)
   wrkrl=rl{k};
   
   % loop over varargin
   for n=1:2:(nargin-2)
      switch lower(varargin{n})
      case 'position'
         wrkrl=i_position(wrkrl,varargin{n+1});      
      case 'visible'
         wrkrl=i_visible(wrkrl,varargin{n+1}); 
      case 'parent'
         set([wrkrl.frame1;wrkrl.text1;wrkrl.frame2;wrkrl.text2],'parent',varargin{n+1});
      case 'string'
         set([wrkrl.text1;wrkrl.text2],{'string'},varargin{n+1}(:));
      case 'value'
         wrkrl=i_value(wrkrl,varargin{n+1});
      case 'enable'
         % can't allow items to have enable on as this will break object
         switch lower(varargin{n+1})
         case {'on','inactive'}
            en='inactive';
         case 'off'
            en='off';
         end
         set([wrkrl.frame1;wrkrl.text1;wrkrl.frame2;wrkrl.text2],'enable',en);
         
      case 'callback'
         ud=get(wrkrl.text2,'userdata');
         if ischar(varargin{n+1})
            ud.callback=varargin{n+1};
            if isempty(varargin{n+1})
               ud.cbactive=0;   
            else
               ud.cbactive=1; 
            end         
         end
         set(wrkrl.text2,'userdata',ud);
         
      otherwise
         % attempt to pass on to all objects
         set([wrkrl.frame1;wrkrl.text1;wrkrl.frame2;wrkrl.text2],varargin{n},varargin{n+1});
      end
   end
   rl{k}=wrkrl;
end
% resurrect outputs
nargout=length(rl);
varargout=rl;

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_position  -  alter position of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rl=i_position(rl,newpos);

set([rl.frame1;rl.frame2],'position',newpos);
set([rl.text1;rl.text2],'position',[newpos(1)+1,newpos(2)+1,newpos(3)-2,newpos(4)-2]);

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_visible  -  alter visible status of object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rl=i_visible(rl,vis);

if strcmp(vis,'off')
   hnds=struct2cell(rl);
   set([hnds{:}],'visible','off');
   set(rl.frame1,'userdata',0);
else
   % decide which is on
   if get(rl.frame2,'userdata')
      %state2
      set([rl.frame2;rl.text2],'visible','on');
   else
      %state1
      set([rl.frame1;rl.text1],'visible','on');
   end
   set(rl.frame1,'userdata',1);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_value  -  alter value field of object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rl=i_value(rl,val);

% convert to 1/0
if val
   val=1;
else
   val=0;
end

% perform roll if value changed
if val~=get(rl.frame2,'userdata')
   if get(rl.frame1,'userdata')
      % do graphical roll
      if val
         pr_transitionon(rl)
      else
         pr_transitionoff(rl)
      end
   end
   set(rl.frame2,'userdata',val);
end

return










