function Value=get(m,Property);
% LOCALMOD/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:05 $

if nargin==1
   % list of available properties
   Value= {'values', 'features',...
         'feat.func','feat.disp','feat.name','feat.index',...
         'delg','datumtype','IsDatum'}';
else 
   switch lower(Property)
   case 'values'
      Value= m.Values;
   case 'features'
      Value= m.Type;
   case 'feat.func'
      Value= {m.Type.Function};
   case 'feat.disp'
      Value= {m.Type.Display};
   case 'feat.name'
      Value= {m.Type.Name};
   case 'feat.index'
      if isfield(m.Type,'index');
         Value= [m.Type.index];
      else
         Value= zeros(size(m.Values,1));
      end
   case 'delg'
      Value= m.delG;
   case 'datumtype'
      Value= m.DatumType;
   case 'limits'
      Value= m.Limits;
   case 'isdatum'
      Value= [m.Type.IsDatum];
   otherwise
      error('LOCALMOD/GET invalid property')
   end
end