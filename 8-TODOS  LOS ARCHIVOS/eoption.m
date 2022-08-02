function choice = eoption
% eoption prints the menu of options and error-checks
%  until the user pushes one of the buttons
% Format: eoption or eoption()
 
choice = menu('Choose an e option', 'Explanation', ...
    'Limit', 'Exponential function', 'Exit Program');
% If the user closes the menu box rather than 
%  pushing one of the buttons, choice will be 0
while choice == 0
    disp('Error - please choose one of the options.')
    choice = menu('Choose an e option', 'Explanation', ...
        'Limit', 'Exponential function', 'Exit Program');
end
end
