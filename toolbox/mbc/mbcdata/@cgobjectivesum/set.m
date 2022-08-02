function varargout=set(obj,varargin);
% cgobjectivefunc/set overloaded set function for cgobjectivefunc class

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:50:45 $

% Parameters
%   NAME   : char
%   MINSTR : char
%   CANSWITCHMINMAX: 0 or 1 
%   MODPTR : xregpointer to cgmodexpr
%   OPPOINT: xregpointer to a cgoppoint
%   WEIGHTS: vector of doubles

if nargin == 1
    varargout{1}.name   = 'name string eg. torque function';
    varargout{1}.minstr = 'objective-type string eg. min/max/undefined';
    varargout{1}.modptr = 'pointer to a cgmodexpr object';
    varargout{1}.canswitchminmax = '0 or 1';
    varargout{1}.oppoint = 'pointer to a cgoppoint';
    varargout{1}.weights = 'vector of doubles';
else
    for arg=1:2:length(varargin)

        property_name  = varargin{arg};
        property_value = varargin{arg+1};

        switch upper(property_name)
        case 'NAME'
            obj = setname(obj,property_value);
        case 'MINSTR'
            obj.cgobjectivefunc = set(obj.cgobjectivefunc, 'minstr',property_value);
        case 'CANSWITCHMINMAX'
             obj.cgobjectivefunc = set(obj.cgobjectivefunc ,'canswitchminmax',property_value);
        case 'MODPTR'
            obj.cgobjectivefunc = set(obj.cgobjectivefunc, 'modptr',property_value);
        case 'OPPOINT'
            if ~isa(property_value.info, 'cgoppoint') 
                error('Incorrect argument type for oppoint.')
            end
            obj.oppoint= property_value;
            % Set a new oppoint, so must set a new weights vector
            Npts = get(property_value.info, 'numpoints');
            obj.weights = ones(Npts, 1);
        case 'WEIGHTS'
            if ~(size(property_value, 1) == size(obj.oppoint.get('data'), 1))
                error('Incorrect size for weights.')
            end
            obj.weights = property_value;
        otherwise
            error('Unknown property name');
        end
    end
    varargout{1} = obj;
end
