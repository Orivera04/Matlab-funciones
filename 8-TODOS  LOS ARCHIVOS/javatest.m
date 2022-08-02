function javatest(obj)
% Test java object references

disp(obj.getLabel)                % Display the object label
newref = obj;                     % Create a new reference
set(newref,'Label','Label One')   % Change the label using set()
disp(newref.getLabel)             % Display the new label
setLabel(newref,'Label Two')      % Use the setLabel method 
disp(newref.getLabel)             % Display the label again
newref.setLabel('Label Three')    % Use Java object method syntax
disp(newref.getLabel)             % Display the label
