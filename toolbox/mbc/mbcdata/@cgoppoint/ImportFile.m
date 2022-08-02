function [op,err, sheetname] = ImportFile(op_in,pname,fname,arg4,arg5)
% p = ImportFile(cgoppoint)
%    create a new operating point set from a file, chosen from uigetfile.
%    Filetypes supported: .xls, .txt, .csv, .mat
%    File should contain a block of data, with or without headings.
%    .xls: data should be in the first sheet of an Excel spreadsheet.
%    .mat: file should contain a single cgoppoint object.
%
% p = ImportFile(cgoppoint,pname,fname)
%    create a new operating point set from the named file.
%
% p = ImportFile(cgoppoint,pname,fname,sheetname)
%    create a new operating point set from a named sheet in an excel spreadsheet.
%
% p = ImportFile(p,...)
%    fill the existing operating point set from the file.
%    If column headings are present in the file, these will be matched with
%      the dataset.  If no headings are present, the number of columns must
%      match the number of: inputs; inputs and outputs; or all factors.
%
% p = ImportFile(p,{factornames})
% p = ImportFile(p,{factornames},pname,fname)
% p = ImportFile(p,{factornames},pname,fname,sheetname)
%    Fill the named factors in order from the file. Column headings are ignored.
%
% pname = 'clipboard' imports from clipboard. Other settings are as above.
%
% [p,err] = ImportFile(...) returns any error messages and does not display them.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.9.4.4 $  $Date: 2004/02/09 06:51:15 $

op = op_in;
err = '';
sheetname = [];
if nargin>1 & iscell(pname)
    fillfactors = pname;
    if nargin==4
        pname = fname;
        fname = arg4;
    elseif nargin==5
        pname = fname;
        fname = arg4;
        sheetname = arg5;
    end
else
    fillfactors = [];
    if nargin==4
        sheetname = arg4;
    end
end

if nargin>1
    if ischar(pname) & strcmp(lower(pname),'clipboard')
        fname = 'clipboard.cbd';
    end
elseif nargin<3
    [fname,pname] = uigetfile('*.txt;*.xls;*.csv;*.mat' , 'Select Data File');
end

if isnumeric(fname) | isnumeric(pname) | isempty(findstr('.',fname))
    err = '';
    return;
end
[pathnotused, fnamenotused, extension] = fileparts( fname );
try
    %Must have different load types for different file extensions.
    switch extension
        case '.cbd'
            [num,heads,units,err] = cg_read_txt( op_in, 'clipboard', [] );
        case '.xls'
            [num,heads,units,err,sheetname] = cg_read_excel( op_in, pname, fname, sheetname );
        case '.txt'
            [num,heads,units,err] = cg_read_txt( op_in, pname, fname );
        case '.csv'
            [num,heads,units,err] = cg_read_txt(op_in, pname, fname, ',' );
        case '.mat'
            % this can either mean a MAT file with double data, or with
            % save datasets
            [OK, type, data, err] = i_readMAT( op_in, pname, fname );        
            if OK && strcmp( type, 'double')
                % create the num, heads and units matrices
                [num, heads, units] = postLoadMatrix( data );
            elseif OK && strcmp( type, 'cgoppoint')
                % In this case the data is the loaded oppoint, we can
                % return now
                op = data;
                return;
            elseif ~OK && isempty( err )
                % user pressed Cancel inside i_ReadMAT
                return;
            end

        otherwise
            err = sprintf( 'File type %s not supported.', extension );
    end
catch
     err = sprintf( 'File: %s does not seem to be of the correct format.\n%s', fname, lasterr);
end

% final check, make sure we have some heads
if isempty( err ) && isempty( heads )
    err = 'Dataset has no factors.';
end

% if we have err defined we'll bail now.
if ~isempty( err )
    if nargout<2
        error( err );
    else
        return;
    end
end

% we must have successfully loaded stuff in
if ~isempty(op_in)
    % if the input datset isn't empty we should fill this one
    [op, err] = fill_existing( op_in, num, heads, fillfactors );
else
    % otherwise create a new dataset
    [op, err] = create_new( num, heads );
end

%------------------------------------------------------------------
function [op, err] = create_new( num, heads )
%------------------------------------------------------------------
% we create a new dataset
newname = [];
err = '';
for i = 1:length(heads)
    if ~ischar(heads{i})
        heads{i} = 'Var';
    elseif length(heads{i})>1
        if heads{i}(1) == '('
            heads{i} = heads{i}(2:end);
        end
        if heads{i}(end) == ')'
            heads{i} = heads{i}(1:end-1);
        end
    end
    newname{i} = uniquename(newname,heads{i});
end
op = cgoppoint(newname,num,'grid_flag',7,'factor_type','output', 'constant',0);


%------------------------------------------------------------------
function [op,err] = fill_existing(op,num,heads,fillfactors)
%------------------------------------------------------------------
err = '';
if nargin<4, fillfactors = []; end

% Remove trailing blanks from the column headers
for j = 1:length(heads)
    heads{j} = deblank(heads{j});
end
factors = lower(get(op,'factors'));
factor_type = get(op,'factor_type');
orig_names = get(op,'orig_name');
op_col = zeros(1,length(factors));

