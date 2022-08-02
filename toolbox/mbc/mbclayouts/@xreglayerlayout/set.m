function  set(obj,varargin)
%  Synopsis
%     function  set(obj,parameter,value,setChildren)
%
%  Description
%     Set the parameter of the handles. This works very similar
%     to the set methods for handles. The only difference is that
%     some methods have been overloaded to peform differently
%     on the package. Non overload methods just peform the set
%     recursively on all submembers.
%
%
%  Overloaded set methods
%     POSITION :     [xmin xmax width height] of the whole package.
%     

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:26 $

norepack = 1;
if ~isa(obj,'xreglayerlayout')
   builtin('set',obj,varargin{:});
   reqnorepack=1;
else
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      reqnorepack=0;
      switch upper(parameter)
      case 'POSITION'
         position=value;
         if position(3) <= 0
            position(3) = 1;
         end
         if position(4) <= 0
            position(4) = 1;
         end
         set(obj.xregcontainer,'position',position);
      otherwise
         [obj.xregcontainer,reqnorepack]=set(obj.xregcontainer,parameter,value);
      end
      norepack=(norepack & reqnorepack);
   end
end

if ~norepack & get(obj,'boolpackstatus')
   repack(obj);
end
