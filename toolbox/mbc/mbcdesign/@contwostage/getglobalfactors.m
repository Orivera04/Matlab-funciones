function ind = getglobalfactors( con )
%GETGLOBALFACTORS List of indices of the global factors in a two-stage constraint
%
%  GETGLOBALFACTORS(C) is a list of the indices of the global factors of
%  the two-stage boubndary constraint C.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:37 $ 

sz = getsize( con );
nlf = getsize( con.Local ); % number of local factors

ind = (nlf+1):sz;
