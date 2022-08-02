function value = get( m, property )
%GET   Implements the GET method for the XREGLOLIMOT object.
%   GET(M,'<property>') returns the value of the property for the XREGLOLIMOT 
%   model M.
%   GET(M) returns a list of GET'able properties.
%
%   See also XREGRBF/GET.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:41 $

error( nargchk( 1, 2, nargin ) );

if nargin == 1,
    rv = get( m.xregrbf );
    value = { ...
            'BetaModels', ...
            'TrainingData', ...
            'NumberOfCenters', ...
            rv{:} }.';
    return
end

switch lower( property ),
case 'betamodels',
    value = m.betamodels;
case 'trainingdata',
    value = m.trainingdata;
case 'numberofcenters', 
    value = numel( m.betamodels );
otherwise,
    try,
        value = get( m.xregrbf, property );
    catch,
        error( lasterr );
    end
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
