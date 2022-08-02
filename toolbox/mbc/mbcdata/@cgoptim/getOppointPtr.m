function pDS = getOppointPtr(optim,oppoint_name);
% cgoptim/getOppointPtr
% Return a named data set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:16 $

ind = find(strcmp(oppoint_name, optim.oppointLabels));
if isempty(ind)
    error('Invalid Oppoint name');
else
    % return the requested objective
    pDS = optim.oppoints(ind);
end
