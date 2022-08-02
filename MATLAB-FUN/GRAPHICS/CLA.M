function ret_ax = cla(opt_reset)
%CLA 	Clear axis.
% 	CLA deletes all objects (lines, text, patches, surfaces, and
%	images) from the current axes.
%	CLA RESET deletes everything and also resets all axis properties,
%	except position, to their default values.
%
%	See also CLF, RESET, HOLD.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

ax = gca;

% Delete all axis children.
kids = get(ax,'Children');
for i = 1:max(size(kids))
	delete(kids(i));
end
if (nargout ~= 0)
	ret_ax = ax;
end

% Do reset, if requested
if nargin == 1 
	if strcmp(opt_reset,'reset')
		position = get(ax,'position');
		reset(ax);
		set(ax,'position',position);
	else
		error('Unknown command option.')
	end
elseif nargin > 1
	error('Unknown command option.')
end


