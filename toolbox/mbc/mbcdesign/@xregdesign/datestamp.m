function d=datestamp(des,opt);
% DESIGN/DATESTAMP   set/retrieve date stamp from design
%   
%   DT=DATESTAMP(D) returns the current datestamp form the 
%   design object.
%   D=DATESTAMP(D,'stamp') stamps the object D with the current
%   date.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:22 $


if nargin==1
   d=datestr(des.timestamp,1);
   if isempty(d)
      d='';
   end
else
   if des.stamping & strcmp(opt,'stamp')
      % stamp date as a serial number
      des.timestamp=now;
   end
   if des.stamping & ~nargout
      nm=inputname(1);
      assignin('caller',nm,des);
   else
      d=des;
   end
end
