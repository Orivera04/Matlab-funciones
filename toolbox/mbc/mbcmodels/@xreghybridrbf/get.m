function Value = get(m, Property, varargin);
% HYBRIDRBF/GET
%
%   Properties:
%   RbfPart
%   LinearmodPart
%   ChosenOrder
%   Lambda

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:48:06 $



if nargin == 1
   Value = [{'rbfpart','linearmodpart','chosenorder','lambda'}'; get(m.xreglinear)];
else
   switch lower(Property)
   case 'rbfpart'
      Value=m.rbfpart;    
   case 'linearmodpart'
      Value = m.linearmodpart;  
   case 'chosenorder'
      Value = m.chosenorder;
   case 'centers'
      Value = get(m.rbfpart,'centers');
   otherwise
      try
         Value=get(m.xreglinear,Property);
      catch
         try
            Value = builtin('subsref',m,substruct('.',Property));
         catch
            error('XREGHYBRIDRBF/GET invalid property');
         end
      end
   end   
end
