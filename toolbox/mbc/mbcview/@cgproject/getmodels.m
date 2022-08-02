function pModel = getmodels(PROJ)
%GETMODELS Return pointers to all available model objects in the project
%
%  PMDL = GETMODELS(PROJ) returns a pointer vector containing pointers to
%  all of the shared cgmodexpr's which are available in the project.  This
%  list of models can then be used, for example, to present users with a
%  choice of which model to optimise against.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:28:09 $ 

nodes = children(PROJ);
if ~isempty(nodes)
    % Get all cgmodelnode nodes
    TP = cgtypes.cgmodeltype;
    pModel = TP.filterlist(nodes);
    % Get model expresssions from the model nodes
    pModel = pveceval(pModel, @getdata);
    pModel = [pModel{:}];
else
    pModel = null(xregpointer, 0);
end
