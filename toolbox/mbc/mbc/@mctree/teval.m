function varargout= teval(T,func,varargin)
% MCTREE/TEVAL evaluate function on tree node.
% 
% varargout= teval(T,'func',varargin)
%  If there are no output arguments then it is assumed that the 
%  function output is a tree and the dynamic copy of the tree is
%  updated.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:48:07 $



if nargout==0
   T=feval(func,T,varargin{:});
   pointer(T);
else
   [varargout{1:nargout}]= feval(func,T,varargin{:});
end
