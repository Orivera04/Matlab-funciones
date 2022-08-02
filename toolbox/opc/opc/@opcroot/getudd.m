function out = getudd(this)
%GETUDD Return UDD handle for OPC objects
%
%   See also OPCROOT/SETUDD

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $  $Date: 2004/02/01 22:06:38 $

out = this.uddobject;
% if size(this,1)>1,
%     out=out';
% end