function str=name(nd,newname)
%NAME  return name for node
%
%  N=NAME(NODE)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:21:59 $

% This method is overloaded to pass into the contained object's getname/setname
% interface

if nargin==1 | (nargin==2 & ~ischar(newname))
   if ~isempty(nd.data)
      if isa(nd.data,'xregpointer')
         p=nd.data;
         str=getname(p.info);
      else
         str=getname(nd.data);
      end
   else
      str=name(nd.cgnode);
   end
else
   if ~isempty(nd.data)
      if isa(nd.data,'xregpointer')
         p=nd.data;
         p.info= p.setname(newname);
      else
         nd.data= setname(nd.data,newname);
      end
   else
      nd.cgnode=name(nd.cgnode,newname);
   end   
   str=nd;
   pointer(nd);
end