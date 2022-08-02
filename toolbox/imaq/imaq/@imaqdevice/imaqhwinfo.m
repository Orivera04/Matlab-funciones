function result = imaqhwinfo(obj, field)
%IMAQHWINFO Return information on available hardware.
%
%    OUT = IMAQHWINFO returns a structure, OUT, which contains image
%    acquisition hardware information. This information includes the 
%    toolbox version, MATLAB version and installed adaptors.
%
%    OUT = IMAQHWINFO(ADAPTORNAME) returns a structure, OUT, which 
%    contains information related to an adaptor, specified by the 
%    string ADAPTORNAME. This information includes adaptor version 
%    and available hardware for the specified adaptor. 
%
%    OUT = IMAQHWINFO(ADAPTORNAME,'FIELD') returns the adaptor information 
%    for the specified field name, FIELD. FIELD can be a single string or a
%    cell array of strings. If FIELD is a cell array, OUT is a 1-by-N 
%    cell array where N is the length of FIELD.
%
%    OUT = IMAQHWINFO(ADAPTORNAME, DEVICEID) returns information for the
%    device identified by the numerical DEVICEID. DEVICEID can be a scalar or
%    a vector. If DEVICEID is a vector, OUT is a 1-by-N structure array where 
%    N is the length of DEVICEID.
%
%    OUT = IMAQHWINFO(OBJ) where OBJ is a video input object, returns  
%    a structure, OUT, containing information such as adaptor, board 
%    information and hardware configuration limits. If OBJ is an array of 
%    device objects then OUT is a 1-by-N cell array of structures where N is
%    the length of OBJ.
%
%    OUT = IMAQHWINFO(OBJ, 'FIELD') returns the hardware information 
%    for the specified field name, FIELD, to OUT. FIELD can be any of 
%    the field names defined in the IMAQHWINFO(OBJ) structure. FIELD can 
%    be a single string or a cell array of strings. If FIELD is a cell 
%    array, OUT is a 1-by-N cell array where N is the length of FIELD.
%
%    Once IMAQHWINFO is called, hardware information is cached by the
%    toolbox. To force the toolbox to search for new hardware that may have
%    been installed while MATLAB was running, use IMAQRESET.
%
%    Example:
%      out1 = imaqhwinfo
%      out2 = imaqhwinfo('matrox');
%
%      obj = videoinput('winvideo', 1);
%      out3 = imaqhwinfo(obj);
%      out4 = imaqhwinfo(obj, 'AdaptorName');
%
%    See also IMAQRESET, IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:20 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:imaqhwinfo:invalidType';
    error(errID, imaqgate('privateMsgLookup', errID));
elseif ~isvalid(obj)
    errID = 'imaq:imaqhwinfo:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Extract the UDD object handles.
uddobj = imaqgate('privateGetField', obj, 'uddobject');
Nobjects = length(uddobj);

if nargin==1,
    result = cell(1, Nobjects);
    for i=1:Nobjects,
        % Just return the information structure.        
        result{1, i} = imaqhwinfo(uddobj(i));
    end
    
    if Nobjects==1,
        result = result{:};
    end
else
    % Ex. out = imaqhwinfo(obj, 'DeviceName');
    if ~(ischar(field) || iscellstr(field)),
        errID = 'imaq:imaqhwinfo:invalidFieldName';
        error(errID, imaqgate('privateMsgLookup', errID));
    end
    
    % Make the string a cell array.
    isString = false;
    if ischar(field)
        isString = true;
        field = {field};
    end
    
    % Make the cell a 1-by-n array.
    field = {field{:}};    
    nFields = length(field);
    result = cell(Nobjects, nFields);
    for i=1:Nobjects,
        % Get hardware information for OBJ.
        infoStruct = imaqhwinfo(uddobj(i));
        
        % Get the fields.
        for j = 1:nFields
            try
                result{i,j} = infoStruct.(field{j});
            catch
                % Try case insensisitive, property name completion, otherwise error.
                structFields = fieldnames(infoStruct);
                ind = strmatch(lower(field{j}), lower(structFields));
                if isempty(ind),
                    rethrow(lasterror);
                elseif length(ind)>1,
                    % Ambiguous property
                    errID = 'imaq:imaqhwinfo:invalidField';
                    error(errID, [imaqgate('privateMsgLookup',errID) field{j} '.']);
                else
                    % Found a match.
                    result{i,j} = infoStruct.(structFields{ind});                    
                end
            end
        end        
    end
    
    % If the field was given as a string and obj is 1-by-1, output a string.
    if isString && (numel(result) == 1),
        result = result{:};
    end
end

