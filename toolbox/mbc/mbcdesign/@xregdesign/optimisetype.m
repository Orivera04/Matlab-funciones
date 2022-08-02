function d=optimisetype(des,str)
% DESIGN/OPTIMISETYPE   Set/retrieve last optimisation type
%
%   TP=OPTIMISETYPE(D) retrieves a string from D indicating what
%   kind of optimisation was last performed .[
%   D=OPTIMISETYPE(D,TP) sets the last optimisation string to TP.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:19 $

% Created 12/11/99


if nargin==1
   d=des.lastoptimisation;
else
   if ischar(str)
      des.lastoptimisation=str;
   end
   if ~nargout
      nm=inputname(1);
      assignin('caller',nm,des);
   else
      d=des;
   end
end
