function out= comments(m,NewComments);
% MODEL/COMMENTS access method for model comments
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:34 $
if nargin==1
   out= m.Comments;
else
   m.Comments= NewComments;
   out= m;
end