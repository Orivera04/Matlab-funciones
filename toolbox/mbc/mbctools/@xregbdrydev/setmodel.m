function bd = setmodel( bd, m )
%SETMODEL A short description of the function
%
%  OUT = SETMODEL(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:13:13 $ 

bd.Model = m;

xregpointer( bd );
