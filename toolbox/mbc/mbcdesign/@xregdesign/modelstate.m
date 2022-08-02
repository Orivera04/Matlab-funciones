function st=modelstate(smod,ms);
% MODELSTATE   Returns number defining current model state
%
%   ST=MODELSTATE(D) returns a number indicating the current state
%   of the model data.  This number is incremented whenever the model
%   changes so it can be used to 'stamp' stored results.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:11 $

%  Unpublished feature: can include new modelstate value as second
%  input.  D=MODELSTATE(D,MS).  This is to cope with the moving of
%  the model field from des_linearmod to design.  This is dangerous
%  functionality in any other circumstances.

% 
% Created 29/11/99

if nargin==1;
   st=smod.modelstate;
else
   smod.modelstate=ms;
   st=smod;
end
