function obj = setinputs(obj, ptrs, idx)
%SETINPUTS Set input pointers to expression
%
%  OBJ = SETINPUTS(OBJ, PTRS) sets the input pointers to the expression OBJ.
%
%  OBJ = SETINPUTS(OBJ, PTRS, INDEX) sets the inputs at INDEX to be PTRS.
%
%  This method is intended for use by child classes only and should not be
%  used directly.  Instead, investigate the individual get/set methods of
%  child classes for access to their inputs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:09:47 $ 


if isempty(ptrs)
    % Ensure field is a pointer
    obj.Inputs = null(xregpointer,0);
else
    if nargin==2
        obj.Inputs = ptrs;
    elseif nargin==3
        if all(idx<=length(obj.Inputs))
            obj.Inputs(idx) = ptrs;
        else
            error('mbc:cgexpr:InvalidIndex', 'Index out of bounds.');
        end
    end
end