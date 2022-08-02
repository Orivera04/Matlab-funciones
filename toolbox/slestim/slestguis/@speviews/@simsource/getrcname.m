function [rnames,cnames] = getrcname(this)
% GETRCNAME Returns input and output names.

% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/16 22:21:38 $

rnames = this.OutputPort;
cnames = get(this.Estimation.Experiments,{'Description'});
