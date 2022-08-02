function  varargout=set(obj,varargin)
%  Synopsis
%     function  set(obj,parameter,value)
%
%  Description
%     Set the parameter of the handles. This works very similar
%     to the set methods for handles. The only difference is that
%     some methods have been overloaded to peform differently
%     on the package. Non overload methods just peform the set
%     recursively on all submembers.
%
%
%  Overloaded set methods
%     POSITION       : [xmin ymin width height] of the whole package.
%     VISIBLE        : 'on' or 'off'
%     SLIDEDIRECTION : North/South/East/West
%     SLIDEFX        : 'on'/'off'
%     CENTER         : Layout to use
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:52 $


norepack = 1;
if ~isa(obj,'xregslidefxlayout')
   builtin('set',obj,varargin{:});
   reqnorepack=1;
else      
   ud=obj.g.info;
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      reqnorepack=0;
      switch upper(parameter)
      case 'POSITION'
         position=value;
         position(3:4)=max(position(3:4),[1 1]);
         set(obj.xregcontainer,'position',position);
      case 'VISIBLE'
         vis=strmatch(value,['off';'on '],'exact')-1;
         if vis~=ud.visible
            ud.visible=vis;
            if vis
               % vis ON FX
               ud=i_vison(obj,ud);
            else
               % vis OFF FX
               ud=i_visoff(obj,ud);
            end
         end
         reqnorepack=1;
      case 'CENTER'
         set(obj.xregcontainer,'elements',{value});         
      case 'SLIDEDIRECTION'
         ud.slidedir=strmatch(lower(value),['north';'east ';'south';'west '],'exact');
         reqnorepack=1;
      case 'SLIDEFX'
         ud.slidefx=strmatch(value,['off';'on '],'exact')-1;
         reqnorepack=1;
      otherwise
         [obj.xregcontainer,reqnorepack]=set(obj.xregcontainer,parameter,value);
      end
      norepack=(norepack & reqnorepack);   
   end
   obj.g.info=ud;
end

if nargout>1
   varargout{1}=obj;
   varargout{2}=norepack;   
else
   varargout{1}=obj;
   if ~norepack & get(obj,'boolpackstatus')
      repack(obj);
   end
end





function ud=i_vison(obj,ud)
h=get(obj,'elements');
if ~isempty(h)
   
   h=h{1};
   if ud.slidefx
      % slide layout in
      pos=get(obj.xregcontainer,'innerposition');
      figpos=get(get(obj,'parent'),'position');
      switch ud.slidedir
      case 1
         dist=figpos(4)-pos(2);
      case 2
         dist=figpos(3)-pos(1);
      case 3
         dist=pos(2)+pos(4)-1;
      case 4
         dist=pos(1)+pos(3)-1;
      end
      delt=i_deltas(dist);
      nsteps=length(delt);
      pos2=repmat(pos,nsteps,1);
      switch ud.slidedir
      case 1
         pos2(:,2)=pos2(:,2)+delt;
      case 2
         pos2(:,1)=pos2(:,1)+delt;
      case 3
         pos2(:,2)=pos2(:,2)-delt;
      case 4
         pos2(:,1)=pos2(:,1)-delt;
      end
      
      % move layout offscreen
      set(h,'position',pos2(end,:),'visible','on');
      drawnow;
      
      for n=(nsteps-1):-1:1
         set(h,'position',pos2(n,:));
         drawnow;
      end
      
      % move to final position
      set(h,'position',pos);
   else
      set(h,'visible','on');
   end
end
return





function ud=i_visoff(obj,ud)
h=get(obj.xregcontainer,'elements');
if ~isempty(h)
   h=h{1};
   
   if ud.slidefx
      % slide layout out
      pos=get(obj.xregcontainer,'innerposition');
      figpos=get(get(obj,'parent'),'position');
      switch ud.slidedir
      case 1
         dist=figpos(4)-pos(2);
      case 2
         dist=figpos(3)-pos(1);
      case 3
         dist=pos(2)+pos(4)-1;
      case 4
         dist=pos(1)+pos(3)-1;
      end
      delt=i_deltas(dist);
      nsteps=length(delt);
      pos2=repmat(pos,nsteps,1);
      switch ud.slidedir
      case 1
         pos2(:,2)=pos2(:,2)+delt;
      case 2
         pos2(:,1)=pos2(:,1)+delt;
      case 3
         pos2(:,2)=pos2(:,2)-delt;
      case 4
         pos2(:,1)=pos2(:,1)-delt;
      end
      
      for n=1:nsteps
         set(h,'position',pos2(n,:));
         drawnow;
      end
      set(h,'visible','off','position',pos);
   else
      set(h,'visible','off');
   end
end
return




function delt=i_deltas(dist)
% return the position offsets needed to achieve distance dist
steps=(1:50)';
delt=cumsum((steps.^2)./10);
delt=delt([1; delt(1:end-1)]<dist);
return


