function h=cgbrowser(varargin)
%CGBROWSER  External interface to cgtools.cgbrowser
%
%  h=CGBROWSER returns the persistent handle to the cgbrowser
%  object.
%
%  This file also acts as the harbinger of all the browser activeX
%  callbacks.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.7.2.2 $  $Date: 2004/02/09 08:39:21 $

persistent objH

% Search for a current cgbrowser, else return a new one    
if isempty(objH)
   % make absolutely sure CAGE isn't around somewhere?     
   fH=cgf;
   if ~isempty(fH)         
      % get handle from userdata
      objH= get(handle(fH),'CGB');
   else
      % create a blank new object
      objH= cgtools.cgbrowser;
   end
   %  MLOCK might make the objH appear more often - won't have to go to fH userdata
   %mlock;   
elseif ~isa(objH,'cgtools.cgbrowser')
   % handle has been deleted?  Create a valid one
   objH= cgtools.cgbrowser;
end


if nargin
   % Active X callbacks
   ev=varargin{2};
   srcobj=varargin{1};
   hFig=objH.Figure;
   MM=MotionManager(hFig);
   MM.EnableTree=false;
   % switch on object
   switch srcobj.userdata
   case 'tree'
      switch ev
      case {13,11}
         % click event, node collapse event
         PR=xregGui.PointerRepository;
         ptrID=PR.stackSetPointer(hFig,'watch');
         try
            key= get(srcobj.SelectedItem,'key');
            pindex= sscanf(key,'K%d;S%d');
            p= assign(xregpointer,pindex(1));
            p_sub=assign(xregpointer,pindex(2));
         catch
            p=xregpointer;
            p_sub=p;
         end
         if p~=objH.CurrentNode | p_sub~=objH.CurrentSubItem
            if objH.lock
               objH.setnewnode(p,p_sub);
               objH.unlock;
            end
         end
         PR.stackRemovePointer(hFig,ptrID);
      case 3
         % Key press event
         keycode= double(varargin{3});
         switch keycode
         case {16,17}
            % shift and control keys
            return
         case 45
            % Insert
            %objH.NewNode;
         case 46
            % Delete
            if objH.lock
               if objH.IsDeleteEnabled
                  objH.deletenode;
               end
               objH.unlock;
            end
         case 113
            % F2
            if objH.lock
               srcobj.StartLabelEdit;
               objH.unlock
            end
         otherwise
            % Spoof a click event
            cgbrowser(varargin{1}, 13);
         end
      case 9
         % Label Event
         cancel=varargin{3};
         newstring=varargin{4};
         if ~cancel
            try
               key= get(srcobj.SelectedItem,'key');
               pindex= sscanf(key,'K%d;S%d');
               p= assign(xregpointer,pindex(1));
               p_sub=assign(xregpointer,pindex(2));
            catch
               p=xregpointer;
               p_sub=p;
            end
            oldstring=p.name(p_sub);
            if objH.HasRelabelManager
               % custom rename procedure
               ok=feval(objH.getRelabelFunction,p.info,p_sub,newstring);
            else
               % standard rename method - operates on primary item
               ok=p.rename(newstring);
            end
            if ~ok
               srcobj.CancelNextLabelEdit=1;
            else
               % check that there are not duplicate items to rename on tree - activex method for speed
               srcobj.UpdateLabels(srcobj.SelectedItem,oldstring,newstring);
               objH.doDrawText;
               objH.ViewNode;
            end
         end
      case 14
         % Right-click event
         % Call the context handler for the current node
         if objH.lock
            objH.opencontext(srcobj,varargin{3},varargin{4});
            objH.unlock;
         end
      end
   case 'list'
      switch ev
      case 12
         % click event
         PR=xregGui.PointerRepository;
         ptrID=PR.stackSetPointer(hFig,'watch');         
         try
            key= get(srcobj.SelectedItem,'key');
            pindex= sscanf(key,'K%d;S%d');
            p= assign(xregpointer,pindex(1));
            p_sub=assign(xregpointer,pindex(2));
         catch
            p=xregpointer;
            p_sub=p;
         end
         if objH.lock
            objH.setnewnode(p,p_sub);
            objH.unlock;
         end
         PR.stackRemovePointer(hFig,ptrID);
      case 5
         % Key press event
         keycode= double(varargin{3});
         switch keycode
         case {16,17}
            % shift and control keys
            return
         case 45
            % Insert
            %objH.NewNode;
         case 46
            % Delete
            if objH.lock
               if objH.IsDeleteEnabled
                  objH.deletenode;
               end
               objH.unlock;
            end
         case 113
            % F2
            if objH.lock
               srcobj.StartLabelEdit;
               objH.unlock
            end
         otherwise
            % Spoof a click event
            cgbrowser(varargin{1}, 1);
         end
      case 9
         % Label Event
         cancel=varargin{3};
         newstring=varargin{4};
         if ~cancel
            try
               key= get(srcobj.SelectedItem,'key');
               pindex= sscanf(key,'K%d;S%d');
               p= assign(xregpointer,pindex(1));
               p_sub=assign(xregpointer,pindex(2));
            catch
               p=xregpointer;
               p_sub=p;
            end
            if objH.HasRelabelManager
               % custom rename procedure
               ok=feval(objH.getRelabelFunction,p.info,p_sub,newstring);
            else
               % standard rename method - operates on primary item
               ok=p.rename(newstring);
            end
            if ~ok
               srcobj.CancelNextLabelEdit=1;
            else
               objH.doDrawText;
               objH.ViewNode;
            end
         end
      case 13
         % Right-click event
         % Call the context handler for the current node
         if objH.lock
            objH.opencontext(srcobj,varargin{3},varargin{4});
            objH.unlock;
         end
      end
   end
   MM.EnableTree=true;
else
   h=objH;   
end