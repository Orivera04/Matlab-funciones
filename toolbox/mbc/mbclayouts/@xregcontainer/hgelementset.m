function hgelementset(obj,varargin)
% HGELEMENTSET  Set properties on elements
%
%  HGELEMENTSET(OBJ,'Param1',Value1,...) sets all the HG
%  objects in the layout tree OBJ with the param/value pairs.
%  The properties are recursively passed on down the tree of
%  layouts.
%
%  Using this function properly avoids excessive repacks.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:21 $


e=get(obj,'elements');
for n=1:length(e)
   if isa(e{n},'xregcontainer')
      hgelementset(e{n},varargin{:});
   else
      set(e{n},varargin{:});
   end 
end

