function p=getparams(c);
%GETPARAMS  Return parameters for object
%
%  S=GETPARAMS(C) returns a structure containing the parameters
%  for the constraint object C.  For conlinear objects the fields
%  are:
%       modptr:  pointer to CAGE model
%       bound:  scalar
%       bound_type: integer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:09:17 $

p = getparams(c.conobj);

