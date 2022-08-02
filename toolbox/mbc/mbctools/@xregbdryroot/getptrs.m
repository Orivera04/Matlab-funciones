function p = getptrs( br )
%GETPTRS   List of internal pointers
%
%  PTRS = GETPTRS(BR)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:13:32 $ 

p = [ getptrs( br.xregbdrynode )  ];
