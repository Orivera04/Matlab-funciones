function f=cgfuncmodel(str,name,i,symbols,u,ranges,constraints)
%CGFUNCMODEL Constructor for the cgfuncmodel class
% f=cgfuncmodel
%	returns an empty cgfuncmodel
% f=cgfuncmodel(str)
% f=cgfuncmodel(str,name,i,symbols,units,ranges,constraints)
%   symbols are set automatically from the function string
%   str may be replaced by a funcmod to perform conversion from old objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.3 $  $Date: 2004/02/09 06:49:49 $

f = struct('func', [], ...
    'funcv', [], ...
    'compiled', 0);
m = xregexportmodel;
f = class(f , 'cgfuncmodel' , m);

if nargin > 0
    % Checking required for input variables
    if ischar(str)
        [f, ok, msg]  = setfunction(f, str);
         if ~ok
             error('mbc:cgfuncmodel:InvalidFunction', msg);
         end
    else
        if isa(str,'funcmod')
            [f, ok, msg] = setfunction(f, get(str,'function'));
            if ~ok
                error('mbc:cgfuncmodel:InvalidFunction', msg);
            end
        else
            error('mbc:cgfuncmodel:InvalidArgument',  'First input must be a string the describes the function.');
        end
    end
    n = nfactors(f);
    if nargin > 1
        f = setname(f,name);
        if nargin > 2
            f = setinfo(f,i);
            if nargin > 3
                if length(f) == n
                    f = setsymbols(f,symbols);
                end
                if nargin > 4
                    u = reshape(u,length(u),1);
                    if length(u) == n+1
                        f = setunits(f,u);
                    elseif length(u) == n
                        f = setunits(f,[{''};u]);
                    end
                    if nargin > 5
                        if size(ranges,2) == n
                            f = setranges(f,ranges);
                        end
                        if nargin > 6
                            f = setconstraints(f,constraints);
                        end
                    end
                end
            end
        end
    else
        name = 'function';
        f = setname(f,name);
        ranges = repmat([-1;1],1,n);
        f = setranges(f,ranges);
    end
end




