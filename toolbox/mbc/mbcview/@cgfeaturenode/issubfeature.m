function val = issubfeature( nd )
%ISSUBFEATURE Returns true if the featurenode is a subfeature
%
%  VAL = ISSUBFEATURE( FEATURENODE )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:22:54 $ 

% if my parent is a project then I am NOT a subfeature
val = ~isproject( info( Parent( nd ) ) );
