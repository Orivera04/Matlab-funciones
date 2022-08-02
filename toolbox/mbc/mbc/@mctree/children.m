function ch=Children(T,varargin);
%MCTREE/CHILDREN list of tree node's children or apply a function to children
%
% ch= children(T,varargin);
% ch= children(T,index)
% out= children(T,'func',varargin)
% out= children(T,index,'func',varargin)
%   evaluates function 'func' and returns output in a cell array.
% 
% Normally this function is called from a pointer.
%   p.children or p.children('func',args);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/02/09 06:47:38 $



ch= T.Children;


if nargin>1
   npos= 1;
   if ~isempty(T) & (isnumeric(varargin{npos}) | islogical(varargin{npos}))
      % index the array of children pointers
      ind= varargin{1};
      ch= ch(ind);
      npos= npos+1;
   end
   
   if npos<=length(varargin) 
       if ~isempty(ch);
           % evaluate 'func' on children pointers
           out= pveceval(ch,varargin{npos:end});
           
           ch= out;
       else
           ch = {};
       end
   end
end
