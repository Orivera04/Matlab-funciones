function output = pr_evalinline(il, inputs)
%PR_EVALINLINE Evaluate inline object
%
%  OUT = PR_EVALINLINE(IL, IN) evaluates IL at IN and returns the output.
%  If any of the output values are complex they are set to NaN and the
%  complex part is removed.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:56 $ 


output = il(inputs{:});
if ~isreal(output)
    % Make any complex outputs be NaN
    im = imag(output);
    output(im~=0) = NaN;
    output = real(output);
end
