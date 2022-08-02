function str=name(nd,newname)
%CGOPTIMOUTNODE/NAME  return name for node
%
%  NM = NAME(NODE)
%  NODE = NAME(NODES, NM)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:27:26 $

% This method is overloaded and does NOT pass into the contained objects
% get/setname interface

if nargin < 2 || (nargin==2 & ~ischar(newname))
   % Wanting to get the name of the node
   str = nd.name;
else
   % Wanting to set the name of the node   
   nd.name = newname;
   xregpointer(nd);
   str = nd;
end