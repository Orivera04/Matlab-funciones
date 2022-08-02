function ok = pCheckScalarInputs(obj)
%PCHECKSCALARINPUTS Check that all inputs are set to be scalar values
%
%  PCHECKSCALARINPUTS(OBJ) returns true if all of the inputs associated
%  with the tradeoff are set to be scalar values.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:30 $ 

scalar_ok = pveceval([pGetTableInputs(obj), pGetOtherInputs(obj)], @isscalar);
ok = all([scalar_ok{:}]);