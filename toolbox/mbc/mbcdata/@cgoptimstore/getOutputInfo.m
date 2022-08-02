function [OK, msg, OUTPUT] = getOutputInfo(cos)
%GETOUTPUTINFO Get output information for the optimization.
%   [OK, ERRMSG] = GETOUTPUTINFO(OPTIMSTORE) returns diagnostic output
%   information from OPTIMSTORE.  OK denotes the success (OK = 1) or
%   failure (OK = 0) of the current optimization run.  If the optimization
%   is unsuccessful, an error message is returned in ERRMSG.
%
%   [OK, ERRMSG, OUTPUT] = GETOUTPUTINFO(OPTIMSTORE) returns in addition a
%   structure of algorithm-specific information in OUTPUT.  For OUTPUT to
%   be non-empty, the user must create it in their algorithm.  See the
%   worked example and tutorial for more information on how to create
%   OUTPUT structures.
%
%   See also CGOPTIMSTORE/SETOUTPUTINFO, MBCOSWORKEDEXAMPLE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:54:25 $ 

[OK, msg, OUTPUT] = getOutputInfo(cos.cgoptim);

