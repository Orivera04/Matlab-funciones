function str=char(des)
% CHAR  Create a string representation of a design
%
%   STR=CHAR(D) returns a string  containing the name of the 
%   design, or the string 'M by N design' if the name field is
%   empty.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:15 $

% Created 3/2/2000


str=name(des);

if isempty(str)
   sz=size(des);
   str=['[' sprintf('%d',sz(1)) ' by ' sprintf('%d',sz(2)) '] design'];
end
return
