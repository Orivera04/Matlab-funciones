function IsFinObj = isafin(Obj, ClassName)
%ISAFIN returns True if the input argument is a financial 
%   structure type or financial object class.
% 
%   IsFinObj = isafin(Obj, ClassName)
%
%   Inputs:
% 	  Obj - Instance of financial structure.
%
%     ClassName - String containing name of financial structure class.
%
%   Output:
%     IsFinObj - True if input argument is a financial structure type 
%     or financial object class. False otherwise.
%
%   Example:
%     load deriv
%     IsFinObj = isafin(HJMTree, 'HJMFwdTree') returns True.
%
%  See also CLASSFIN.

%   Author(s): J. Akao 12/17/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 21:41:02 $

if isa(Obj, ClassName)
  % an official object class
  IsFinObj = logical(1);
  return
elseif ~isa(Obj, 'struct')
  % Not even a structure
  IsFinObj = logical(0);
  return
elseif ~isfield(Obj, 'FinObj')
  % Not marked financial
  IsFinObj = logical(0);
  return
else
  FinObj = getfield(Obj,'FinObj');
  IsFinObj = strcmp(FinObj, ClassName);
end

  



