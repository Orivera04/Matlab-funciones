function out = precision(T)
%PRECISION

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:03 $

% Convert fileds ina table to the required precision

p = get(T,'precision');

switch p
case 'Signed Floating Point 4 Bytes'
   V = single(get(T,'values'));
case 'Unsigned 8 bit integer';
   V = uint8(get(T,'values'));
case 'Signed 8 bit integer';
   V = int8(get(T,'values'));
case 'Unsigned 16 bit integer'
   V = uint16(get(T,'values'));
case 'Signed 16 bit integer';
   V = int16(get(T,'values'));
case 'Signed Floating Point 8 Bytes';
   V = get(T,'values');
otherwise 
   V = get(T,'values');
end


set(T,'matrix',{V,'Alter table by precision'});

out = double(T);
