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
%       POSITION:    Does nothing
%     

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:30 $



norepack = 1;
if ~isa(obj,'xregmanuallayout')
   builtin('set',obj,varargin{:});
   reqnorepack=1;
else
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      
      reqnorepack=0;
      switch upper(parameter)
      case 'POSITION'
         set(obj.xregcontainer,'position',value);
         reqnorepack=1;
      otherwise
         [obj.xregcontainer,reqnorepack]=set(obj.xregcontainer,parameter,value);
      end
      norepack=(norepack & reqnorepack);
   end
end

if ~norepack & get(obj,'boolpackstatus')
   repack(obj);
end
