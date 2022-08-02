function obj = transpose(this)
%TRANSPOSE Implements the transpose operator for OPC Toolbox objects

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/03/24 20:43:46 $

obj = this;
obj.uddobject = this.uddobject';