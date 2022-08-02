function obj = opcroot(uddobjs)
%OPCROOT Constructor for the opc root class.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/03/24 20:43:29 $

if nargin==0
    obj = [];
    return
end

obj = [];
if isstruct(uddobjs)
    reqFields = {'version'; 'uddobject'; 'udlist'; 'udrefid'};
    objFields = fieldnames(uddobjs);
    if ~isempty(setdiff(reqFields, objFields))
        rethrow(mkerrstruct('opc:opcroot:syntaxerror'));
    end
    obj = class(uddobjs, 'opcroot');
else
    % Rules for making opcroot objects:
    %   Since we have to be able to reconstruct an invalid object (for subsref)
    %   we need to be able to add opc.WHATEVER objects as well as invalid
    %   handles.
    thisUDD = [];
    for k=1:length(uddobjs)
        switch class(uddobjs(k))
            case {'opc.opcda', 'opc.dagroup', 'opc.daitem', 'handle'}
                if isempty(thisUDD),
                    thisUDD = uddobjs(k);
                else
                    thisUDD(end+1) = uddobjs(k);
                end
            otherwise
                rethrow(mkerrstruct('opc:opcroot:handleunknown'));
        end
    end
    if ~isempty(thisUDD),
        % Check that they are all the same class or a handle (invalid object)
        %TODO: What do we do about objects that are all deleted?
        thisClass = [];
        for k=1:length(thisUDD),
            if ~strcmp(class(thisUDD(k)), 'handle')
                if isempty(thisClass),
                    thisClass = class(thisUDD(k));
                else
                    if ~strcmp(class(thisUDD(k)),thisClass)
                        rethrow(mkerrstruct('opc:opcroot:classmismatch'));
                    end
                end
            end
            % Create a unique ID if one hasn't already been created.
            if ~isprop(thisUDD(k), 'udid'),
                p = schema.prop(thisUDD(k), 'udid', 'int32');
                thisUDD(k).udid = int32(fix(rand * 2^31));
                p.Visible = 'off';
            end
        end
        % Check that the UDD object is not a matrix
        if length(thisUDD) ~= numel(thisUDD),
            rethrow(mkerrstruct('opc:opcroot:matrixdisallowed'));
        end

        % Now we just create the object!
        objStruct = struct('version', strtok(opcmex('version')), ...
            'uddobject', thisUDD, 'udlist', [], 'udrefid', []);
        % NOTE: The udlist and udid properties are used in SAVE/LOAD.
        %   udrefid stores the UDID for the object (unique ID for UDD object)
        %   udlist stores all info required to reconstruct the UDD objects that
        %       this object depends on.
        obj = class(objStruct, 'opcroot');
    else
        rethrow(mkerrstruct('opc:opcroot:objcreation'));
    end
end
