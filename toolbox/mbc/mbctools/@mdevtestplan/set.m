function varargout=set(T,property,value);
% mdevTESTPLAN/SET depreciating code 
%
% set(T,property,value)
%  Note inputname{1} is used as variable name in caller workspace
%  Therefore subsref expressions cannot be used for m.
%
% Supported properties:
%   'Name'	   Cell array of variable names
%   'Symbol'   Cell array of variable symbols
%   'MeanTol'  Vector of tolerances of the factor means
%   'RangeTol' Vector of tolerances of the factor ranges
%
% See also testplan/meantol, testplan/rangetol

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:08:15 $




switch lower(property)

case 'name'

case 'symbol'

case 'meantol'


case 'rangetol'

otherwise
   error('TESTPLAN/SET invalid property');
end % switch

if nargout==1
   varargout{1}=T;
else
   assignin('caller',inputname(1),T);
end
