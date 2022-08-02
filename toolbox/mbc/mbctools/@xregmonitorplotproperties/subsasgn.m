function [B] = subsasgn(A, S, data)
%SUBSASGN A short description of the function
%
%  OUT = SUBSASGN(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:19:21 $ 

currentS = S(1);
B = A;
internalNames = {'xName' 'yNames' 'properties'};
externalNames = {'xname' 'ynames' 'properties'};

switch currentS.type
    case '()'
        % Do we need to cascade the data generation
        if length(S) > 1
            % Which object is being changed
            A.plots = subsref(A.plots, currentS);
            % Cascade data generation
            data = subsasgn(A, S(2:end), data);
        end
        % Check that data is of the correct form
        if ~isa(data, 'xregmonitorplotproperties')
            error('mbc:xregmonitorplotproperties:InvalidArgument', 'Must assign a xregmonitorplotproperties object');
        end
        % Do the subsasgn
        B.plots = subsasgn(B.plots, currentS, data.plots);
    case '.'        
        % Which external name was requested
        fieldIndex = strmatch(lower(currentS.subs), externalNames);
        % Was 1 and only 1 requested
        if length(fieldIndex) ~= 1
            error('mbc:xregmonitorplotproperties:InvalidArgument', 'Missing or ambiguous field indexer');
        end
        % Which internal field is being accessed
        field = internalNames{fieldIndex};
        % Check the validity of the assignment
        switch fieldIndex
            case 1
                data = i_setXName(data);
            case 2
                data = i_setYNames(data);
            case 3
                data = i_setProperties(data);
        end
        % Do the subsasgn
        B.plots.(field) = data;
    otherwise
        error('mbc:xregmonitorplotproperties:InvalidArgument', 'Invalid indexing scheme');
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function data = i_setXName(data)

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function data = i_setYNames(data)
% Ensure that the yNames are help in a cell array
if ischar(data)
    data = {data};
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function data = i_setProperties(data)