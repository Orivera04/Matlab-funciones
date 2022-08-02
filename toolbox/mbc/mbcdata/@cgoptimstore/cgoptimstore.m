function obj = cgoptimstore(cgoptim)
%CGOPTIMSTORE Constructor for an optimization interface.
%   I = CGOPTIMSTORE constructs a new interface that is used for
%   communicating between the optimization capabilities in CAGE and
%   user-defined optimization functions.
%
%   The cgoptimstore object provides methods for accessing information
%   about and evaluating the objectives and constraints that have been
%   defined in the CAGE GUI.  It also provides the interface for sending
%   the optimization results back to CAGE when an optimization is
%   completed.
%
%   See also: CGOPTIMSTORE/GET, CGOPTIMSTORE/EVALUATE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:54:19 $

if nargin == 0 
    cgoptim = [];
end

s = struct('cgoptim', cgoptim);
obj = class(s, 'cgoptimstore');