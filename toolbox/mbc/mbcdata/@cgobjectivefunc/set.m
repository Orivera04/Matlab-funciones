function varargout=set(obj,varargin);
% cgobjectivefunc/set overloaded set function for cgobjectivefunc class

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:30 $

% Parameters
%   NAME   : char
%   MINSTR : char
%   MODPTR : xregpointer to cgmodexpr

if nargin == 1
    varargout{1}.name   = 'name string eg. torque function';
    varargout{1}.minstr = 'objective-type string eg. min/max/undefined';
    varargout{1}.canswitchminmax = '0 or 1';
    varargout{1}.modptr = 'pointer to a cgmodexpr object';
else
    for arg=1:2:length(varargin)

        property_name  = varargin{arg};
        property_value = varargin{arg+1};

        switch upper(property_name)
         case 'NAME'
          obj = setname(obj,property_value);
         case 'MINSTR'
          obj.minstr = property_value;
         case 'CANSWITCHMINMAX'
          obj.canswitchminmax = property_value;
         case 'MODPTR'
          obj.modptr = property_value;
         otherwise
          error('Unknown property name');
        end
    end
    varargout{1} = obj;
end
