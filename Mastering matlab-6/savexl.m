function savexl(arr,filespec)
%SAVEXL Save a matrix to an Excel-format data file.
% SAVEXL(ARR) Save the matrix ARR to an Excel-format file ARR.XLS.
% SAVEXL(ARR,FILESPEC) Save ARR to the Excel-format file FILESPEC(.XLS).

% Get the name of the input variable and set a filename.
if nargin < 1
  error('Missing input argument.');
end
if ischar(arr) & size(arr,1) == 1  % Variable name supplied.
  vname=arr;
  try
    arr=evalin('caller',arr);
  catch
    error(['The variable ',arr,' does not exist.']);
  end
else                               % Variable supplied.
  vname=inputname(1);
end
if isempty(vname) & nargin < 2
  error('No filename specified.');
end
if nargin > 1 
  if isempty(filespec) | ~ischar(filespec)
    error('Invalid filename argument.');
  end
else
  filespec = [vname, '.xls'];
end
[dname,fname,fext]=fileparts(filespec);
if isempty(dname), dname=pwd; end
if isempty(fext), fext='.xls'; end
filespec=fullfile(dname,[fname,fext]);

% Determine the size of the input matrix.
if ndims(arr) > 2
  error('N-dimensional arrays are not supported.');
end
[m,n]=size(arr);

% Start an ActiveX session with MSExcel.
xl=actxserver('Excel.Application');
xl.Visible=1;  % Watch the action...

% Create a workbook and select a worksheet.
wb=invoke(xl.Workbooks,'Add');
sh=xl.Activesheet;

% Select a range of cells of the appropriate size.
r1='A1';
r2=get(sh,'Cells',m,n);
myrange=get(sh,'Range',r1,r2);

% Stuff the array into the range of cells.
set(myrange,'Value',arr);

% Save and close the Workbook.
invoke(wb,'SaveAs',filespec,1);
invoke(wb,'Close');

% Quit Excel and close the ActiveX server connection.
invoke(xl,'Quit');
delete(xl);
return
