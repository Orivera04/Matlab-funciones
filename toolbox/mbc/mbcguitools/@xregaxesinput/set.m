function obj = set(obj, varargin)
%% xregaxesinput/SET
%%     set(xregaxesinput, 'Property', Value)
%%     Property = {'POSITION', 'POSITION', 'VISIBLE', 'PARENT'}
%%
%%     Also at this time only one parameter value pair per call
%%     can be used
%%
%%     This form of the set method return a modified form
%%     of the object
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:29:07 $

d = length(varargin)/2;
nparam = floor(d);

for arg=1:2:nparam*2-1
    parameter = varargin{arg};
    value = varargin{arg+1};

    switch upper(parameter)

        case {'NUMCELLS','NUMAXES'}
            if length(value)==1
                set(obj.grid,'dimension',[1,value]);
            end

        case {'POSITION','POS'}
            set(obj.grid,'position',value);
            repack(obj.grid);

        case 'CALLBACK'
            % axesinputs don't have a callback but must implement
            % set(obj, 'callback', cb)

        otherwise
            try
                set(obj.grid, parameter, value);
            catch
                warning('%s is not a valid xregaxesinput/SET property', parameter);
            end
    end %% switch
end
