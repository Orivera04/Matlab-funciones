function ret = hasinportperaxis(obj)
%HASINPORTPERAXIS Check whether table has a single inport on each axis
%
%  OK = HASINPORTPERAXIS(OBJ) returns true if the table has a single
%  independent inport feeding into each axis of the table.  If the table is
%  not set up with inputs to each axis then this will also cause false to
%  be returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:22 $ 

pInputs = getinputs(obj);
if all(isvalid(pInputs))
    objInputs = info(pInputs);
    if ~iscell(objInputs)
        objInputs = {objInputs};
    end
    for n = 1:length(pInputs)
        ret = hassingleinport(objInputs{n});
        if ~ret
            return
        end
    end
end