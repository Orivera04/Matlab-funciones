function choicex(name)
%CHOICEX Close a list of choices.
%	CHOICEX('NAME') closes the choice window with name 'NAME' and
%	removes this name from the registration list.
%	CHOICEX is used as the callback for the Close button in a choice list
%	created using CHOICES.
%
%	See also CHOICES.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if ~isstr(name)
	error('Requires string input argument.')
end
name = deblank(name);
% set up link to global choice names and handles and add or delete
% these in lock-step
global CHOICELIST
global CHOICEHANDLES
match = 0;
for i = 1:size(CHOICELIST,1)
	if strcmp(name,deblank(CHOICELIST(i,:)))
	    match = i;
	    break;
	end
end
if match == 0   % no match
	return
else
	delete(CHOICEHANDLES(match));
	CHOICEHANDLES(match) = [];
	CHOICELIST(match,:) = [];
	if (match-1) > 0
		set(CHOICEHANDLES(match-1),'visible','on')
	end
end
