function B = subsref(A, S)
%GUIDARRAY/SUBSREF subsreferencing of GUIDARRAY objects
%
% Valid indexing schemes for GUIDARRAY objects
%   B = A(index);          % Returns a GUIDARRAY object using the specified indicies
%   B = A(guidarray);      % Returns the indicies of guidarray in A

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $ 

B = A;
% Switch on the subsref first type
switch S(1).type
    case '()'
        if length(S(1).subs) > 1
            error('mbc:guidarray:InvalidArgument', 'Only one subsref argument allowed');
        end
        % Get the contents of the first bracket
        S1 = S(1).subs{1};
        if isa(S1, 'guidarray')
            B = getIndicesFromArray(A, S1);
        else
            % 1-D colon operator returns same thing
            if strcmp(S1, ':')
                return
            end
            % Index into array
            B.values = A.values(S1);
            % Need to check if S1 is unique - it will usually be a
            % monotonically increasing index. Note short circuit ||
            % operator to avoid sort unless required
            if ~(islogical(S1) || isMonotonic(S1) || isMonotonic(sort(S1)))
                B = makeArrayUnique(B);
            end
            % Update the hash
            B = updateHash(B);
        end
    otherwise
        error('mbc:guidarray:InvalidArgument', 'Invalid indexing scheme');
end



