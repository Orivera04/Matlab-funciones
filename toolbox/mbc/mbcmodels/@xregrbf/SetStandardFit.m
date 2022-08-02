function varargout = SetStandardFit( m )
%XREGRBF/SETSTANDARDFIT   Set the fit algorithm to 'rbffit'
%   SETSTANDARDFIT(M) sets the fit algorithm ('fitalg') for the XREGRBF model M 
%   to 'rbffit'. This function can be used when adjustments are made to M after 
%   it has already been fitted. Note that some RBF fitting algorithms set 
%   'fitalg' to 'leastsq' on exit.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:54:16 $


set( m, 'fitalg', 'rbffit' ); 

if nargout == 1
    varargout{1} = m;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), m );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
