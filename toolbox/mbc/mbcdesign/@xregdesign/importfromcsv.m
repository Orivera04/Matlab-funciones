function [d,ok,err]=importfromcsv(d,file,docode)
%IMPORTFROMCSV  Import design from a csv file
%
%  [D,OK,ERR]=IMPORTFROMCSV(DES,FILE)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:06:58 $


fid=fopen(file);
if fid==-1
   ok=0;
   err=['Unable to open file ' file];
   return
end

try
   s=fscanf(fid,'%f,',[1,1]);
   if isempty(s)
      % assume a first row of labels
      skiprow=1;
   else
      skiprow=0;
   end
   fclose(fid);
catch
   ok=0;
   err=['Unable to read from file ' file];
   return
end

try
   fs=csvread(file,skiprow,0);
catch
   ok=0;
   err=['Unable to read from file ' file];
   return
end

realm=model(d);
if docode
   % invcode from [-1 1] space
   newm=xregmodel('nfactors',nfactors(realm));
   newm=copymodel(realm,newm);
   fs=invcode(newm,fs);
end   

% code back to target range for the design object
fs=code(realm,fs);
% put into design object
d=reinit(d,fs,'defined');
ok=1;
err='';