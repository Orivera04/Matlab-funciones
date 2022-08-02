function  varargout=set(obj,varargin)
%  Synopsis
%     function  set(obj,parameter,value,setChildren)
%
%  Description
%     Set the parameter of the handles. This works very similar
%     to the set methods for handles. The only difference is that
%     some methods have been overloaded to peform differently
%     on the package. Non overload methods just peform the set
%     recursively on all submembers.
%
%  Overloaded set methods
%     POSITION       : [xmin ymin width height] of the whole package.
%     VISIBLE        : 'on' or 'off'
%     CURTAINDIRECTION: North/South/East/West
%     CURTAINFX      : 'on'/'off'
%     CENTER         : Layout to use
%     EDGEITEM       : 'on'/'off'
%     EDGEITEMTYPE   
%     OPENOFFSET     : Offset of the curtain edge away from the layout
%                      position when open
%     CLOSEDOFFSET   : Offset of the curtain edge away from the layout
%                      position when closed
%     STEPSIZE       : Pixels to step in each iteration
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:41 $


norepack = 1;
if ~isa(obj,'xregcurtainfxlayout')
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
      case 'CURTAINDIRECTION'
         ud.slidedir=strmatch(lower(value),['north';'east ';'south';'west '],'exact');
         reqnorepack=1;
      case 'CURTAINFX'
         ud.slidefx=strmatch(value,['off';'on '],'exact')-1;
         reqnorepack=1;
      case 'EDGEITEM'
         ud.edgeitem=strmatch(value,['off';'on '],'exact')-1;
         reqnorepack=1;
      case 'EDGEITEMTYPE'
         reqnorepack=1;
      case 'OPENOFFSET'
         ud.offsets(1)=value;
         reqnorepack=1;
      case 'CLOSEOFFSET'
         ud.offsets(2)=value;
         reqnorepack=1;
      case 'STEPSIZE'
         ud.stepsize=value;
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
el=get(obj.xregcontainer,'elements');
if ~isempty(el)
   h=el{1};
   if ud.slidefx
      objpos=get(obj,'innerposition');
      % add offsets
      switch ud.slidedir 
      case 1
         objpos([2 4])=objpos([2 4])+[-ud.offsets(2) sum(ud.offsets)];
         dist=objpos(4);
         orient='horizontal';
         divpos=[objpos(1) objpos(2)-1 objpos(3) 2];
      case 2
         objpos([1 3])=objpos([1 3])+[-ud.offsets(2) sum(ud.offsets)];
         dist=objpos(3);
         orient='vertical';
         divpos=[objpos(1)-1 objpos(2) 2 objpos(4)];
      case 3
         objpos([2 4])=objpos([2 4])+[-ud.offsets(1) sum(ud.offsets)];
         dist=objpos(4);
         orient='horizontal';
         divpos=[objpos(1) objpos(2)+objpos(4)-2 objpos(3) 2];
      case 4
         objpos([1 3])=objpos([1 3])+[-ud.offsets(1) sum(ud.offsets)];
         dist=objpos(3);
         orient='vertical';
         divpos=[objpos(1)+objpos(3)-2 objpos(2) 2 objpos(4)];
      end
      Nsteps=max(1,floor(dist./ud.stepsize));
      % exact stepsize
      step=dist./Nsteps;
      step=step.*(0:Nsteps)-1;
      step=step(:);
      objdelt=zeros(Nsteps+1,4);
      edgedelt=objdelt;
      switch ud.slidedir
      case 1
         objdelt(:,2)=step;
         objdelt(:,4)=-step;
         edgedelt(:,2)=step;
      case 2
         objdelt(:,1)=step;
         objdelt(:,3)=-step;
         edgedelt(:,1)=step;
      case 3
         objdelt(:,4)=-step;
         edgedelt(:,2)=-step;
      case 4
         objdelt(:,3)=-step;
         edgedelt(:,1)=-step;
      end
      objpos=repmat(objpos,Nsteps+1,1)+objdelt;
      divpos=repmat(divpos,Nsteps+1,1)+edgedelt;
      
      % create curtain object(s)
      curtain=uicontrol('parent',ud.parent,...
         'style','text',...
         'backgroundcolor',get(ud.parent,'color'),...
         'position',objpos(1,:));
      if ud.edgeitem
         edge=xregGui.dividerline(ud.parent,'position',divpos(1,:),'orientation',orient,'visible','on');
      end
      set(h,'visible','on');
      drawnow;
      
      % curtain up
      for n=2:Nsteps+1
         set(curtain,'position',objpos(n,:));
         if ud.edgeitem
            set(edge,'position',divpos(n,:));
         end
         drawnow
      end
      
      delete(curtain);
      delete(edge);
   else
      set(h,'visible','on');
   end
