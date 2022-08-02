function varargout = set( m, property, value )
%SET   Implements the SET method for the XREGLOLIMOT object.
%   SET(M,'<property>','<value>') sets the value of property for the 
%   XREGLOLIMOT model M.
%
%   Properties:
%     BetaModels 
%     Store
%   and those XREGRBF properties that are SET'able.
%
%   See also XREGRBF/SET.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:52 $

error( nargchk( 3, 3, nargin ) );

switch lower( property ),
case 'betamodels',
    m.betamodels = value;
case 'trainingdata',
    m.trainingdata = value;
otherwise,
    try,
        m.xregrbf = set( m.xregrbf, property, value );
    catch,
        error( lasterr );
    end
end

if nargout == 1
    varargout{1} = m;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), m );
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
