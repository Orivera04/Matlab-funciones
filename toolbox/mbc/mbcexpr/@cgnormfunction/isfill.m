function out = isfill(T)
%ISFILL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:14:55 $

% Checks to see whether a cgnormfunction can be filled. For this we need the 
% normaliser to be defined and full.

x = get(T,'x');
if isempty(x)
   out = false;
   return
elseif isempty(x.get('breakpoints')) | isempty(x.get('values'))
   out = false;
   return
end
out = true;