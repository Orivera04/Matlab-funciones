function m = xregdynlolimot( delmat )
%XREGDYNLOLIMOT   LOLIMOT for dynamic modeling constructor. Child of XREGLOLIMOT
%   XREGDYNLOLIMOT(DELMAT) is a LOLIMOT model with knoweldge of it dynamic 
%   nature. DELMAT is the dynamic order (first row) and delay (second row) 
%   matrix.
%
%   This class provides a way embedding a static LOLIMOT inside a dyanmic ARX 
%   and providing that model with some knoweledge that it is embedded such.
%
%   See also XREGLOLIMOT, XREGARX.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:47:11 $

if nargin < 1,
    delmat = [ 1, 0; 0, 1];
elseif isa( delmat, 'xregdynlolimot' ),
    m = delmat;
    return
end

nf = sum( delmat(1,:) );
lolimot = xreglolimot( 'NFactors', nf );

m = struct( ...
    'delmat', delmat, ...
    'InitialConditions', zeros( delmat(1,end), 1 ), ...
    'Mode', 'Parallel' );

m = class( m, 'xregdynlolimot', lolimot );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
