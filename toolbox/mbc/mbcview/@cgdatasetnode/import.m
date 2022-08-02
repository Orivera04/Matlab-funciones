function [ok,op]=import(nd)
%IMPORT  Import data from file
%
%  [OK,OP]=IMPORT(ND)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.7.2.4 $  $Date: 2004/02/09 08:21:50 $


ok=0;
op=[];
oppt=getdata(nd);


if ~oppt.isempty
    but = questdlg({'Current data set is not empty.',...
            'Fill from file, overwrite or cancel?'},...
        'Data Set Viewer','Fill','Overwrite','Cancel','Fill');
    switch but
    case 'Cancel'
        return
    end
else
    but = 'Overwrite';
end

curdir = pwd;
AP= mbcprefs('mbc');
FileDefaults = getpref(AP,'PathDefaults');
if ~isempty(FileDefaults.cagedatafiles) & exist(FileDefaults.cagedatafiles,'dir')
    cd(FileDefaults.cagedatafiles);
end
[fname,pname] = uigetfile({'*.csv;*.txt','Text File (*.csv, *.txt)';...
        '*.xls','Excel File (*.xls)';...
        '*.mat','MATLAB File (*.mat)'}, 'Select Data File');
cd(curdir)

if isnumeric(fname) | isnumeric(pname)
    return;
end


switch but
case 'Overwrite'
    [op,mess,sheetname] = ImportFile(cgoppoint,pname,fname);
case 'Fill'
    [op,mess,sheetname] = ImportFile(oppt.info,pname,fname);
end

if isempty( op )
    ok = 0;
    return;
end

if ~isempty(mess)
    h = errordlg(mess, 'Importing Data');
elseif strmatch(but, 'Overwrite', 'exact')
    CGP = project(nd);
    thisfname = fname(1:end-4);
    if ~isempty(sheetname)
        FNAMELEN= length(thisfname);
        if FNAMELEN > namelengthmax-9
            % Reserve eight characters for the sheetname in exceptional
            % cases where the filename length is large
            thisfname = thisfname(1:namelengthmax-9);
        end
        filenameaddon = ['_', sheetname];
    else
        filenameaddon = [];
    end
    newopname = uniquename(CGP, [thisfname, filenameaddon]);
    op= setname(op, newopname);
    ok=1;
elseif strmatch(but, 'Fill', 'exact')
    ok =2;
else
    % Shouldn't get here
end
