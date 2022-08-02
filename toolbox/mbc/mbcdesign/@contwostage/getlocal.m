function con = getlocal( con, params )
%GETLOCAL Forms a local constraint from the a two-stage  boundary constraint.
%
%  LC = GETLOCAL(TSC) is the local constraint part of the two-stage
%  constraint TSC.
%  LC = GETLOCAL(TSC,PARAMS) uses PARAMS to form the local constraint
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:38 $ 

if nargin < 2,
    con = con.Local;
else
    con = setparams( con.Local, params );
end
