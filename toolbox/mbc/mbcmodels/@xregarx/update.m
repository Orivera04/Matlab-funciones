function m = update( m, beta )
%XREGARX/UPDATE   Coefficient update for dynamic ARX objects.
%   UPDATE(M,BETA) sets parameters (coefficients) of the dyanmic ARX model M to 
%   those specififed in BETA.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:44 $


error( nargchk( 2, 2, nargin ) );

sm = get( m, 'StaticModel' );
sm = update( sm, beta );
m = set( m, 'StaticModel', sm );

% if nargout < 1 & ~isempty( inputname(1) ),
%     assignin( caller, inputname(1), m );
% end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
