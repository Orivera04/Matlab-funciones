function varargout=set(obj,varargin);
%SET Cgconstraint set method
%
%  OBJ = SET(OBJ, PROP, VAL, ...)
%
%  Parameters
%    CONOBJ   : conxxx
%    FACPTRS  : list of xregpointers
%    EVALTYPE : boolean

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:09:26 $


if nargin == 1
    varargout{1}.conobj  = 'cgconxxx object';
    varargout{1}.facptrs = 'list of xregpointers to input factors to constraint object';
    varargout{1}.evaltype= 'output evalutation type, try logical or dist';
else
    for arg=1:2:length(varargin)
        
        property_name  = varargin{arg};
        property_value = varargin{arg+1};
        
        switch upper(property_name)
            case 'EVALTYPE'
                obj.evaltype = property_value;
            case 'CONOBJ'
                obj.conobj = property_value;
            case 'FACPTRS'
                obj = setinputs(obj, property_value);
            otherwise
                try
                    obj.conobj = setparams(obj.conobj,property_name, property_value);
                catch      
                    error('mbc:cgconstraint:InvalidPropertyName', 'Unknown property name.');
                end
        end
    end
    varargout{1} = obj;
end
