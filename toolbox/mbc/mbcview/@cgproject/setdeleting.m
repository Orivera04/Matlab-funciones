function proj = setdeleting(proj, flag)
%SETDELETING Set the BeingDeleted flag in the project
%
%  SETDELETING(PROJ, STATE) where STATE is 0 or 1
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:28:27 $ 


proj.beingdel = flag;
pointer(proj);
