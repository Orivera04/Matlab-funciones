function varargout = setrbfpart( m, varargin )
%SETRBFPART   Set properties of the rbf part of a xreginterprbf object
%   SETRBFPART(M,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:55 $ 



m = set( m, 'rbfpart', set( get( m, 'rbfpart' ), varargin{:} ) );

if nargout==1
   varargout{1} = m;
else
   assignin('caller', inputname(1), m);
end

% EOF
