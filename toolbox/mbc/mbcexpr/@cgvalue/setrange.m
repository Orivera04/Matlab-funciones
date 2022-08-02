function obj = setrange(obj, rng, changevalueflag)
%SETRANGE A short description of the function
%
%  OBJ = SETRANGE(OBJ, RNG) sets the range of the obejct to RNG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:16:21 $ 

if isa(rng,'double') & length(rng)==2
    obj.bounds = rng;
else
    error('mbc:cgvalue:InvalidPropertyValue', 'Range must be a two element double.');
end