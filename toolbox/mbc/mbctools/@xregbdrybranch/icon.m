function [image,selim]= icon(bdev,type);
%ICON A short description of the function
%
%  OUT = ICON(IN)
%  
%  See also: xregbdrynode\imlistMBrowser.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:12:51 $ 

if isbest( bdev ),
    image = 3;
    selim = 4;
else
    image = 1;
    selim = 2;
end
