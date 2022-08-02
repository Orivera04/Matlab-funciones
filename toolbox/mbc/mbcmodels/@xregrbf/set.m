function varargout = set(r, Property, Value);
% Rbf/SET
%
%   Properties:
%   Centers - centers;
%   Width   - rbf width 
%   Weights - rbf weights;
%   Lambda  - regularisation parameter;
%   Cont    - continuity (only used for Wendland)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:57:18 $


switch lower(Property)
case 'centers'
     r.centers = Value;    
case 'width'
   r.width = Value;   
case 'kernel'
   if ischar(Value)
      Value= str2func(Value);
   end
   r.kernel = Value;   
case 'cont'
      r.cont = Value;
otherwise
   try
      r.xreglinear=set(r.xreglinear,Property,Value);
   catch    
      lasterr
      error(strvcat(['RBF/SET invalid property ',Property],lasterr));  
   end
end
if nargout==1
   varargout{1} = r;
else
   assignin('caller', inputname(1), r);
end
