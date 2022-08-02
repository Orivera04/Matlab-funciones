function matdraw(command)
% MATDRAW  adds menus and draw functions to Matlab
% MATDRAW()
% Adds a suite of menus and a Draw palette to
% the Matlab environment. 
%
% MATDRAW('help') prints the README file in 
% the MATDRAW directory.
%
% MATDRAW('quiet') starts MATDRAW up surpressing errors.
%
% Keith Rogers 3/95

% Copyright (c) 1997 by Keith Rogers

if(nargin<1)
	command = '';
end
if(strcmp(command,'help'))
	mdpath = which('matdraw');
    type([mdpath(1:length(mdpath)-9) 'Readme']);
elseif(strcmp(command,'quiet'))
	set(gcf,'Pointer','watch');
	figure(gcf);
	eval('mdprog;','');
	set(gcf,'Pointer','arrow');
else
	set(gcf,'Pointer','watch');
	figure(gcf);
	mdprog;
	set(gcf,'Pointer','arrow');
end
