%% File : whichme
%%
%% Abstract :
%%  Returns the location on the matlab path where the object's
%%  class is found.

%% $Revision: 1.1 $
%% $Date: 2002/10/02 10:15:44 $
%%
%% Copyright 2002 The MathWorks, Inc.
function obj_path = whichme(obj)
    obj_path = fileparts(which(class(obj)));
    
