function o=cgobjectivefunc(varargin)
%CGOBJECTIVEFUNC Constructor for objective function
% 
%  f = CGOBJECTIVEFUNC
%        returns an empty cgobjectivefunc object
%  f = CGOBJECTIVEFUNC(name)
%  f = CGOBJECTIVEFUNC(name, minstr)
%        returns an empty named cgobjectivefunc object
%  f = CGOBJECTIVEFUNC(name, minstr, canswitchminmax)
%        returns an empty named cgobjectivefunc object
%  f = CGOBJECTIVEFUNC(name, minstr, canswitchminmax, modptr)
%        returns a cgobjectiveobject with fields setup

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:18 $


if nargin ==1 & isstruct(varargin{1}) % convert structure to a class
    o = class(varargin{1}, 'cgobjectivefunc');
    return
end    
    

s = struct('name', 'New_ObjectiveFunc', ...
    'minstr','min', ...
    'canswitchminmax', 0, ...
    'modptr', [], ...
    'version', 1);
if isempty(varargin)
    o = class(s, 'cgobjectivefunc');
else
    if ~ischar(varargin{1})
        error('mbc:cgobjectivefunc:InvalidArgument', 'Incorrect argument type for name.');
    end
    s.name = varargin{1};
    
    if nargin >= 2
        if ~ischar(varargin{2})
            error('mbc:cgobjectivefunc:InvalidArgument', 'Incorrect argument type for minstr.');
        end
        s.minstr = varargin{2};
    end
    
    if nargin >= 3
        if ~(varargin{3} == 0 | varargin{3} == 1 )
            error('mbc:cgobjectivefunc:InvalidArgument', 'Incorrect argument type for canswitchminmax.')
        end
        s.canswitchminmax = varargin{3};
    end
    
    if nargin >= 4
        if ~isa(varargin{4}.info, 'cgmodexpr')
            error('mbc:cgobjectivefunc:InvalidArgument', 'Incorrect argument type for modptr.')
        end
        s.modptr = varargin{4};
    end
    
    o = class(s, 'cgobjectivefunc');
end
