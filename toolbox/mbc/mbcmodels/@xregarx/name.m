function n = name( m )
%XREGARX/NAME   Name function for XREGARX objects.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:00 $

%
n = sprintf( 'ARX %s', name( m.StaticModel ) );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
