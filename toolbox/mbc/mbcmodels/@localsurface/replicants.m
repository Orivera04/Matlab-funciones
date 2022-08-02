function [reps, smallx]=replicants(m,varargin)
%xreglinear/REPLICANTS   Replicated design entries
%   reps=replicants(m,x) returns a cell array with each cell containing
%   a unique bio-engineered lifeform.  See also BLADERUNNERS for information
%   on deleting the above safely.
%
%   Note that these replicants have been likened to vectors containing a list
%   of test rows from x which are considered to be identical.  However this
%   similarity is purely coincidental.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:29 $

[reps, smallx]=replicants(m.userdefined,varargin{:});