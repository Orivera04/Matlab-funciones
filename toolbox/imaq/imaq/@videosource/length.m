function out = length(obj)
%LENGTH Length of image acquisition object array.
%
%    LENGTH(OBJ) returns the length of image acquisition object 
%    array, OBJ. It is equivalent to MAX(SIZE(OBJ)).  
%    
%    See also IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:49 $

% The UDD object property of the object indicates the number of 
% objects that are concatenated together.
try
   out = builtin('length', obj.uddobject);
catch
   out = 1;
end




