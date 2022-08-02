function nTbls = numTables(obj)
%NUMTABLES Return number of tables in tradeoff
%
%  NTABLES = NUMTABLES(OBJ) returns the number of tables that have been added
%  to the tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:57 $ 

nTbls = length(obj.Tables);
