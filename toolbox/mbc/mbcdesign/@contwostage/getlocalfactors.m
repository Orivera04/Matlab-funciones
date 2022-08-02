function ind = getlocalfactors( con )
%GETLOCALFACTORS List of indices of the global factors in a two-stage constraint
%
%  GETLOCALFACTORS(C) is a list of the indices of the local factors of
%  the two-stage boubndary constraint C.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:39 $ 

nlf = getsize( con.Local ); % number of local factors

ind = 1:nlf;
