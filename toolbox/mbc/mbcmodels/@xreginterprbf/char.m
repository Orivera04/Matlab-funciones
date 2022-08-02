function str = char( m, bg )
%CHAR   Convert XREGINTERPRBF object to character array .
%    CHAR(M) is a string that describes the XREGINTERPRBF object M.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:37 $ 

poly_terms = Terms( get( m, 'linearmodpart' ) );
if isempty( find( poly_terms ) ),
    str = strvcat( 'Interpolating RBF (with no polynomial) that is', ...
        char( get( m, 'rbfpart' ) ) );
else
    str = strvcat( 'Interpolating RBF that is', char(m.xreghybridrbf) );
end

% EOF
