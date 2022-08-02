function d=timestamp(des,opt);
% DESIGN/TIMESTAMP   set/retrieve date stamp from design
%   
%   DT=TIMESTAMP(D) returns the current timestamp from the 
%   design object.
%   D=TIMESTAMP(D,'stamp') stamps the object D with the current
%   time and date.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:53 $



if nargin==1
   % return stamp as a string
   d=datestr(des.timestamp,13);
   if isempty(d)
      d='';
   end
else
   if des.stamping & strcmp(opt,'stamp') 
      % stamp time and date using a date serial number
      des.timestamp=now;
   end
   if des.stamping & ~nargout
      nm=inputname(1);
      assignin('caller',nm,des);
   else
      d=des;
   end
end

   