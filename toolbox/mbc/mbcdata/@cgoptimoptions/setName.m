function obj = setName(obj, sName)
%SETNAME Provide a name label for an optimization function.
%   OPTIONS = SETNAME(OPTIONS, NAME) sets the name label for the
%   optimization object to be the string NAME. 
%
%   See also CGOPTIMOPTIONS/GETNAME.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:54:16 $

if nargin < 2
    error('mbc:cgoptimoptions:InvalidArgument', 'SETNAME requires two inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sName});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument', msg);
end

obj.name = sName;


%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(obj,in)
%----------------------------------------------------------------------

ok = false; msg = '';

if ~ischar(in{1}) || isempty(in{1})
    msg = 'The optimization name must be a non-empty string.';
else
    ok = true;
end