end
return





function ud=i_visoff(obj,ud)
el=get(obj.xregcontainer,'elements');
if ~isempty(el)
   h=el{1};
   if ud.slidefx
      objpos=get(obj,'innerposition');
      % add offsets
      switch ud.slidedir 
      case 1
         objpos([2 4])=objpos([2 4])+[-ud.offsets(2) sum(ud.offsets)];
         dist=objpos(4);
         orient='horizontal';
         divpos=[objpos(1) objpos(2)-1 objpos(3) 2];
      case 2
         objpos([1 3])=objpos([1 3])+[-ud.offsets(2) sum(ud.offsets)];
         dist=objpos(3);
         orient='vertical';
         divpos=[objpos(1)-1 objpos(2) 2 objpos(4)];
      case 3
         objpos([2 4])=objpos([2 4])+[-ud.offsets(1) sum(ud.offsets)];
         dist=objpos(4);
         orient='horizontal';
         divpos=[objpos(1) objpos(2)+objpos(4)-2 objpos(3) 2];
      case 4
         objpos([1 3])=objpos([1 3])+[-ud.offsets(1) sum(ud.offsets)];
         dist=objpos(3);
         orient='vertical';
         divpos=[objpos(1)+objpos(3)-2 objpos(2) 2 objpos(4)];
      end
      Nsteps=max(1,floor(dist./ud.stepsize));
      % exact stepsize
      step=dist./Nsteps;
      step=step.*(0:Nsteps)-1;
      step=step(:);
      objdelt=zeros(Nsteps+1,4);
      edgedelt=objdelt;
      switch ud.slidedir
      case 1
         objdelt(:,2)=step;
         objdelt(:,4)=-step;
         edgedelt(:,2)=step;
      case 2
         objdelt(:,1)=step;
         objdelt(:,3)=-step;
         edgedelt(:,1)=step;
      case 3
         objdelt(:,4)=-step;
         edgedelt(:,2)=-step;
      case 4
         objdelt(:,3)=-step;
         edgedelt(:,1)=-step;
      end
      objpos=repmat(objpos,Nsteps+1,1)+objdelt;
      divpos=repmat(divpos,Nsteps+1,1)+edgedelt;
      objpos=objpos(end:-1:1,:);
      divpos=divpos(end:-1:1,:);
      
      % create curtain object(s)
      curtain=uicontrol('parent',ud.parent,...
         'style','text',...
         'backgroundcolor',get(ud.parent,'color'),...
         'position',objpos(1,:));
      if ud.edgeitem
         edge=xregGui.dividerline(ud.parent,'position',divpos(1,:),'orientation',orient,'visible','on');
      end
      drawnow;
      
      % curtain up
      for n=2:Nsteps+1
         set(curtain,'position',objpos(n,:));
         if ud.edgeitem
            set(edge,'position',divpos(n,:));
         end
         drawnow
      end
      set(h,'visible','off');
      drawnow;
      delete(curtain);
      delete(edge);
   else
      set(h,'visible','off');
   end
end
return