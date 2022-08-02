function fx = str_func( m, TeX )
%XREGARX/STR_FUNC   Formatted function description for XREGARX
%   STR_FUNC(M) is a one line description or title for XREGARX objects.
%   STR_FUNC(M,1) gives the description formated for (La)TeX.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:41 $


staticfx = str_func( m.StaticModel, TeX );
fx = sprintf( 'Dynamic-ARX: %s', staticfx );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
