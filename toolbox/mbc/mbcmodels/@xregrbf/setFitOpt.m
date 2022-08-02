function m = setFitOpt(m,Property,Value);
%SETFITOPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:20 $

% SetFitOpt(m,Property,Value)
% m = SetFitOpt(m,Property,Value)
% m = SetFitOpt(m,om)

if nargin == 3
    m.om = set(m.om,Property,Value);
elseif nargin == 2
    m.om = Property;
else
    error('Need two arguments or more');
end    
    
if nargout==1 
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end