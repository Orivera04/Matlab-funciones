function n= name(bs);
%NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:38:20 $



n= sprintf('FK%d',get(bs.xreg3xspline,'numknots'));