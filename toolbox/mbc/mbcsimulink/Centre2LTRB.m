function LTRB = Centre2LTRB(centre,width,height)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:02:34 $
LTRB(1) = ceil(centre(1) - width/2);
LTRB(2) = ceil(centre(2) - height/2);
LTRB(3) = LTRB(1) + width;
LTRB(4) = LTRB(2) + height;