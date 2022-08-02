function  set(obj,varargin)
%  Synopsis
%     function   set(obj,parameter,value,setChildren)
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
%     CENTER      :  Center component
%     EAST        :  East component .. same for SOUTH WEST NORTH
%     

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:08 $

norepack = 1;
if ~isa(obj,'xregcenterborderlayout')
   builtin('set',obj,parameter,value);
else
   for arg=1:2:length(varargin)
      parameter = varargin{arg};
      value = varargin{arg+1};
      reqnorepack=0;
      switch upper(parameter)
      case 'CENTER'
         el=get(obj.xreggridlayout,'elements');
         delete(el{5});
         el{5}=value;
         [obj.xreggridlayout,reqnorepack]= set(obj.xreggridlayout,'elements',el);
      case 'WEST'
         el=get(obj.xreggridlayout,'elements');
         delete(el{2});
         el{2}=value;
         [obj.xreggridlayout,reqnorepack]= set(obj.xreggridlayout,'elements',el);
      case 'SOUTH'
         el=get(obj.xreggridlayout,'elements');
         delete(el{6});
         el{6}=value;
         [obj.xreggridlayout,reqnorepack]= set(obj.xreggridlayout,'elements',el);
      case 'EAST'
         el=get(obj.xreggridlayout,'elements');
         delete(el{8});
         el{8}=value;
         [obj.xreggridlayout,reqnorepack]= set(obj.xreggridlayout,'elements',el);
      case 'NORTH'
         el=get(obj.xreggridlayout,'elements');
         delete(el{4});
         el{4}=value;
         [obj.xreggridlayout,reqnorepack]= set(obj.xreggridlayout,'elements',el);
      case 'INNERBORDER'
         data=obj.g.info;
         data.ib=value;
         obj.g.info=data;
      otherwise
         [obj.xreggridlayout,reqnorepack]=set(obj.xreggridlayout,parameter,value);
      end
      norepack=(norepack & reqnorepack);
   end
   
   if ~norepack
      if get(obj,'boolpackstatus')
         repack(obj);
      end
   end
end