function merge(gr,varargin)
%MERGE  perform merging on cells
%
%   merge(g,Rows,Cols,Rows,Cols,...) defines rectangular blocks
%   of cells to merge together in the gridlayout.  The pairs of 
%   (Rows,Cols) consist of two [start end] vectors indicating the
%   start and end of the merge block in the grid.
%
%   Note that merged blocks may not overlap each other.  This function
%   will error if you attempt to merge a cell that is already part of
%   a group.
%
%  Example:  merge(g,[1 1],[2 4])  
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:17 $

managemerge(gr,'createnblocks',varargin{:});
if get(gr,'boolpackstatus')
   repack(gr);
end