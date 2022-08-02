function iseq = eq(arg1, arg2)
%EQ OPC Toolbox object equality test.
%   EQ(A,B) overloads A==B for OPC Toolbox objects.
%
%   Two objects are equal if they reference the same entity. Two objects
%   with the same properties need not necessarily be equal, since they may
%   represent two different entities. For example, two opcda objects may
%   be connected to the same server, and be in the same state, but will
%   not be equal because they represent two separate clients with the same
%   characteristics.
%
%   An invalid object (one that has been deleted) is not equal to
%   anything, including another invalid object.
%
%   See also OPCROOT/NEQ.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/03/24 20:43:26 $

% Error appropriately if one of the input arguments is empty.
if isempty(arg1)
    if (length(arg2) == 1)
        iseq = [];
    else
        rethrow(mkerrstruct('opc:eq:dimagree'));
    end
    return
elseif isempty(arg2)
    if (length(arg1) == 1)
        iseq = [];
    else
        rethrow(mkerrstruct('opc:eq:dimagree'));
    end
    return;
end
% Error if both the objects have a length greater than 1 and have
% different sizes.
sizeOfArg1 = size(arg1);
sizeOfArg2 = size(arg2);
if ~(all(sizeOfArg1 == sizeOfArg2)) && any(sizeOfArg1>1) && any(sizeOfArg2>1)
        rethrow(mkerrstruct('opc:eq:dimagree'));
end

% Initialise to false for all elements
if length(arg1)>length(arg2),
    iseq = false(size(arg1));
else
    iseq = false(size(arg2));
end

% Only continue if both objects are identical opc objects.
if isa(arg1,'opcroot') && isa(arg2,'opcroot') && strcmp(class(arg1),class(arg2))
    try
        uddarg1 = getudd(arg1);
        uddarg2 = getudd(arg2);
        iseq = (uddarg1 == uddarg2) & isvalid(arg1) & isvalid(arg2);
    catch
        rethrow(mkerrstruct(lasterror));
    end
end

