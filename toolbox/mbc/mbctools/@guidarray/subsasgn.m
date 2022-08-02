function B = subsasgn(A, S, data)
%GUIDARRAY/SUBSASGN subsasigning of GUIDARRAY objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.8.2 $ 

B = A;

% Check type of data
if ~isempty(data) && ~isa(data, 'guidarray')
    error('mbc:guidarray:InvalidArgument', 'Only guidarrays may be assigned to guidarrays');
end

% Switch on the subsref first type
switch S(1).type
    case '()'
        if length(S(1).subs) > 1
            error('mbc:guidarray:InvalidArgument', 'Only one subsasgn argument allowed');
        end
        % Get the contents of the first bracket
        S1 = S(1).subs{1};
        if isempty(data)
            B.values(S1) = [];
        else
            % Index into array
            B.values(S1) = data.values;
            % Ensure uniqueness
            % TODO - this could use the same merging algoritum as vertcat to
            % ensure uniquness
            B = makeArrayUnique(B);
        end
        % Update the hash
        B = updateHash(B);
    otherwise
        error('mbc:guidarray:InvalidArgument', 'Invalid assignment scheme');
end