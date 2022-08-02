function br = delchild( br, chind )
%DELCHILD A short description of the function
%
%  BR = DELCHILD(BR,CHIND), where CHIND is the child index
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:13:25 $ 

% Need to establish if the best model has been deleted.
ch = children( br );
if ismember( br.Best, ch ),
    br.Best = xregpointer;
end
