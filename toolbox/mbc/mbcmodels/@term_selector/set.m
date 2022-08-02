function set(t,varargin)
%TERM_SELECTOR/SET   Set interface for term selector
%   Overloads set function for table, in order to limit width.
%   Everything else is passed directly on

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:44:12 $


setvis=0;
% go through looking for position and visible calls
for n=1:2:nargin-2
   switch lower(varargin{n})
   case 'position'
      % limit table width to limit damage to memory!
      ud=get(t.xregtable,'userdata');
      %need to grab out position setting and limit it
      pos=varargin{n+1};
      if pos(3)<200 | pos(4)<50
         ud.killedvis=1;
         setvis=1;
         % size bad image
         imsz=min([32,pos(3),pos(4)]);
         centrex=(pos(3)*0.5)/200;
         centrey=(pos(4)*0.5)/50;
         % dummy pos
         pos(3)=200;
         pos(4)=50; 
         % need to calc position of icon
         tmp=((imsz-1)*0.5);
         imposx=[centrex-tmp./pos(3) centrex+tmp./pos(3)];
         imposy=[centrey-tmp./pos(4) centrey+tmp./pos(4)];
         set(ud.badim,'xdata',imposx,'ydata',imposy);         
      else
         %centre the term selector
         pos(1)=pos(1)+(pos(3)-200).*0.5;
         pos(3)=200;
         ud.killedvis=0;
         setvis=1;
      end
      varargin{n+1}=pos;
      set(t.xregtable,'userdata',ud);
   case 'visible'
      % need to trap visible call and alter if necessary
      vis=varargin{n+1};
      ud=get(t.xregtable,'userdata');
      setvis=0;
      % set bad image on/off
      if strcmp(lower(vis),'on')
         if ud.killedvis
            vis='off';
            set(ud.badim,'visible','on');
         else
            set(ud.badim,'visible','off');
         end
         ud.visible=1;
      elseif strcmp(lower(vis),'off')
         set(ud.badim,'visible','off');
         ud.visible=0;
      end
      varargin{n+1}=vis;
      set(t.xregtable,'userdata',ud);
   end 
end

if setvis
   % the killedvis setting has changed so tack a visible
   % call onto the end
   if ud.killedvis
      vis='off';
      if ud.visible;
         set(ud.badim,'visible','on');
      else
         set(ud.badim,'visible','off');
      end
   else
      set(ud.badim,'visible','off');
      if ud.visible
         vis='on';
      else
         vis='off';
      end
   end
   varargin(end+1)={'visible'};
   varargin(end+1)={vis};
end

%pass it all on to table
set(t.xregtable,varargin{:});

return