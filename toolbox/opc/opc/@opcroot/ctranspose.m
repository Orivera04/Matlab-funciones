function obj = ctranspose(this)
%CTRANSPOSE Implements the ctranspose operator for OPC Toolbox objects

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $  $Date: 2004/02/01 22:06:32 $

obj = this;
obj.uddobject = this.uddobject';