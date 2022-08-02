function [centre,width,height] = LTRB2Centre(LTRB)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:02:36 $
centre(1) = ceil(mean(LTRB(1:2:3)));
centre(2) = ceil(mean(LTRB(2:2:4)));
width = abs(diff(LTRB(1:2:3)));
height = abs(diff(LTRB(2:2:4)));