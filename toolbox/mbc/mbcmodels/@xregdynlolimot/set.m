function varargout = set( m, property, value )
%XREGDYNLOLIMOT/SET   Implements the SET method for the XREGDYNLOLIMOT object.
%   SET(M,'<property>','<value>') sets the value of property for the 
%   XREGDYNLOLIMOT model M.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:47:09 $


switch lower( property ),
case 'mode',
    if ismember( lower( value ), { 'parallel', 'series-parallel' } ),
        m.Mode = value;
    else
        error( 'Mode must be either ''Parallel'' or ''Series-Parallel''' );
    end
        
    case 'initialconditions',
        md = max( sum( m.delmat, 1 ) ) - 1;
        if numel( value ) == md,
            m.InitialConditions = value(:);
        else,
            error( 'Wrong number of initial condtions' );
        end
    
case 'persistentoptions',
    if isfield( value, 'Mode' ),
        m.Mode = value.Mode;
    end
    if isfield( value, 'LolimotFitOpt' ),
        m = setFitOpt( m, value.LolimotFitOpt );
    end
    if isfield( value, 'Kernel' ),
        m = set( m, 'Kernel', value.Kernel );
    end
    if isfield( value, 'Conitnuity' ),
        m = set( m, 'Cont', value.Conitnuity );
    end
    
otherwise,
    m.xreglolimot = set( m.xreglolimot, property, value );
    
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
