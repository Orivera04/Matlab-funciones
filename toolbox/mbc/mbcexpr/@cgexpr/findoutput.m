function [targetInput, OK] = findoutput(obj, targetOutput, method)
%FINDOUTPUT Find the input settings that produce a given output
%
%  [INPUT, OK] = FINDOUTPUT(OBJ, TARGETOUT) where TARGETOUT is a vector of
%  output values and OBJ is an expression that has just one inport will
%  find values for that inport which produce the values TARGETOUT when obj
%  is evaluated.  If OBJ does not have a single inport then the function
%  will return with no input set and OK set to false.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:08:36 $ 

pVar = getinports(obj);
if cgnumindependentvars(pVar)~=1
    targetInput = [];
    OK = false;
    return  
end

if nargin<3
    % Tests show the interp method is about 5% slower but gives results
    % that are typically an order of magnitude more accurate.  Plus it
    % makes an attempt to approximate values outside the variable range.
    method = 'interp';
end

switch method
    case 'interp'
        % Calculate the inputs at 1000 points and find the pairs that are
        % surrounding the target outputs
        pVar.info = pVar.linspace(1000);
        approxOutput = i_eval(obj);
        approxInput = pVar.getvalue;
        inputIdx = 0;
        targetInput = zeros(size(targetOutput));
        for n = 1:length(targetInput)
            X = approxOutput - targetOutput(n);
            [nul, inputIdx] = min(abs(X));
            if X(inputIdx)>0
                inputIdx = inputIdx - 1;
            end
            inputIdx = max(min(inputIdx, 999), 1);
            
            targetInput(n) = approxInput(inputIdx) +  ...
                (targetOutput(n) - approxOutput(inputIdx)) ./ ...
                (approxOutput(inputIdx+1) - approxOutput(inputIdx)) .* ...
                (approxInput(inputIdx+1) - approxInput(inputIdx));
        end
        
        pVar.info = pVar.setvalue(targetInput);
        OK = true;
        
    case 'closest'
        
        % Calculate the inputs at 1000 points and choose the ones that are
        % closest to the target outputs
        pVar.info = pVar.linspace(1000);
        approxOutput = i_eval(obj);
        approxInput = pVar.getvalue;
        inputIdx = 0;
        targetInput = zeros(size(targetOutput));
        for n = 1:length(targetInput)
            [nul, inputIdx] = min(abs(approxOutput - targetOutput(n)));
            targetInput(n) = approxInput(inputIdx);
        end
        pVar.info = pVar.setvalue(targetInput);
        OK = true; 
end
