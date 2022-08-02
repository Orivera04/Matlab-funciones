function nm=slblock(obj,sys)
%SLBLOCK  Create a simulink block for constraint
%
%  BLK=SLBLOCK(OBJ,PARENTSYS)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:21 $ 

warning( sprintf( 'No Simulink blocks defined for %s objects', class( obj ) ) );
nm = [];
return
