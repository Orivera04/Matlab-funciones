function c = setparams( c, varargin );
%SETPARAMS  Set constraint parameters
%  C = SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list of parameter-value 
%  pairs. For lists of valid parameters, see the underlying constraint type.
%
%  See also CONLINEAR/SETPARAMS, CONELLIPSOID/SETPARAMS, CONTABLE1/SETPARAMS, 
%    CONTABLE2/SETPARAMS, CONSTAR/SETPARAMS, CONCGMODEL/SETPARAMS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:09:27 $

c.conobj = setparams( c.conobj, varargin{:} );
