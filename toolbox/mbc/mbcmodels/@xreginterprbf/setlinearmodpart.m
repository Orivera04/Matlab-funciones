function m = setlinearmodpart( m, varargin )
%SETLINEARMODPART   Set properties of the linear model part of an object
%   SETLINEARMODPART(M,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:54 $ 



m = set( m, 'linearmodpart', ...
    set( get( m, 'linearmodpart' ), varargin{:} ) );

if nargout==1
   varargout{1} = m;
else
   assignin( 'caller', inputname(1), m );
end

% EOF
