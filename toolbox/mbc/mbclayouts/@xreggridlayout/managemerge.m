function managemerge(obj,action,varargin)
%MANAGEMERGE  Low-level cell-merging management
%
%  MANAGEMERGE(G,ACTION,varargin)
%
%  see XREGGRIDBAGLAYOUT for the external API to this function
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:36:11 $

switch lower(action)  
case 'createblock'
    obj.hGrid.merge(varargin{:});
case 'createnblocks'
    obj.hGrid.merge(varargin{:});
case 'clearall'
    obj.hGrid.clearMerge;
case 'clearblock'
   % clear the block specified by top-left corner cell [r,c]
   R=varargin{1}(1);
   C=varargin{1}(2);
   obj.hGrid.clearMerge(R,C)
end
