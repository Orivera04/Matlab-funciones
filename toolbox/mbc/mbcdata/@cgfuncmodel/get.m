function out = get(F, property)
%cgFuncModel/GET method.
%
%Gets the properties of the cgFuncModel object.
%
%Usage: get(cgFuncModel , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:54 $

if nargin < 2
   error('cgFuncModel\get: Insufficient arguments.');
end

if ~isa(property , 'char')
   error('cgFuncModel\get: Non character array property name.');
end

switch property
case 'function'   
   out = char(F);
case 'arguments'
   [n,out] = nfactors(F);
case 'units'
   [n,s,out] = nfactors(F);
otherwise
   try
      out=get(F.xregexportmodel,property);
   catch
      error(['cgFuncModel\get: Unknown property name: ''' property '''.']);   
   end
end
