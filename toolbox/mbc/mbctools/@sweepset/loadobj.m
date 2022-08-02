function obj = loadobj(objIn);
% SWEEPSET/LOADOBJ load sweepset object and version control
%
%  Not Required yet

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



% Enter current version number of object
CurrentVersion = 3;

obj = objIn;

% Enter code for updating object in this case statement
switch obj.version
case 1
    obj = i_V1toV2(obj);
    obj = i_V2toV3(obj);
case 2
    obj = i_V2toV3(obj);
case 3
    % This is the current version
otherwise
   warning(sprintf('%s contains an unknown sweep version (%3.1f)',inputname(1),obj.version));
   % Need to return since a call to class on an invalid object would be bad
   return
end

% Might need to recreate the actual object class
if isstruct(obj)
    % Get the parent object
    parent = obj.xregdataset;
    % Remove from the field list
    obj = rmfield(obj, 'xregdataset');
    % Recreate the class
    obj = sweepset('struct', obj, parent);
end


% --------------------------------------------------------------------
% Convert version 1 sweepsets to version 2
% --------------------------------------------------------------------
function obj = i_V1toV2(obj)
obj.version = 2;
% Convert char units to junit if possible
for i = 1:length(obj.var);
    if ischar(obj.var(i).units)
        uc = obj.var(i).units;
        try
            u1 = junit(uc);
            u2 = displayname2junit(uc);
            if length(char(u1))>length(char(u2)) & isvalid(u2)
                u1 = u2;
            end
        catch
            u1 = junit;
        end
        obj.var(i).units = u1;
    else
        obj.var(i).units = junit;
    end
end

% --------------------------------------------------------------------
% Convert version 2 sweepsets to version 3
% --------------------------------------------------------------------
function obj = i_V2toV3(obj)
obj.version = 3;
% Need to add a guidarray to uniquely identify each record
obj.guid = guidarray(obj.nrec);
% Copy the number field into the filename field
obj.filename = obj.number;
