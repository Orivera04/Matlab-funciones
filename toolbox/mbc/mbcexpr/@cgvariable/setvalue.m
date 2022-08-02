function [ptr, OK, msg] = setvalue(obj, val, ptr)
% CGVALUE/SETVALUE Set the value of a value object
%
% INPUTS:   symvalueobj -   Object whose value is to be set
%           val         -   New value it is to take
%           ptr         -   Ptr to the cgvalue it will alter. (optional)
%
% OUTPUT:   pRepVal     -   Pointer to the cgvalue object that has been altered 
%           OK          -   0/1
%           msg         -   Error message

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:17:04 $

if nargin>2
    if ~isequal(ptr.info, obj)
        OK = 0;
        msg = ['Problem setting the value of ' getname(obj) '. The pointer does not point to the cgvalue.']; 
        ptr = [];
        return
    end
end

%First of all, check to see if the value is actually a double.
if isa(val , 'double')  
    OK = 1;
    msg = [];
    obj.Value = val(:);
else
    OK = 0;
    msg = 'Can only set a double to a value object';
end

if nargin>2
    ptr.info = obj;
else
    ptr = obj;
end