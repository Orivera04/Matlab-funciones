function [list] = localclasses( c )
%GLOBALCLASSES List of the classes for the global of two-stage constraints
%
%  LIST = GLOBALCLASSES(C) is a structure array with fields 'Name' and
%  'Class'. This is the list of classes that can be used as the global
%  models of two stage boundary models.
%
%  See also: CONTWOSTAGE/LOCALCLASSES.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:41 $ 

list(1).Name  = 'Interpolating RBF';
list(1).Class = 'xreginterprbf';
