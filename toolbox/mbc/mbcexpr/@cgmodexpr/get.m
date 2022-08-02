function out = get(mod , property)
%GET  cgmodexpr get method.
%
%  Gets the properties of the cgmodexpr object.
%
%  Usage: get(mod_obj , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:03 $

if nargin == 1
    out.ptrlist = 'List of xregpointers in ModExpr';
    out.modelname = 'Name of model in ModExpr';
    out.model = 'Model contained in the ModExpr';
    out.inputnames = 'Cell array of names of model inputs';
    out.valptrlist = 'A list of xregpointers to values feeding into this expression';
    out.type = 'Description string for GUI';
    out.clips = 'Lower and Upper clip values';
    return
elseif nargin ~=2
    error('mbc:cgmodexpr:InvalidArgument', 'Insufficient arguments.');
end

if ~ischar(property)
    error('mbc:cgmodexpr:InvalidArgument', 'Property name must be a string');
end

switch lower(property)
   case 'ptrlist'
        out = getinputs(mod);
        
    case 'valptrlist'
        out = getinports(mod);
        
    case 'model'
        out = mod.model;
        
    case 'modelname'
        if isempty(mod.model)
            out = '';
        else
            out = getname(mod.model);
        end
        
    case 'inputnames'
        inp = getinputs(mod);
        if isempty(inp)
            out = '';
        else
            out = cell(1, length(inp));
            for n = 1:length(inp)
                if isvalid(inp(n))
                    out{n} = getname(inp(n).info);
                else
                    out{n}='';
                end
            end
        end
        
    case 'type'
        if ~isempty(mod.model)
            try
                out = type(mod.model);
            catch
                out = 'Model';
            end
        else
            out = 'Model';
        end
            
    case 'clips'
        out = mod.clips;
        
    otherwise
        error('mbc:cgmodexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']);
end
