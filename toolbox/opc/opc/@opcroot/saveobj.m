function obj = saveobj(obj)
%SAVEOBJ Save filter for OPC Toolbox objects.
%
%    B = SAVEOBJ(OBJ) is called by SAVE when an object is
%    saved to a .MAT file. The return value B is subsequently used by
%    SAVE to populate the .MAT file.  
%
%    SAVEOBJ will be separately invoked for each object to be saved.
% 
%    See also OPC/PRIVATE/SAVE.
%

%    Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
%    $Revision: 1.1.6.1 $  $Date: 2004/03/24 20:43:43 $

udelement = struct('props', [], 'udid', [], 'parent',[]);
udelement(1)=[];    % Make a skeleton struct
udlist = struct('opcda',udelement, 'dagroup',udelement, 'daitem',udelement);
% Recursively convert UDD objects to MATLAB OOPS structures.
[obj, udlist] = convertud(obj, udlist);
obj.udlist = udlist;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obj, udList] = convertud(obj, udList)
%CONVERTUD Prepare objects for saving

% Get UDD from OOPS
udH = getudd(obj);
invalidFound = false;
obj.udrefid = cell(1,length(udH));
for k = 1:length(udH)
    thisUDD = udH(k);
    if strcmp(class(thisUDD), 'handle'),
        invalidFound = true;
        obj.udrefid{k}=thisUDD;
    else
        % It's a valid object. Should we store it?
        udid = thisUDD.udid;
        udtype = thisUDD.Type;
        foundID = false;
        l = 1;
        numOfType = length(udList.(udtype));
        while (~foundID) && l<=numOfType
            foundID = (udList.(udtype)(l).udid == udid);
            l = l + 1;
        end
        if ~foundID,
            % UDID not found. Add to the list
            % Store this one's signature, without props at first.
            udList.(udtype)(end+1) = struct('props', [], 'udid', udid, ...
                'parent', []);
            myInd = length(udList.(udtype));
            % Get the parent if we need to. CAUTION: It's an OBJECT!
            if any(strncmp(udtype, {'dagroup', 'daitem'}, length(udtype)))
                % We need the parent property specially spearated!
                [parent, udList] = convertud(thisUDD.Parent, udList);
                udList.(udtype)(myInd).parent = parent;
            end
            % Store the properties, converting and adding as we go.
            pvPairs = get(thisUDD);
            % Which properties should we be checking?
            propNames = fieldnames(pvPairs);
            % Now call a check function to root through the property values for
            % an OPC Toolbox object, and call convertud on that if found
            for pInd = 1:length(propNames)
                thisVal = pvPairs.(propNames{pInd});
                if isa(thisVal, 'opcroot') || ...
                        isa(thisVal, 'struct') || ...
                        isa(thisVal, 'cell'),
                    % Could contain an OPC Toolbox object
                    [thisVal, udList] = checkvalue(thisVal, udList);
                    % Store the possibly modified value back here
                    pvPairs.(propNames{pInd}) = thisVal;
                end
            end
            % We're done, put our PVPairs back in the udList, with all the
            % UDD objects replaced by their references.
            % Remove the Read-Only Always stuff, since we cannot set them!
            for pInd = 1:length(propNames)
                pInfo = propinfo(thisUDD, propNames{pInd});
                if strcmp(pInfo.ReadOnly, 'always') 
                    % Remove this property
                    pvPairs = rmfield(pvPairs, propNames{pInd});
                end
            end
            udList.(udtype)(myInd).props = pvPairs;
        end
        % Now store the UDD ID in the OOPS object.
        obj.udrefid{k}=udid;
    end
end
if invalidFound,
    warning('opc:saveobj:objinvalid', ...
        ...'Invalid objects found. Loaded objects will be recreated without the invalid objects.');
        'Invalid objects found.');
end
% Remove the UDD handles, otherwise MATLAB tries to save me AGAIN!
obj.uddobject = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [val, udList] = checkvalue(val, udList)
%CHECKVALUE Check a value for an object.

% This recursively checks through cell arrays et al for an OPC Toolbox
% object.
if isa(val, 'opcroot')
    % Definitely an OPC Toolbox object
    [val, udList] = convertud(val, udList);
elseif isa(val, 'cell')
    % Check the elements of the cell array for a struct, cell or OPC
    % Toolbox object
    for c=1:numel(val),
        thisVal = val{c};
        if isa(thisVal, 'opcroot') || ...
                isa(thisVal, 'struct') || ...
                isa(thisVal, 'cell'),
            % Could contain an OPC Toolbox object
            [thisVal, udList] = checkvalue(thisVal, udList);
            val{c} = thisVal;
        end
    end
elseif isa(val, 'struct')
    fn = fieldnames(val);
    % Loop through the elements
    for s = 1:length(val)
        % Check the fields of the struct
        for f=1:length(fn)
            thisVal = val(s).(fn{f});
            if isa(thisVal, 'opcroot') || ...
                    isa(thisVal, 'struct') || ...
                    isa(thisVal, 'cell'),
                % Could contain an OPC Toolbox object
                [thisVal, udList] = checkvalue(thisVal, udList);
                val(s).(fn{f}) = thisVal;
            end
        end
    end
end