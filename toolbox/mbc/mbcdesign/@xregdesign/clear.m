function des=clear(des)
%CLEAR Clear design data from design object
%   DG=CLEAR(DG) clears the current design from DG and
%   leaves the field empty.  This will prevent the data
%   from being erroneously used at a later date.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:06:18 $

des.design = zeros(0, des.nfactors);
des.designindex = [];
des.designpointflags = uint8([]);
des.npoints = 0;

des.designstate = des.designstate+1;
des = timestamp(des,'stamp');
