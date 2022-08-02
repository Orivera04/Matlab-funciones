function [DDobj, OK, msg] = import(DDobj, filename, force)
% IMPORT  Imports a DataDictionary from an XML file.
%
% [DD, OK, msg] = import(DD)
% [DD, OK, msg] = import(DD, filename)
% [DD, OK, msg] = import(DD, filename, force)
% If no filename is supplied, the user is prompted for one.
% If parameter force is non-zero, the process will run without
% user interaction, and will fail if there are name clashes.
% Otherwise, the user will be prompted for input.
%
% Return value DDobj is the data dictionary itself.
% Return value OK is non-zero if the import completed successfully.
% Return value msg a string describing the problem is the import failed.
%
% This method uses ./private/dd2m.xsl and MATLAB XSLT functionality to import
% XML datadictionary files into Cage.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.10.4.4 $  $Date: 2004/04/04 03:33:17 $


msg = []; OK=1; % initialise return values

% initialise input values if necessary
if nargin<3
    force=0;
    if nargin<2
        filename=[];
    end
end

% Keep a persistent copy of the XSL file.  This speeds up later imports.
persistent XSLFile;
if isempty(XSLFile)
    XSLFile = fullfile(fileparts(mfilename('fullpath')), 'private','dd2m.xsl');
end

% create the EntityResolver, and turn off the messages.
entityResolver = com.mathworks.xml.EntityResolverMW;
entityResolver.setResolverMessages(false);

% create the ErrorHandler - this means that fatal errors in the xml parse
% just throw an Exception rather than putting a message on STDOUT.
errorHandler = com.mathworks.xml.ErrorHandlerMW;

% If we haven't been given a filename.
if isempty(filename)
    % Select data dictionary file using file chooser
    curdir = pwd;
    AP= mbcprefs('mbc');
    FileDefaults = getpref(AP,'PathDefaults');
    if ~isempty(FileDefaults.cagedatafiles) & exist(FileDefaults.cagedatafiles,'dir')
        cd(FileDefaults.cagedatafiles);
    end
    [filename, pathname] = uigetfile({'*.xml', 'MBC Data Dictionary Files (*.xml)'}, 'Select a Data Dictionary');
    cd(curdir);
    if ~ischar(filename)
        msg = []; % the user has cancelled.  not really an error
        return
    end
    dictionaryURL = fullfile(pathname, filename);
else
    dictionaryURL = filename;
    if ~exist(dictionaryURL)
        OK=0; % No message required.  The user clicked "cancel"
        return
    end        
end

% Set default namespaces
if ispc
    entityResolver.setLocalNamespace(['file:///' xregrespath '\namespace']);
else
    entityResolver.setLocalNamespace(xregrespath);
end    
entityResolver.setWorldNamespace('http://www.mathworks.com/namespace');

% do the xslt transform
try
    % read in the xmlfile into a DOM object 
    % setting the '-validating' flag means the DD is checked against the
    % DTD
    dom = xmlread(dictionaryURL, entityResolver, errorHandler, '-validating');

    % lets check this is a datadictionary document;
    doctype = dom.getDoctype.getName;
    if ~strcmp(doctype, 'datadictionary')
        OK = 0;
        return;
    end
    
    % Transform the DOM representation of the XML into m-code, and
    % store the parsed stylesheet in our persistent variable.
    [mcode, XSLFile] = xslt(dom, XSLFile, '-tostring');
    % The XML has been converted into m-code which initialises the members
    % of a structure called importedDD, which we must create first.
    importedDD = struct;
    eval(mcode);    
catch
    OK = 0;
    err = lasterr;
    msg = sprintf('Couldn''t import %s.\n%s', filename, err);
    return;
end

num_constants = length(importedDD.constant);
num_vars = length(importedDD.value);
num_formulae = length(importedDD.symvalue);

entries = [  num2cell(importedDD.constant(:));...
             num2cell(importedDD.value(:));...
             num2cell(importedDD.symvalue(:)) ];
num_entries = length(entries);

% if the XML file was empty we can stop now
if num_entries==0
    OK = 0;
    msg = 'No valid data was found in the file';
    return;
end

pDDobj = address(DDobj); % pointer to the current data dictionary

% extract all new entry names
newvarnames = {};
for j=1:num_entries
    newvarnames = [ newvarnames {entries{j}.name} ];
end

% identify any name clashes
clash_ptrs = null( xregpointer, 0 );
clash_names = {};
applytoall = false;
for i=1:num_entries
    if ~isempty(newvarnames{i})
        existing_ptr = pDDobj.find( newvarnames{i} );
        if ~isempty(existing_ptr)
            if ~force
                if ~applytoall
                    % If we haven't got an 'apply to all' answer - ask
                    % again
                    % This returns string yes, no or cancel
                    [choice, applytoall] = i_overwrite_gui( newvarnames{i} );
                end
                
                switch choice
                    case 'yes'
                        % store the pointer, for deletion later
                        clash_ptrs = [clash_ptrs existing_ptr];
                    case 'no'
                        % remove the entry from the cell array
                        entries{i} = [];
                    otherwise
                        OK = 0; % no message required here
                        return;
                end
            end
            clash_names = [ clash_names newvarnames(i) ];
        end
    end
