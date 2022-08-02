function B = subsref(A, S)
%SUBSREF A short description of the function
%
%  OUT = SUBSREF(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:19:22 $ 

B = A;

internalNames = {'xName' 'yNames' 'properties'};
externalNames = {'xname' 'ynames' 'properties'};

for i = 1:numel(S)
    currentS = S(i);
    switch currentS.type
        case '()'
            B.plots = subsref(B.plots, currentS);
        case '.'
            % Which external name was requested
            fieldIndex = strmatch(lower(currentS.subs), externalNames);
            % Was 1 and only 1 requested
            if length(fieldIndex) ~= 1
                error('mbc:xregmonitorplotproperties:InvalidArgument', 'Missing or ambiguous field indexer');
            end
            % Which internal field is being accessed
            field = internalNames{fieldIndex};
            % Need to decide if the output is a cell array
            CELL_OUTPUT = length(B.plots) > 1;
            if CELL_OUTPUT
                B = {B.plots.(field)};
            else
                B = B.plots.(field);
            end
        otherwise
            error('mbc:xregmonitorplotproperties:InvalidArgument', 'Invalid indexing scheme');
    end
end