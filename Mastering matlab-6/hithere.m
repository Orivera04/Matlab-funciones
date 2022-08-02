% script hithere.m
% Example script to illustrate the use of the java.awt package.
%
% Mastering MATLAB 6 Java Example 3 - 7/12/00
%

% Create a Frame object and specify a 2x1 grid layout style.

dbox=java.awt.Frame('Hi There!');
dbox.setLayout(java.awt.GridLayout(2,1));

% Specify the window location, size and color. Use Java syntax
%    for the location, hybrid syntax for the size, and MATLAB 
%    syntax to set the background color.

dbox.setLocation(50,50);
resize(dbox,200,100);
set(dbox,'Background',[.7 .8 .9]);

% Create a text label and a bright red button.

txt=java.awt.Label('Click the button to exit.',1);
but=java.awt.Button('Exit Button');
set(but,'Background',[1,0,0]);

% Define a callback for the button.

set(but,'MouseClickedCallback','dbox.dispose')

% Attach the label and button to the window.

dbox.add(txt);
dbox.add(but);

% The window is hidden by default. Make it visible.

dbox.show;

