function [c, OK] = fitmodel( c, X )
%FITMODEL A short description of the function
%
%  OUT = FITMODEL(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:56:59 $ 

warning( sprintf( 'The is no FITMODEL method for %s objects', ...
    upper( class( c ) ) ) );

OK = false;
