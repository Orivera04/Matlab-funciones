function [dout,ok,err]=importfromfile(d,file)
%IMPORTFROMFILE  Import design from a file
%
%  [D,OK,ERR]=IMPORTFROMFILE(DES,FILE)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:06:59 $


try
   data=load(file,'-mat');
catch
   ok=0;
   err=['Unable to open file ' file];
   dout=d;
   return
end

nf=nfactors(d);
if isfield(data,'des') & nfactors(data.des)==nf
   dout=data.des;
   ok=1;
   err='';
else
   % look for first design...
   fnms=fieldnames(data);
   for n=1:length(fnms)
      des=data.(fnms{n});
      if isa(des,'xregdesign') & nfactors(des)==nf
         break
      else
         des=[];
      end
   end
   if isempty(des)
      ok=0;
      err=['File ' file ' does not contain any valid design objects with the correct number of factors.'];
      dout=d;
   else
      ok=1;
      err='';
      dout=des;
   end
end

if ok
   % update model in d
   m=model(dout);
   oldm=model(d);
   m=copymodel(oldm,m);
   dout=model(dout,m);   
end