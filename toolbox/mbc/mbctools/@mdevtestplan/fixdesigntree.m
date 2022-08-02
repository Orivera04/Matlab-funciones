function T=fixdesigntree(T)
% FIXDESIGNTREE
% If necessary, fixes the design tree to include the chosen design

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:45 $

% Created 2/6/2000


% clear up a bug which may have crept in in old version 4 files
% first check the design tree is initialised correctly
if isempty(T.DesignTree.designs)
   % add a root node
   T.DesignTree.designs={designobj(model(T.modeldev))};
   T.DesignTree.parents=[0];
   T.DesignTree.chosen=1;   
end

if T.Matched & (isempty(T.DesignTree.chosen) | T.DesignTree.chosen==1)
   % the chosen design appears not to be in the tree.  Add it if possible
   T.DesignTree.designs(end+1)={T.Design.info};
   T.DesignTree.parents(end+1)=1;
   T.DesignTree.chosen=length(T.DesignTree.parents);
end

pointer(T);

