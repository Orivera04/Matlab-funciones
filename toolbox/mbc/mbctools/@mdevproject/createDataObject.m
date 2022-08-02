function [MP, pSSF] = createDataObject(MP)
%CREATEDATAOBJECT Create a new data object and add it to the project list
%
%  pSSF = CREATEDATAOBJECT(MP)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:03:22 $ 

% Create a sweepsetfilter object
ssf = create(sweepsetfilter);
% Give it the default name
ssf = set(ssf, 'label', 'Data Object');
% Assign it a place on the heap
pSSF = xregpointer(ssf);
% And add the new pointer to the project
MP = addData(MP, pSSF);
