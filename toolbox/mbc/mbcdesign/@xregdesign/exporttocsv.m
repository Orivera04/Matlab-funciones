function [ok,err]=exporttocsv(d,file,docode,symb)
%EXPORTTOCSV  Export design to a csv file
%
%  EXPORTTOCSV(DES,FILE, DOCODE, ADDSYMB)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:06:30 $


fs=invcode(model(d),factorsettings(d));

if docode
   % code to [-1 1] space
   realm=model(d);
   newm=xregmodel('nfactors',nfactors(realm));
   newm=copymodel(realm,newm);
   fs=code(newm,fs);   
end

% open the file
[fid err]= fopen(file,'wb');
if fid == (-1)
   err=['Unable to open file ' file '.'];
   ok=0;
   return 
end 

try
   if symb
      % write labels to file
      lbls=get(model(d),'symbols');
      fprintf(fid,'%s',lbls{1});
      for n=2:nfactors(d)
         fprintf(fid,',%s',lbls{n});
      end
      fprintf(fid,'\n');
   end
   % build up format string for numeric output
   fmtstr='%f';
   for n=1:(nfactors(d)-1)
      fmtstr=[fmtstr ',%f'];
   end
   % add newline char to format string
   fmtstr=[fmtstr '\n'];
   % output data
   fprintf(fid,fmtstr,fs');
   
   ok=1;
   err='';
catch
   ok=0;
   err=['Error while writing to file ' file '.'];
end
fclose(fid);      