end

if ~isempty(clash_names) & force
    % no user interaction allowed
    OK=0;
    msg=strvcat( ['The following names occur in both the XML file and ',...
              'the existing variable dictionary:'],...
              clash_names{:});
    return;
end
   
% add constants, variables and functions to the DataDictionary
dup_names = pveceval( clash_ptrs, 'getname' );
for i = 1:num_entries
    if ~isempty(entries{i})
        % find the pointer for this name
        location = clash_ptrs( strmatch( entries{i}.name, dup_names, 'exact' ) ); 
        
        if (i>num_constants+num_vars)
            i_struct2Formula(entries{i}, pDDobj, location);
        elseif (i>num_constants)
            i_struct2Variable(entries{i}, pDDobj, location);
        else
            i_struct2Constant(entries{i}, pDDobj, location);
        end
    end
end

DDobj = pDDobj.info;
return;

%---------------------------------
% converts a struct to a cgconstvalue
function i_struct2Constant(cstruct, pdd, location)
if isempty(cstruct)
    return;
end

const = cgconstvalue;
const = setname(const, cstruct.name);
const = setnomvalue(const, cstruct.val);
const = setdescription(const, cstruct.description);
const = i_addAlias(const, cstruct.alias);

if isempty( location )
    pdd.add(xregpointer(const));
else
    location.info = const;
end

%---------------------------------
% converts a struct to a cgvalue
function i_struct2Variable(vstruct,pdd, location)
if isempty(vstruct)
    return;
end
var = cgvalue(vstruct.name, [vstruct.min, vstruct.max]);
var.info = var.setdescription(vstruct.description);

if ~isempty(vstruct.setpoint)
    var.info = var.setnomvalue(vstruct.setpoint);
end

var.info = i_addAlias(var.info, vstruct.alias);

if isempty( location )
    pdd.add(var);
else
    location.info = var.info;
    freeptr( var )
end

%---------------------------------
% converts a struct to a cgsymvalue
function i_struct2Formula(fstruct, pdd, location)
if isempty(fstruct)
    return;
end
symobj = cgsymvalue(fstruct.name);
symobj = setdescription(symobj, fstruct.description);
symobj = i_addAlias(symobj, fstruct.alias);
symobj = setequation(symobj, fstruct.definition, pdd);
symobj = setrange(symobj, [fstruct.min, fstruct.max]);

if isempty( location )
    pdd.add(xregpointer(symobj));
else
    location.info = symobj;
end

%----------------------------------------
function item = i_addAlias(item, alias, location)
for n = 1:length(alias)
    % remove any leading spaces from alias string
    str = xregdeblank(alias{n});
    str = xregdeblank(fliplr(str));
    str = fliplr(str);
    item = addalias(item, str);
end

% -------------------------------------------------
function [choice, applytoall] = i_overwrite_gui( name )

question = strvcat( ['An entry named ''' name ''' already exists.'],...
    'Do you want to replace it?' );

d = xregdialog(...
    'name', 'Import Variable Dictionary',...
    'tag', 'cancel',...
    'resize', 'off',...
    'Position', [10 10 350 100]);

xregcenterfigure( d );

text = uicontrol(...
    'Parent', d,...
    'style', 'text',...
    'string', question,...
    'horizontalalignment', 'left');

applytoall = uicontrol(...
    'parent', d,...
    'style', 'checkbox',...
    'string', 'Apply to all');

yes    = i_makeButton( d, 'Yes' );
no     = i_makeButton( d, 'No' );
cancel = i_makeButton( d, 'Cancel' );

buttons = xreggridlayout( d,...
    'dimension', [1, 5],...
    'elements',{applytoall, [], yes, no, cancel},...
    'correctalg', 'on',...
    'colsizes', [100, -1, 50, 50, 50],...
    'gapx', 5,...
    'rowsizes', [25]);

main = xregborderlayout(d,...
    'center', text,...
    'south', buttons,...
    'innerborder', [10 40 10 10],...
    'packstatus', 'on');

set(d, 'LayoutManager', main);
d.showDialog(no);

applytoall = logical( get( applytoall, 'value' ) );
choice = get( d, 'tag' );
delete(d);

% ---------------------------------
function i_close(src, evt)

fig = get( src, 'Parent' );
tag = get( src, 'tag' );
set( fig, 'Visible', 'off', 'tag', tag );


% ---------------------------------
function b = i_makeButton( parent, str )

b = uicontrol(...
    'Parent', parent,...
    'style', 'pushbutton',...
    'tag', lower(str),...
    'callback', @i_close,...
    'string', str);



