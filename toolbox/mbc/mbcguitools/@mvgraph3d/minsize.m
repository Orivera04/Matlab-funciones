function sz=minsize(obj)
%MINSIZE   Return minimum size of object
%
%  S=MINSIZE(OBJ) returns a 2 element vector indicating the
%  minimum renderable size of the object OBJ.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:25 $

%graph3d's have a hard-coded minimum

sz=[155, 140];