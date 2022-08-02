function [list] = localclasses( c )
%LOCALCLASSES List of the classes that are available as local constraint models
%
%  LIST = LOCALCLASSES(C) is a structure array with fields 'Name' and
%  'Class'. This is the list of classes that can be used as the local paart
%  of two stage boundary models.
%
%  See also: CONTWOSTAGE/GLOBALCLASSES.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:59:44 $ 

list(1).Name  = 'Ellipsoid';
list(1).Class = 'conellipsoid';

list(2).Name  = 'Range';
list(2).Class = 'conrange';
