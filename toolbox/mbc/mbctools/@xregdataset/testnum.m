function S=testnum(T,varargin);
% DATASET/TESTNUM
% If called with a single argument, i.e.:
%
% S=TESTNUM(T)
%
% Where T is a DATASET object, S will be the 
% Test Numbers of the DATASET object.
%
% If called with 2 arguments, i.e.:
%
% T = TESTNUM(T,xxx)
%
% Where xxx is a numerical value, the function
% will assign the value xxx to be Test Number 
% of the the DATASET object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:19:07 $

% NOT up to Version 2 standard yet.
% Supports new cell array structure but only refers to lowest level.

if nargin==1
   S= T.testnum{1};
elseif nargin>1 & isnumeric(varargin{1})
   if length([varargin{:}])==size(T,3)
      T.testnum{1}=getUniqueTestnum([varargin{:}]);
      S=T;
   end
end
