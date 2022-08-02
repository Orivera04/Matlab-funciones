function s = getsize(this, dim)
% GETSIZE  Inquires about lti source size.
%
%  S = GETSIZE(SRC) returns the 3-entry vector [Ny Nu Nest] where
%    * Ny is the number of outputs
%    * Nu is the number of inputs
%    * Nest is the total number of estimations.
%
%   S = GETSIZE(SRC,DIM) returns the size if the requested dimension
%   (DIM must be 1, 2, or 3).

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/16 22:21:39 $
s = [length(this.OutputPort) length(this.Estimation.Experiment) 1];
if nargin > 1
  s = s(dim);
end
