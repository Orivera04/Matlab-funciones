function [rnames,cnames] = getrcname(this)
% GETRCNAME Returns input and output names.

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:03 $
rnames = this.Parameters;
cnames = {};