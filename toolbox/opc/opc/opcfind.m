function varargout = opcfind(varargin)
%OPCFIND Find OPC Toolbox objects with specific properties.
%   Out = OPCFIND returns a cell-array, Out, of all existing OPC Toolbox
%   objects.
%
%   Out = OPCFIND('P1',V1,'P2',V2,...) returns a cell array, Out, of OPC
%   Toolbox objects whose property values match those passed as property
%   name/value pairs, P1, V1, P2, V2, etc. 
%
%	Out = OPCFIND(S) returns a cell array, Out, of OPC Toolbox objects
%	whose property values match those defined in structure S. The field
%	names of S are object property names and the field values of S are the
%	requested property values.    
%
%   Example:
%       obj = opcda('host','server'); 
%       gobj = addgroup(obj,'gname');
%       iobj1 = additem(gobj,'Item.1');
%       iobj2 = additem(gobj,'Item.2');
%       delete(iobj1);
%       out = opcfind('Type','daitem')
%
%   See also ABSTRACTOPC/PROPINFO, OPCDA/DELETE, DAGROUP/DELETE,
%   DAITEM/DELETE, ABSTRACTOPC/GET


% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.5 $  $Date: 2004/03/24 20:43:35 $

% Initialize return arguments.
mobjects = {};
try
    opcmex version;
catch
    rethrow(lasterror);
end

% Locate our package.
opcpck = findpackage('opc');
if isempty(opcpck)
    % No objects exist
    varargout{1} = [];
    return
end

% Find all the objects. 
opcdb = opcpck.DefaultDatabase;
uddobjs = find(opcdb);

% Remove the database handle, if present. It should always be 
% the first element, but check in case this changes.
uddobjs = uddobjs(opcdb~=uddobjs);

if isempty(uddobjs)
    % No objects exist
    varargout{1} = [];
	return
elseif nargin>0
    % find returns children as well so we need "unique" to avoid
    % duplication
    uddobjs = unique(find(uddobjs, varargin{:}));
end

if isempty(uddobjs)
    % No objects exist
    if nargout>0
        varargout{1} = [];
    end
	return
end

% Initialize return arguments.
mobjects = cell(1,length(uddobjs));

% Convert each udd object to a MATLAB object.
for i=1:length(uddobjs),
    mConstructor = get(uddobjs(i), 'Type');
    mobjects{i} =  feval(mConstructor, uddobjs(i));
end

if nargout==0 
    % SPECIAL CASE: We need to show all of these objects, because the
    % alternative is to get a whole host of meaningless 1x1 opc objects in
    % a cell array, and that cannot be pretty printed!
    
    % Write out the header.
	newline = '\n';
	fprintf([blanks(3) 'OPC Objects:\n']);
	fprintf(newline)
	fprintf([blanks(3) 'Index:   Type:          Name:\n']);

    for k=1:length(uddobjs),
       index = sprintf('%d',k);
       typeValue = class(mobjects{k});
       if isa(mobjects{k},'opcda') || isa(mobjects{k},'dagroup')
           nameValue = get(mobjects{k},'name');
       elseif isa(mobjects{k},'daitem')
           nameValue = get(mobjects{k},'itemid');
       end
       fprintf([blanks(3), index, ...
                blanks(9 - length(index)), typeValue, ...
                blanks(15 - length(typeValue)), nameValue, '\n']);
    end
else
    varargout{1} = mobjects;
end


