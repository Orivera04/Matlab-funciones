function obj = setDescription(obj, sDesc)
%SETDESCRIPTION Provide a description for the optimization function.
%   OPTIONS = SETDESCRIPTION(OPTIONS, DESC) sets the description for the
%   optimization object to be the string DESC.  
%
%   See also CGOPTIMOPTIONS/GETDESCRIPTION.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:54:13 $

if nargin < 2
    error('mbc:cgoptimoptions:InvalidArgument', 'SETDESCRIPTION requires two inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sDesc});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument', msg);
end

obj.description = sDesc;


%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(obj,in)
%----------------------------------------------------------------------

ok = false; msg = '';
if ~ischar(in{1}) 
    msg = 'The description must be a string.';
else
    ok = true;
end