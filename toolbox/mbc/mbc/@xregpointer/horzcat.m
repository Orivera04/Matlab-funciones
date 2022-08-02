function q=horzcat(varargin);
% XREGPOINTER/HORZCAT horizontal concatenation of pointers
%
% s= [p,q];
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:11 $



isemp= cellfun('isempty',varargin);
list= varargin(~isemp);

q= list{1};
if ~isa(q,'xregpointer') 
   error('You can only concatenate pointers')
end

for i=2:length(list)
   p= list{i};
   if isa(p,'xregpointer')
      q.ptr= [q.ptr p.ptr];
   elseif isa(p,'double') & ~any(any(p));
      q.ptr= [q.ptr p];
   else
      error('You can only concatenate pointers')
   end
end