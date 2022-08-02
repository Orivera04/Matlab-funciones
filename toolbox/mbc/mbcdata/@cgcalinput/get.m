function out = get(s , property)
%cgcalinput/GET
%
%Gets the properties of the cgcalinput object.
%
%Usage: get(add_obj , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:49:17 $

if nargin==1
   out.Filename = 'Name of the file to be imported';
   out.Type = 'Type of the file to be imported';
elseif nargin == 2
   if ~isa(property , 'char')
      error('cgcalinput\get: Non character array property name.');
   end
   out='';
   switch lower(property)
   case 'filename'
      out = s.filename; 
   case 'type'
      out = s.inputFcn;
   otherwise
      error(['cgcalinput\get: Unknown property name: ''' property '''.']); 
   end
else
   error('cgcalinput\get: Insufficient arguments.');
end
