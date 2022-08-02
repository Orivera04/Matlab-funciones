function obj = loadobj(obj)
%LOADOBJ A short description of the function
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $    $Date: 2004/02/09 07:11:13 $ 

if isstruct(obj)
    % Pre-version 2 object
    % Need to transfer inputs pointers to parent expression
    inputs = null(xregpointer, [1,4]);
    if ~isempty(obj.left)
        inputs(1) = obj.left;
    end
    if ~isempty(obj.right)
        inputs(2) = obj.right;
    end    
    if ~isempty(obj.out1)
        inputs(3) = obj.out1;
    end
    if ~isempty(obj.out2)
        inputs(4) = obj.out2;
    end
    obj.cgexpr = setinputs(obj.cgexpr, inputs);
    obj = rmfield(obj, 'left');
    obj = rmfield(obj, 'right');
    obj = rmfield(obj, 'out1');
    obj = rmfield(obj, 'out2');
    obj.version = 2;
end

if isstruct(obj)
    obj = cgifexpr(obj);
end