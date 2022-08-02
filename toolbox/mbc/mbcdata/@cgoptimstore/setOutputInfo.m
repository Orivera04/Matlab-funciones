function cos = setOutputInfo(cos, okstat, errmsg, OUTPUT)
%SETOUTPUTINFO Set output information for the optimization.
%   OPTIMSTORE = SETOUTPUTINFO(OPTIMSTORE, OK, ERRMSG, OUTPUT) sets output
%   information for the optimization in OPTIMSTORE. The following
%   information is set:
%  
%     OK     : (0/1), indicating whether the optimization has completed
%              without error. 
%     ERRMSG : Error message string if OK = 0, or an empty string if
%              OK = 1. 
%     OUTPUT : Structure of algorithm statistics for the optimization.
%
%   See the worked example for an example of creating an OUTPUT structure.
%
%   See also CGOPTIMSTORE/GETOUTPUTINFO, MBCOSWORKEDEXAMPLE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.2 $    $Date: 2004/02/09 06:54:31 $ 

[ok, msg] = i_CheckInputs(okstat, errmsg, OUTPUT);

if ok
    cos.cgoptim = setOutputInfo(cos.cgoptim, okstat, errmsg, OUTPUT);
else
    error('mbc:cgoptimstore:InvalidArgument', msg);
end

%----------------------------------------------------
function [ok, msg] = i_CheckInputs(okstat, errmsg, OUTPUT)
%----------------------------------------------------

ok = false;
msg = '';
if ~ismember(okstat, [0 1])
    msg = 'OK must be either 0 or 1.';
elseif ~ischar(errmsg)
    msg = 'ERRMSG must be a string.';
elseif ~isstruct(OUTPUT)
    msg = 'OUTPUT must be a structure.';
else
    ok = true;
end
