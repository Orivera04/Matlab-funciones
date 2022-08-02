function n = name( m )
%NAME   Name function for XREGLOLIMOT objects.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:49 $


kn = get( m, 'Kernel' );
kn(1) = upper( kn(1) );
n = sprintf( 'LOLIMOT %s', kn );
if strcmpi( kn, 'wendland' )
	n = sprintf( '%s%1d', n, get( m, 'Cont' ) );
end


%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
