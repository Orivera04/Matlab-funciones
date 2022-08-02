function [smin, smax] = saxis(v)
%SAXIS	Sound axis scaling.
%	The SOUND function ordinarily scales its input vector Y so that the
%	maximum and minimum values in Y correspond to the maximum and
%	minimum input ranges allowed by the sound hardware.
%
%	SAXIS(V), where V is the two element vector V = [SMIN SMAX], disables
%	SOUND's automatic scaling and sets the scaling so that SMIN and SMAX
%	correspond to the minimum and input maximum ranges allowed by the
%	sound hardware. Values outside this range are clipped.
%
%	SAXIS('auto') sets sound axis scaling back to automatic.
%	SAXIS, by itself, returns the two element row vector containing the
%	[SMIN SMAX] currently in effect.
%
%	SAXIS is entirely analogous to CAXIS and AXIS, only its scaling applies
%	to sounds rather than graphical limits.
%
%	See also SOUND, CAXIS, AXIS.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

global SAXIS_SCALE 
global SAXIS_LIM
if nargin == 0
	if isempty(SAXIS_SCALE)
		SAXIS_SCALE = 'auto';
		SAXIS_LIM = [-1 1];
	end
else
	if strcmp(v,'auto')
		SAXIS_LIM = [-1 1];
		SAXIS_SCALE = 'auto';
	elseif length(v) ~= 2
		error('Requires a two-element argument.')
	else
		SAXIS_SCALE = 'fixed';
		SAXIS_LIM = v(:)';
	end
	return
end
if nargout <= 1
	smin = SAXIS_LIM;
elseif nargout == 2
	smin = SAXIS_LIM(1);
	smax = SAXIS_LIM(2);
end
