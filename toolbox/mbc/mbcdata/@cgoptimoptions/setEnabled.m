function obj = setEnabled(obj, bEnable)
%SETENABLED Set the enabled status for this optimization function.
%   OPTIONS = SETENABLED(OPTIONS, STATUS) sets the optimization function
%   enabled status.  STATUS must be true or false.  When an optimization is
%   disabled, the user will still be able to register it with CAGE but will
%   not be allowed to create new optimizations using it.
%
%   See also CGOPTIMOPTIONS/GETENABLED.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:54:14 $

if nargin < 2
    error('mbc:cgoptimoptions:InvalidArgument', 'SETENABLED requires two inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {bEnable});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument', msg);
end

obj.enabled = bEnable;



%----------------------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(obj, in)
%----------------------------------------------------------------------------------

ok = 0; msg = '';

if ~islogical(in{1}) || (numel(in{1}) ~= 1)
   msg = 'The enable setting must be true or false.';
else
   ok = 1;
end