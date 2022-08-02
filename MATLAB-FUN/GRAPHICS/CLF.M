function ret_fig = clf(opt_reset)
%CLF 	Clear Figure.
% 	CLF deletes all objects from the current figure.
%	CLF RESET deletes everything and also resets all figure properties,
%	except position, to their default values.
%
%	See also CLA, RESET, HOLD.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

fig = gcf;

% Delete all figure children.
delete(get(fig,'Children'));

if (nargout ~= 0)
	ret_fig = fig;
end

% Do reset, if requested
if nargin == 1
	if strcmp(opt_reset,'reset')
		reset(fig);
	else
		error('Unknown command option.')
	end
elseif nargin > 1
	error('Unknown command option.')
end
