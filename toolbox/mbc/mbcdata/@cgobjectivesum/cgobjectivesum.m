function o=cgobjectivesum(varargin)
% Constructor for objective sum 
% 
%    f=cgobjectivesum
%          returns an empty cgobjectivefunc object
%    f=cgobjectivesum(name)
%    f=cgobjectivesum(name, minstr)
%          returns an empty named cgobjectivesum object
%    f=cgobjectivefunc(name, minstr, canswitchminmax)
%          returns an empty named cgobjectivesum object
%    f=cgobjectivefunc(name, minstr, canswitchminmax, modptr, oppoint, weights)
%          returns a cgobjectivesum with fields setup

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:50:36 $

if nargin && isstruct(varargin{1})
    OF = varargin{1}.cgobjectivefunc;
    s = rmfield(OF, 'cgobjectivefunc');
else
    args_for_parent = min(nargin, 4);
    OF = cgobjectivefunc(varargin{1:args_for_parent});
    s = struct('oppoint', [], 'weights', []);
    
    if nargin >= 5
        if ~isa(varargin{5}.info, 'cgoppoint')
            error('cgobjectivesum::Incorrect argument type for oppoint.');
        end
        s.oppoint = varargin{5};
    end
    
    if nargin >= 6
        if ~(size(varargin{6}, 1) == size(get(s.oppoint.info, 'data'), 1))
            error('cgobjectivesum::Incorrect size for weights.')
        end
        s.weights = varargin{6};
    end
end
o = class(s, 'cgobjectivesum', OF);