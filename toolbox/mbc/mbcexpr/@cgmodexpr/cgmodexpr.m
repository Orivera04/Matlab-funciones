function mod = cgmodexpr(varargin)
%CGMODEXPR Constructor for the cgmodexpr class
%
%  M = CGMODEXPR returns an empty cgmodexpr object.
%
%  M = CGMODEXPR(name,xregexportModel,unitsOut,units1,units2,...,unitsN)
%  returns an xregpointer to a cgmodexpr object.
%
%  Only xregexportModel objects are valid as input models - see the
%  xregexportmodel class.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:55 $

if isempty(varargin)
    [e, mod] = i_createdefaults;
    mod = class(mod , 'cgmodexpr' , e);
else
    if isstruct(varargin{1})
        mod = varargin{1};
        e = mod.cgexpr;
        mod = rmfield(mod, 'cgexpr');
        mod = class(mod , 'cgmodexpr' , e);
    else
        [e, mod] = i_createdefaults;
        
        name = varargin{1};
        if ~ischar(name)
            error('mbc:cgmodexpr:InvalidArgument', 'Name must be a string.');
        end
        e = setname(e , name);
        
        model = varargin{2};
        if ~isa(model , 'xregexportmodel')
            error('mbc:cgmodexpr:InvalidArgument', 'Model must be an xregexportmodel.');
        end
        mod.model = model;
        
        %Set up null xregpointers to input expressions.
        e = setinputs(e, null(xregpointer, 1, nfactors(model)));
        
        mod = class(mod , 'cgmodexpr' , e);
    end
end


function [e,m] = i_createdefaults
e = cgexpr;
m = struct('clips', [-inf inf], 'version', 3, 'model', []);
