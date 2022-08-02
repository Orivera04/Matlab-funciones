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
%  Overloaded methods
%     radiusRatio    -  The ratio of the radius of the ring to half
%                       the length of the shortest dimension of the enclosing
%                       box.
%     phase          -  The start angle with which the ring is built
%                       
%     
%  Example
%     b = {uicontrol('string','Ring Layout','position',[0 0 100 50])};
%     for k = 2:10
%        b{k} = uicontrol('position',[0 0 10 10],'backgroundcolor',[rand(1) rand(1) rand(1)]);
%     end
%     r = xregringlayout('elements',b,'radiusratio',0.5);
%     b = xregborderlayout('center',r,'container',gcf);
%     set(b,'packstatus','on');
%     set(gcf,'resizefcn','repack(b)');
%
%     for k = 0:0.1:(2*pi)
%        set(r,'phase',k)
%        pause(0.25);
%        drawnow;
%     end
%     
%
%
%  See Also
%     methods xregcontainer
%     methods xregringlayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:45 $


norepack = 1;
if ~isa(obj,'xregringlayout')
   builtin('set',obj,parameter,value);
   reqnorepack=1;
else
   ud=obj.g.info;
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      reqnorepack=0;
      switch upper(parameter)
      case 'RADIUSRATIO'
         ud.radiusratio = value;
      case 'PHASE'
         ud.phase = value;
      otherwise
         [obj.xregcontainer,reqnorepack] = set(obj.xregcontainer,parameter,value);
      end
   end
   obj.g.info=ud;
   norepack=(norepack & reqnorepack);
end

if ~norepack & get(obj,'boolpackstatus')
   repack(obj);
end



