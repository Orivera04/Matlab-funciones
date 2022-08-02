function ok=export(nd,dest)
%EXPORT  Export dataset information
%
%  OK=EXPORT(ND,DEST)  where DEST is either 'csv'
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 08:21:45 $

ok=0;
switch dest
case 'csv'
   fopts={'*.csv','Comma Separated Value (csv)'};

end
curdir = pwd;
AP= mbcprefs('mbc');
FileDefaults = getpref(AP,'PathDefaults');
if ~isempty(FileDefaults.cagedatafiles) & exist(FileDefaults.cagedatafiles,'dir')
    cd(FileDefaults.cagedatafiles);
end
[fname,pname] = uiputfile(fopts, 'Save Data set as');
cd(curdir);

if isnumeric(fname) | isnumeric(pname)
   return;
end


[nul,fname,ext]=fileparts(fname);

if isempty(ext)
   ext=['.' dest];
end
% d.Output.FileName = [pname fname];
% pr_SetViewData(d);

FILE=fullfile(pname,[fname ext]);
switch dest
case 'csv'
   fid = fopen(FILE , 'w');
   
   if fid == -1
      h = errordlg(['Error opening ' FILE '. Check read-only status.'] , 'Cage' , 'modal');
      uiwait(h);
      return;
   end
   
   oppt=info(getdata(nd));
   data = get(oppt,'data');
   heads = get(oppt,'factors');
   [rows,cols] = size(data);
   dataIn = get(oppt,'factor_type');
   heads=heads(dataIn~=0);
   data=data(:,dataIn~=0);
   
   fprintf(fid,'%s',heads{1});
   for n=2:cols
      fprintf(fid,',%s',heads{n});
   end
   fprintf(fid,'\n');
   
   % build up format string for numeric output
   fmtstr=repmat('%f,',1,cols);
   % add newline char to format string and remove final comma
   fmtstr=[fmtstr(1:end-1) '\n'];
   
   % output data
   fprintf(fid,fmtstr,data');
   
   fclose(fid);
   ok=1;
end
