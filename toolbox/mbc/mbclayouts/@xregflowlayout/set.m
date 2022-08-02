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
%
%  Overloaded methods
%     Position       : (xmin xmax width height) of the whole package.
%     Orientation    : 'LEFT' | 'RIGHT' | 'TOP' | 'BOTTOM' <---- deprecated
%                                      
%                    : 'LEFT/TOP' | 'LEFT/BOTTOM' | 'RIGHT/TOP' | 'RIGHT/BOTTOM' 
%                    : 'TOP/LEFT' | 'TOP/RIGHT' | 'BOTTOM/LEFT' | 'BOTTOM/RIGHT'
%                    : 'LEFT/CENTER' | 'RIGHT/CENTER' | 'TOP/CENTER' | 'BOTTOM/CENTER'
%
%     Gap            : Spacing between blocks
%     Expand         : 'on' | 'off'  --> Sizes the components in the transverse
%                      direction to the flow. Default is off.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:00 $

norepack = 1;
if ~isa(obj,'xregflowlayout')
   builtin('set',obj,parameter,value);
   reqnorepack=1;
else
   ud=obj.g.info;
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      reqnorepack=0;
      switch upper(parameter)
      case 'POSITION'
         obj.xregcontainer = set(obj.xregcontainer,parameter,value);
      case 'EXPAND'
         switch upper(value)
         case {'ON' 'OFF'}
         otherwise
            error('ON | OFF  are the only valid parameters for ''EXPAND''');
         end
         ud.expand = upper(value); 
      case 'ORIENTATION'
         switch upper(value)
         case 'LEFT'
            value='LEFT/TOP';
         case 'RIGHT'
            value='RIGHT/TOP';
         case 'TOP'
            value='TOP/LEFT';
         case 'BOTTOM'
            value='BOTTOM/LEFT';
         case { 'LEFT/TOP' 'LEFT/BOTTOM' 'LEFT/CENTER',...
                  'RIGHT/TOP' 'RIGHT/BOTTOM' 'RIGHT/CENTER',...
                  'TOP/LEFT' 'TOP/CENTER' 'TOP/RIGHT',...
                  'BOTTOM/LEFT' 'BOTTOM/CENTER' 'BOTTOM/RIGHT'}
         otherwise
            error ('Valid orientations are LEFT RIGHT TOP BOTTOM');
         end
         ud.orientation = value;
      case 'GAP'
         ud.gap = value;
      otherwise
         [obj.xregcontainer,reqnorepack] = set(obj.xregcontainer,parameter,value);
      end
      norepack=(norepack & reqnorepack);
   end
   obj.g.info=ud;
end


if ~norepack & get(obj,'boolpackstatus')
   repack(obj);
end