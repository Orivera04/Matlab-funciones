function display(mod)
%DISPLAY cgmodexpr display method.
%
%  DISPLAY(M)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:01 $

if strcmp(get(0 , 'formatspacing') , 'loose')
    str = ' ';
else
    str = '';
end

if isempty(mod)
    disp(str);
    disp('An empty cgmodexpr object');
    disp(str);
else
    inputs = getinputs(mod);
    num_inputs = nfactors(mod);
    if num_inputs>0
        len = length(inputs);
        disp(str)
        disp(sprintf('cgmodexpr object: %d required argument(s), %d argument(s) defined.', num_inputs, len));
        disp(str)   
    else
        disp('An empty cgmodexpr object');
    end
end