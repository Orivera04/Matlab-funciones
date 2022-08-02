function [c] = saveobj(c)
%SAVEOBJ Processing of object before save

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:14 $ 


c.SpecialPointOptions = i_saveobj( c.SpecialPointOptions );
c.BdryPointOptions    = i_saveobj( c.BdryPointOptions );
c.ModelFitOptions     = i_saveobj( c.ModelFitOptions );

%--------------------------------------------------------------------------
function a = i_saveobj( a )
% The options can be strings or option managers. If they are strings then
% we don't want to call the saveobj method on them.
if ~isa( a, 'char' ),
    a = saveobj( a );
end
%--------------------------------------------------------------------------
% EOF
%--------------------------------------------------------------------------
