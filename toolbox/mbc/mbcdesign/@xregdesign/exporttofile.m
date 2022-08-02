function [ok,err]=exporttofile(d,file)
%EXPORTTOFILE  Export design to a file
%
%  EXPORTTOFILE(DES,FILE)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:06:31 $


% check file is written OK
if ~isempty(file)
   try
      des=d;
      save(file,'des');
      ok=1;
      err='';
   catch
      err=['Unable to save to file: ' file];
      ok=0;
   end
else
   err='No filename specified';
   ok=0;
end