if ~isempty(fillfactors)    %given some factors to fill
    for i = 1:length(fillfactors)
        f = find(strcmp(lower(fillfactors{i}),factors));
        if length(f)==1
            op_col(f) = i;
        else
            f = find(strcmp(lower(fillfactors{i}),orig_names));
            if length(f)==1
                op_col(f) = i;
            else
                err = ['Cannot find ' fillfactors{i} ' in data set'];
            end
        end
    end
    if length(find(op_col))>size(num,2)
        err = 'Too many input names to fill from file';
    end

elseif ~isempty(heads) & ...
        ~(length(heads)>0 & iscell(heads) & strcmp(heads{1},'Var1')) %file contains headings
    for i = 1:length(heads)
        f = find(strcmp(heads{i},factors));
        if length(f)==1
            op_col(f) = i;
        else
            f = find(strcmp(heads{i},orig_names));
            if length(f)==1
                op_col(f) = i;
            end
        end
    end
    if ~any(op_col)
        err = [];
        for i = 1:length(heads)
            err = [err heads{i} ', '];
        end
        err = {'No matching factors found in file.',['File contains headings: ' err(1:end-2) '.']};
    end

else    %no headings - fill in order
    in_i = find(factor_type==1);
    ass_i = find(~get(op,'assign_lock'));
    if size(num,2)==length(ass_i)   %fill factors which are free to be assigned
        % (may be created from file in the first place)
        op_col(ass_i) = 1:length(ass_i);
    elseif size(num,2)==length(in_i)
        op_col(in_i) = 1:length(in_i);  %fill inputs
    else
        err = ['Number of columns in data file must be equal to either the number of columns originally ', ...
            'imported or the number of inputs in the data set'];
    end
end

if isempty(err)
    f = find(op_col);
    assdataind = [];
    if size(op.data, 1) == size(num, 1)
        % Overwrite the data where specified, but keep any other existing
        % data
        data = op.data;
    else
        % Mark any other unassigned data for deletion
        assdataind = find(get(op, 'grid_flag') == 7 & ~isvalid(op.ptrlist));
        assdataind = setdiff(assdataind, f);
        % Any factors not specified by the input data are set to constant
        con = get(op,'constant');
        if length(con)~=length(factors)
            con = zeros(1,length(factors));
        end
        data = repmat(con,size(num,1),1);
    end
    data(:,f) = num(:,op_col(f));
    op.data = data;
    op = set(op,f,'grid_flag',7); %filled from file
    op = set(op, f,'created_flag', 0); %Signify imported data
    gf = get(op, 'grid_flag');
    indsnot = find(gf == 1);
    op = set(op, indsnot, 'grid_flag', 0);
    op = SetRange(op);
    op = SetTolerance(op);
    % Ensure that imported data has the orig_name field filled in
    % This is needed if the user wants to unassign and keep the data
    % in the data set for future use
    allimportednames = op.orig_name;
    emptyinds = find(cellfun('isempty', allimportednames));
    for z = 1:length(emptyinds)
        allimportednames{emptyinds(z)} = '';
    end
    for i = 1:length(f)
        if isempty(op.orig_name{f(i)})
            basename = ['Imported', factors{f(i)}];
            testname = basename;
            count = 0;
            while ~isempty(strmatch(testname, allimportednames, 'exact'))
                count = count + 1;
                testname = [basename, num2str(count)];
            end
            op.orig_name{f(i)} = testname;
        end
    end
    % Delete any unassigned data that is no longer needed
    if ~isempty(assdataind)
        op = removefactor(op,assdataind, 'hold');
    end
end
%------------------------
function name = uniquename(l,name)
%------------------------

for i=1:length(l)
    currentName=l{i};
    if strcmp(name,currentName)
        for j = 0:length(name)-1
            if isempty(str2num((name(end-j))))
                break;
            end
        end
        if j == 0
            num = 1;
        else
            num = str2num(name(end-j+1:end)) + 1;
        end
        name = [name(1:end-j) num2str(num)];
    end
end

%------------------------
function [OK, dataType, loadedVariable, err] = i_readMAT( op_in,pname,fname )
%------------------------

dataType = '';
loadedVariable = [];
err = '';
OK = 0;

fullfilename = fullfile( pname, fname );
fileInfo = whos( '-file', fullfilename );

list = {};
for n = 1:length( fileInfo )
    switch fileInfo(n).class
        case {'double','cgoppoint'}
            list{end+1} = fileInfo(n).name;
    end
end

[choice, OK] = mv_listdlg('ListString', list,...
    'PromptString', 'Select data to import.',...
    'Name', 'Select data to import',...
    'InitialValue',1,...
    'selectionmode','single',...
    'ListSize',[200 240],...
    'fus',10,'ffs',20,...
    'uh',20);

if OK
    % need to load this from the file
    chosenVar = list{choice};
    loadStruct = load( fullfilename,  chosenVar);
    loadedVariable = loadStruct.(chosenVar);
    dataType = fileInfo(choice).class;
end

%-----------------------------------------------
function [num, heads, units] = postLoadMatrix( matrix );
%-----------------------------------------------
units = '';
num = matrix;
heads = cell(1, size(num,2));
for i = 1:size(num,2)
    heads{i} = ['Var' num2str(i)];
end

