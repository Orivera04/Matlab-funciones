function S= sweepset(ConstructType,varargin); 
% SWEEPSET Constructor
%
% Calling sytax
%    S= sweepset('Empty',date,comment,'mapnumber')
%    S= sweepset;
%    S= sweepset('Variable', id , format , name ,descript , units , notes ,data' )
%    S= sweepset('struct',S_struct,D_struct)'
%
%    NOTE : the 'struct' constructor is only for use from the
%    sweepset/loadobj function. It is not for general consumption!!!
%    sweepset is a child of xregdataset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



if nargin==0
    % default constructor used by LOAD
    ConstructType= 'empty';
end

if isa(ConstructType,'sweepset');
    % Passed a sweepset - pass it straight back out
    S = ConstructType;
else
    switch lower(ConstructType)
        case 'empty'
            if nargin == 4
                % 3 params passed to constructor
                s = i_CreateEmptyObj(varargin{:});
            else
                % Generate date string internally
                s = i_CreateEmptyObj(datestr(now), '', '');
            end
            % Create an empty xregdataset and call class
            T = xregdataset([], [], []);
            S = class(s, 'sweepset', T);
            
        case 'variable'
            % First create an empty structure
            s = i_CreateEmptyObj(datestr(now), '', '0');
            % Then add the variables
            s = i_CreateVariables(s, varargin{:});
            % Check to see that some data has been added
            if s.nrec > 0
                T = xregdataset(-1, -1, s.nrec);
            else
                T = xregdataset([], [], []);
            end
            S = class(s, 'sweepset', T);
            % Possible that variable names aren't valid so check them all
            S = makeValidNames(S);
        case 'struct'
            s = varargin{1};
            if nargin == 3
                T = varargin{2};
            else
                if s.nrec > 0
                    T = xregdataset(-1, -1, s.nrec);
                else
                    T = xregdataset([], [], []);
                end
            end
            S = class(s, 'sweepset', T);
            % NOTE - Struct creation is only applicable from loadobj and is
            % subject to a post-load check to ensure the variable names are
            % correct (calling makeValidNames on the object)
    end
    % Ensure that all new sweepsets have a guidarray added
    S.guid = guidarray(S.nrec);
end

%-----------------------------------------------------------
% Internal function to create an empty sweepset structure
%-----------------------------------------------------------
function map = i_CreateEmptyObj(datetime,comment,number)
% Note that we hope to change the use of the field number to contain the filenames
% that constitute the sweepset
map.version  = 3;
map.workmap  = 0;
map.nrec     = 0;
map.nvar     = 0;
map.datetime = datetime;
map.comment  = comment;
map.number   = number; 
map.data     = [];
map.baddata  = sparse(0,0);

% New Fields ?
%   engdata  { bor_str , bore , comp_ratio , displacement , num_of_cyls , stroke }
%   contacts { eng , map , cal }
%   year
%   type     { 'STD' , 'GRD2' , 'Old' , 'PDP' , 'AVL PUMA' , 'EEC' }

% Empty var structure
c = cell(1,0);
map.var = struct(...
    'id'       , c,...
    'format'   , c,...
    'name'     , c,...
    'descript' , c,...
    'units'    , c,...
    'type'     , c,...
    'status'   , c,...
    'notes'    , c,...
    'min'      , c,...
    'max'      , c);
% New Fields
%  type    1:7 {'All', 'PCM-Observed' , 'PCM-Control' , ...
%               'DYN-Observed' , 'DYN-Control' , ...
%               'COM-Observed' , 'Calculated' , 'User List(s)' }
%  status  (1,2,3) = {Y,D,N}

% Field for holding the guid array
map.guid     = [];
map.filename = '';

%-----------------------------------------------------------
% Internal function to create variables 
% in a sweepset structure
%-----------------------------------------------------------
function s = i_CreateVariables(s, id, format, name, descript, units, notes, data);

% Check that the names are vaild 
% TODO - this could modify names to be validmlname
if iscell(name)
    for i = 1:length(name)
        name{i} = i_ValidName(name{i});
    end
elseif isstr(name)
    name = i_ValidName(name);
end

if iscell(units)
    for i = 1:length(units)
        units{i} = i_getJunit(units{i});
    end
else
    units = i_getJunit(units);
end

if iscell(descript)
    for i = 1:length(descript)
        descript{i} = deblank(descript{i});
    end	
elseif isstr(descript)
    descript = deblank(descript);
end
if iscell(notes)
    for i = 1:length(notes)
        notes{i} = deblank(notes{i});
    end	
elseif isstr(notes)
    notes = deblank(notes);
end

% Create the variables structure
s.var= [s.var  ... 
        struct(...
        'id'       , id,...
        'format'   , format,...
        'name'     , name,...
        'descript' , descript,...
        'units'    , units,...
        'type'     , 1,...  
        'status'   , 3,...
        'notes'    , notes,...
        'min'      , [],...
        'max'      , []) ];

if nargin < 8
    % Create the variables without any data so fill with zeros
    s.data    = [s.data zeros(s.nrec,length(s.var)-s.nvar)];
    s.baddata = [s.baddata sparse(size(s.data,1),length(s.var)-s.nvar)];
    s.nvar    = length(s.var);
elseif (size(data,2) == length(s.var)-s.nvar) &  ...
        ((s.nvar==0 & s.nrec==0) | (size(data,1) == s.nrec) ) 
    % Create with data so check that all sizes are sensible
    mindat = min(data,[],1);
    if ~isempty(mindat)
        maxdat = max(data,[],1);
        for i= (s.nvar+1):length(s.var)
            s.var(i).min = mindat(i-s.nvar);
            s.var(i).max = maxdat(i-s.nvar);
        end
    end
    s.data    = [s.data data];
    s.baddata = [s.baddata sparse(size(data,1),size(data,2))];
    s.nrec    = size(s.data,1);
    s.nvar    = length(s.var);
else 
    error('Incompitable data and variable sizes') 
end


%-----------------------------------------------------------
%
%-----------------------------------------------------------
function ValidName = i_ValidName(Name)

ValidName = deblank(Name);
% % Make sure name is valid MATLAB name so .varname referencing can be used
% OtherValid= (ValidName>='0' & ValidName<='9') | ValidName=='_';
% 
% ValidName( ~(isletter(ValidName) | OtherValid) ) = '_';
% % Strip off trailing _
% while ~isempty(ValidName) & ValidName(end)=='_';
%     ValidName= ValidName(1:end-1);
% end
% % Strip leading digits and _
% while ~isempty(ValidName) & ~isletter(ValidName(1))
%     ValidName= ValidName(2:end);
% end
% if isempty(ValidName)  
%     ValidName= 'NULL';
% end


%-----------------------------------------------------------
% Internal function to create unique names within
% a sweepset
%-----------------------------------------------------------
function newNames = i_getUniqueNames(uniqueNames, i, j)
% uniqueNames, i and j are the outputs from unique(cellarray of oldNames)
% We construct newNames from oldNames for a starting point
newNames = uniqueNames(j);
% To find the duplicates in oldNames we look for indicies of uniqueNames
% into oldNames that are not in the set i. Note this is all duplicates!!
duplicates = setdiff(1:length(j), i);
% To find the index of the duplicates in uniqueNames we index into j. Note the
% sort allows us to group duplicate names together
[uniqueIndex, k] = sort(j(duplicates));
% Now iterate through setting the new variable names
lastUniqueIndex = 0;
for n = 1:length(k)
    if uniqueIndex(n) ~= lastUniqueIndex
        newFieldTag = 1;
    else
        newFieldTag = newFieldTag + 1;
    end
    % Make sure the new name is unique in the names cell array
    while 1
        uniqueName = [uniqueNames{uniqueIndex(n)} '_' num2str(newFieldTag)];
        if ~ismember(uniqueName, newNames)
            break
        end
        newFieldTag = newFieldTag + 1;
    end
    
    newNames{duplicates(k(n))} = uniqueName;
    lastUniqueIndex = uniqueIndex(n);
end

%-----------------------------------------------------------
%
%-----------------------------------------------------------
function ju = i_getJunit(u)
if isstr(u)
    % If we come in with a string try and parse it
    u = deblank(u);
    ju = junit(u);
elseif isnumeric(u) & isfinite(u)
    % If we have a finite number try and parse the string
    ju = junit(num2str(u));
elseif isa(u, 'junit')
    % If we have a junit then use it
    ju = u;
else
    % Return an empty unit
    ju = junit;
end
