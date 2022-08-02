function kernel = getkernelstring( m )
%XREGRBF/GETKERNELSTRING Get string version of kernel 
%  STR = GETKERNELSTRING(M) 
%
%  This function is designed to return the kernel name as required by 
%  MX_RBFEVAL. Mainly, this means appending the continuity parameter if the 
%  kernel is a Wendland one.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

kernel = lower( func2str( m.kernel ) );
if strcmp( 'wendland', kernel ),
    kernel = sprintf( '%s%d', kernel, m.cont );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

