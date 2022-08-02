function m = update( m, beta )
%UPDATE   Coefficient update for XREGLOLLIMOT objects.
%   UPDATE(M,BETA) sets coefficients of the overall lolimot object M to those 
%   specififed in BETA and updates all of the betamodels in M as appropriate.
%   UPDATE(M) sets the coefficients of the overall lolimot object M based on 
%   the coefficients of all the betamodels of M.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:55 $


% st = dbstack;
% disp( sprintf( 'XREGLOLIMOT/UPDATE called with %d argument(s) from %s', ...
%     nargin, st(2).name ) );

error( nargchk( 1, 2, nargin ) );

if nargin == 1,
    bm = m.betamodels(:);
    beta = [];
    for i = 1:length( bm ),
        beta = [ beta; double( bm{i} ) ];
    end
    m.xregrbf = update( m.xregrbf, beta );
else
    z = 0;
    bm = m.betamodels(:);
    nb= length(beta)/size(bm{1},1);
    if length(bm)~=nb
       % make sure beta models is the right size
       bm= bm(ones(fix(nb),1));
    end
    for i = 1:length( bm ),
        ell = size( bm{i}, 1  );
        bm{i} = update( bm{i}, beta(z+(1:ell))  );
        z = z + ell;
    end
    m.xregrbf = update( m.xregrbf, beta(1:z) );
    m.betamodels = bm;
end

% % if nargout < 1 & ~isempty( inputname(1) ),
% %     assignin( caller, inputname(1), m );
% % end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
