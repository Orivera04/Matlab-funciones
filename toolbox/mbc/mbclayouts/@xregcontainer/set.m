function  [obj,norepack] =set(obj,varargin)
%  Synopsis
%     function  obj = set(obj,parameter,value,parameter,...)
%
%  Description
%
%  Overloaded methods
%     Position : [xmin xmax width height] of the whole package.
%     Elements : { control1 control2 .... controln }
%     TAG      : string
%     PACKSTATUS: 'OFF' | 'ON'
%     USERDATA: MATLAB value
%     PARENT   : parent figure
%     BORDER   : [WEST SOUTH EAST NORTH] border around an object in pixels
%
%
%  See Also
%     methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:35:31 $


if ~isa(obj,'xregcontainer')
   builtin('set',obj,varargin{:});
else
   % turn on UDD repack tracking
   obj.g.TrackRepack=true;
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      if ~isempty(findprop(obj.g,parameter))
         % UDD object property
         set(obj.g,parameter,value);
      else
         el=obj.g.elements;
         L = length(el(:));
         for k = L:-1:1   % reverse order fixes tabbing order problems
            set(el{k},parameter,value);
         end
      end
   end
end

norepack= ~obj.g.NeedRepack;
obj.g.NeedRepack=false;
obj.g.TrackRepack=false;


