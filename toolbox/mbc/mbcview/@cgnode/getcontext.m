function p=getcontext(nd,tp)
%GETCONTEXT Find the nearest object that is the current context
%
%  P=GETCONTEXT(ND,TP)  finds the nearest object above ND which 
%  matches the type object TP.  This is the "context" of ND.  If TP
%  is omitted then it will be found and used in the search

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:24:54 $

p = address(nd);
if nargin<2
   tp = i_findtp(p);   
end

while ~matchtype(p.typeobject,tp)
   p = p.Parent;
end



function tp= i_findtp(p)
% Look up the tree as far as one below the project, and get the typeobject
% from that node.

sec = address(p.project);

while p.Parent~=sec
   p = p.Parent;   
end
tp = p.typeobject;
return