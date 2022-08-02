function value = get( m, parameter )
%GET   Get xreginterprbf object properties
%   GET(M,'<parameter>') returns the value of the parameter for the 
%   xreginterprbf model M..

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:44 $ 


nargchk( 1, 2, nargin );

hybridrbf = m.xreghybridrbf;
rbfpart = get( hybridrbf, 'rbfpart' );
linearmodpart = get( hybridrbf, 'linearmodpart' );

if nargin == 1,
    hv = get( hybridrbf );
    rv = get( rbfpart );
    lv = get( linearmodpart );
    value = unique( { hv{:}, rv{:}, lv{:} }.' );
    
else
    try
        value = get( hybridrbf, parameter );
    catch
        try
            value = get( rbfpart, parameter );
        catch
            try
                value = get( linearmodpart, parameter );
            catch
                error( sprintf( 'Invalid property: ''%s''.', parameter ) );
            end
        end
    end
end

% EOF
