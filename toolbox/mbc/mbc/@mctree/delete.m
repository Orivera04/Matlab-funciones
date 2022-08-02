function p=delete(T)
% MCTREE/DELETE deletes tree and frees dynamic memory
% 
% p=delete(T) 
%   normally called via pointer functions as
%     par= p.delete;
% 
% The tree is deleted in post-order (children first)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:41 $




if T.node~=0
   ref= T.node;
   [T,chind]= i_Delete(T);
   if ~isempty(T.Parent) & T.Parent~=0
      T=info(T.Parent);
      % notify parent of deletion
      T= delchild(T,chind); 
   else
      % New Tree is empty
      T.node= xregpointer;
   end
   p= T.node;
else
   error('Deleting null tree')
end


function [T,ind]= i_Delete(T)

if ~isempty(T.Children)
	allch = info(T.Children);
	if ~iscell(allch)
		allch= {allch};
	end
	for i=length(allch):-1:1
		% delete children from last to first
      ch= i_Delete( allch{i} );
   end
end
% order parent to free reference to me
if ~isempty(T.Parent) & T.Parent~=0
   P=info(T.Parent);
   ind=find(P.Children==T.node);
   P.Children=P.Children(P.Children~=T.node);
   P.node.info=P;
else
   ind=[];
end
% free dynamic memory
freeptr(T.node);
