function s=size(tbl,varargin)
%TABLE/SIZE   Return size of table object
%   S=SIZE(TBL) returns the size of the table in a length 2 vector
%
%   S+SIZE(TBL,n) returns the size in the n-dimension (n= 1 or 2)
%
%   Note that the size is the total number of rows, ie it ignores
%   the zeroindexing if any is being used.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:49 $


n=0;
if nargin>1
   if varargin{1}==1
      n=1;
   elseif varargin{1}==2
      n=2;
   end
end

% First check to see if the object is valid (to prevent a broken whos command!)
% get table data
if ~ishandle(tbl.frame.handle)
   s=[0 0];
   return
end

global fud
if ~isstruct(fud)
   % Only try to get new data if fud isn't in global memory
   clear global fud
   fud=get(tbl.frame.handle,'userdata');
end
if ~isempty(fud)
   if n==0
      s=[fud.rows.number fud.cols.number];
   elseif n==1
      s=[fud.rows.number];
   elseif n==2
      s=[fud.cols.number];
   end
else
   s=[NaN NaN];
end


return