function p=transpose(p)
%TRANSPOSE  transpose a pointer array
%
%  Q=TRANSPOSE(P)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:48:20 $

p.ptr=p.ptr';
