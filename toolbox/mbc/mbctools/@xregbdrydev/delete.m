function p = delete( bdev )
%DELETE Delete tree node
%
%  P = DELETE(BDEV) deletes BDEV from the tree.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:12:59 $ 

removebest( info( Parent( bdev ) ), bdev );
p = delete( bdev.xregbdrynode );
