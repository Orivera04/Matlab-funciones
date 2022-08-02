function iseq=eq(arg1, arg2)
%EQ Overload of == for image acquisition objects.
%
%    See also IMAQCHILD/NE, IMAQCHILD/ISEQUAL.
%

%    CP 9-02-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:04:49 $

% Error appropriately if one of the input arguments is empty.
if isempty(arg1)
    if (length(arg2) == 1)
        iseq = [];
    else
        errID = 'imaq:eq:dimagree';
        error(errID, imaqgate('privateMsgLookup', errID));            
    end
    return;
elseif isempty(arg2)
    if (length(arg1) == 1)
        iseq = [];
    else
        errID = 'imaq:eq:dimagree';
        error(errID, imaqgate('privateMsgLookup', errID));            
    end
    return;
end

% Determine if both objects are image acquisition objects.
try   
    % Initialize variables.
    uddarg1 = imaqgate('privateGetfield', arg1, 'uddobject');
    uddarg2 = imaqgate('privateGetfield', arg2, 'uddobject');
    
    % Error if both the objects have a length greater than 1 and have
    % different sizes.
    sizeOfArg1 = size(uddarg1); 
    sizeOfArg2 = size(uddarg2); 
    
    if (numel(uddarg1)~=1) && (numel(uddarg2)~=1)
        if ~(all(sizeOfArg1 == sizeOfArg2)) 
            errID = 'imaq:eq:dimagree';
            error(errID, imaqgate('privateMsgLookup', errID));            
        end
    end
    
    iseq = (uddarg1 == uddarg2);
catch
    % Rethrow error from above.
    [msg, id] = lasterr;
    if strcmp(id, 'imaq:eq:dimagree')
        rethrow(lasterror);
    end
    
    % One of the object's is not our object and therefore unequal.
    % Error if both the objects have a length greater than 1 and have
    % different sizes.    
    if (numel(arg1)~=1 && numel(arg2)~=1)
        if (size(arg1,1)~=size(arg2,1) || size(arg1,2)~=size(arg2,2))
            errID = 'imaq:eq:dimagree';
            error(errID, imaqgate('privateMsgLookup', errID));            
        end
    end
    
    % Return a logical zero. 
    if length(arg1) ~= 1
        iseq = zeros(1, length(arg1));
    else
        iseq = zeros(1, length(arg2));
    end
end

iseq = logical(iseq);
