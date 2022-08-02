function    SF = cgfeature(name , varargin);
% Constructor for cgfeature class
%	s=cgfeature
%		returns an empty cgfeature object
%	s=cgfeature(name)
%		returns a cgfeature object
%
%	Restrictions on inputs which must be called with set methods (see methods cgfeature)
%		m      - pointer to cgmodexpr : Reference model
%		eqexpr - pointer to cgexpr    : Expression to be evaluated with respect to model
%		m and e should take the same expressions as inputs
% 
% A cgfeature is an object that contains an cgexpr which houses its
% name, and two pointers to expressions. The first is eqexpr, this is 
% a pointer to an Expression representing the equation associated with
% this cgfeature, and a pointer to a model expression representing the 
% comparison model. It is envisaged that these objects will be created 
% initially with just a name, and to set the two fields subsequent commands
% should be called. This will then allow for a pointer from this object 
% to be sent to the relevant places (i.e. Table SFlists). This cannot be 
% done from the constructor since the pointers to this object won't exist 
% until it is set up.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:10:28 $

% check that simulink is available
persistent gotlicense
if isempty(gotlicense) || ~gotlicense
    % try to get license
    gotlicense = mbcchecklicenses(0);
end

if ~gotlicense
    error('mbc:cgfeature:InvalidState', 'A license could not be obtained for Simulink.');
end

SF = struct('eqexpr',[],...
    'modelexpr',[],...
    'comment','',...
    'history',[],...
    'oppoint',[],...
    'om',[]); % om is a field to store an OptimMgr to govern cgfeature filling

e = cgexpr;

if nargin==0
    SF = class(SF,'cgfeature',e);
    return
elseif nargin==1
    e = setname(e, name);
    SF = class(SF,'cgfeature',e);
else
    error('mbc:cgfeature:InvalidArgument', 'Wrong number of arguments to constructor.')
end
