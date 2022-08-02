function out = isfill(T)
%ISFILL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:12:25 $

% Checks to see whether a cglookupone can be filled. For this we need the 
% normaliser to be defined and full.

x = get(T,'x');
if isempty(x)
   out = false;
   return
elseif isempty(get(T,'breakpoints')) | isempty(get(T,'values'))
   out = false;
   return
end
out = true;