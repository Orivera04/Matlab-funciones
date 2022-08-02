function p=getparams(c);
%GETPARAMS  Return parameters for object
%
%  S=GETPARAMS(C) returns a structure containing the parameters
%  for the constraint object C.  For CONSUMCGMODEL objects the fields
%  are:
%       modptr:  pointer to CAGE model
%       bound:  scalar
%       bound_type: integer
%       weights:  N by 1 column vector
%       oppoint:  pointer to CAGE dataset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:56:11 $


p.modptr = c.modptr;
p.bound = c.bound;
p.bound_type = c.bound_type;
p.weights = c.weights;
p.oppoint = c.oppoint;
