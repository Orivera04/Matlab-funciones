function pNorm = getnormalizers(PROJ)
%GETNORMALIZERS Return pointers to all available normalizer objects in the project
%
%  PNORM = GETNORMALIZERS(PROJ) returns a pointer vector containing pointers to
%  all of the shared normalizers which are available in the project.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:28:10 $ 

nodes = children(PROJ);
if ~isempty(nodes)
    % Get all cgnormnode nodes
    TP = cgtools.cgnormtype;
    pNorm = TP.filterlist(nodes);
    % Get normalizer expresssions from the normalizer nodes
    pNorm = pveceval(pNorm, @getdata);
    pNorm = [pNorm{:}];
else
    pNorm = null(xregpointer, 0);
end
