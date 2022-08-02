function value = get( m, property )
%XREGDYNLOLIMOT/GET   Implements the GET method for the XREGDYNLOLIMOT object.
%   GET(M,'<property>') returns the value of the property for the XREGDYNLOLIMOT 
%   model M. GET(M) returns a cell array of GET'able properties.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:57 $


if nargin < 2,
    value = get( m.xreglolimot );
    value = { 'delmat', 'Mode', 'PersistentOptions', 'InitialConditions', ...
            value{:} }';
else,
    switch lower( property ),
    case 'delmat',
        value = m.delmat;
        
    case 'initialconditions',
        value = m.InitialConditions;
        
    case 'mode',
        value = m.Mode;
        
    case 'persistentoptions',
        value = struct( ...
            'Mode', m.Mode, ...
            'LolimotFitOpt', getFitOpt( m ), ...
            'Kernel', get( m, 'Kernel' ), ...
            'Conitnuity', get( m, 'Cont' ) );
        
    otherwise
        try,
            value = get( m.xreglolimot, property );
        catch,
            error( lasterr );
        end
    end
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
