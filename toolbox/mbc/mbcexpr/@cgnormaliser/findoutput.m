function [targetInput, OK] = findoutput(obj, targetOutput, varargin)
%FINDOUTPUT Find the input settings that produce a given output
%
%  [INPUT, OK] = FINDOUTPUT(OBJ, TARGETOUT) where TARGETOUT is a vector of
%  output values and OBJ is an expression that has just one inport will
%  find values for that inport which produce the values TARGETOUT when obj
%  is evaluated.  If OBJ does not have a single inport then the function
%  will return with no input set and OK set to false.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:13:50 $ 

targetInput = invert(obj, targetOutput);

pInput = get(obj, 'x');
if pInput.isinport
    % Set the inverted data into the input expression
    pInput.info = pInput.setvalue(targetInput);
    OK = true;
else
    % Pass on the inverted data to the input expression
    [targetInput, OK] = findoutput(pInput.info, targetInput, varargin{:});
end