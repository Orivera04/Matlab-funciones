function mygui(arg)
%MYGUI Sample Switchyard Programming Example.

if nargin==0
   arg='initialize';
end
switch arg
case 'initialize'
   % code that creates the GUI and sets the callbacks
case 'Apply'
   % code that performs Apply button callback actions
case 'Revert'
   % code that performs Revert button callback actions
case 'Done'
   % code that performs Done button callback actions
otherwise
   % report error?
end
   