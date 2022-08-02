function varargout = set(obj, varargin)
%cgcalinput/set
%
%Sets the properties of the cgcalinput object.
%
%Usage: obj = set(obj , 'property_name', value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:23 $

if nargin==1
    fprintf('\n\tfilename: string\n');
    types = getinputfunctions(obj);
    fprintf('\ttype: [ %s ', types{1});
    for n=2:length(types)
        fprintf('| %s', types{n});
    end
    fprintf(']\n\n');
    return
end
    
for n = 1:2:nargin-1
    prop = varargin{n};
    value = varargin{n+1};
    switch lower(prop)
    case 'filename'
        obj.filename = value;
    case 'type'
        types = getinputfunctions(obj);
        if isempty(intersect(types, value))
            error(['cgcalinput\set: Unknown file type : ''' value '''.']);
        end
        obj.inputFcn = value;
    otherwise
        error(['cgcalinput\set: Unknown property : ''' prop '''.']); 
    end
    varargout{1} = obj;
end
