function [cout, hand] = contour(arg1, arg2, arg3, arg4, arg5);
% CONTOUR Contour plot.
% 	CONTOUR(Z) is a contour plot of matrix Z treating the values in Z
% 	as heights above a plane.
% 	CONTOUR(X,Y,Z), where X and Y are vectors, specifies the X- and Y-
% 	axes used on the plot.
% 	CONTOUR(Z,N) and CONTOUR(X,Y,Z,N) draw N contour lines, 
% 	overriding the default automatic value.
% 	CONTOUR(Z,V) and CONTOUR(X,Y,Z,V) draw LENGTH(V) contour lines 
% 	at the values specified in vector V.
% 	CONTOUR(...,'linetype') draws with the color and linetype specified,
% 	as in the PLOT command.
%
%	C = CONTOUR(...) returns contour matrix C as described in CONTOURC
%	and used by CLABEL.
%	[C,H] = CONTOUR(...) returns a column vector H of handles to LINE
%	objects, one handle per line. 
% 	
% 	See also CLABEL, CONTOURC, CONTOUR3, GRADIENT, QUIVER, PRISM.

%-------------------------------
%	Additional details:
%
%	If the NextPLot axis property is REPLACE (HOLD is off), CONTOUR resets 
%	all axis properties, except Position, to their default values
%	and deletes all axis children (line, patch, surf, image, and 
%	text objects).

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 1
        error('Not enough input arguments.')
end

% check up front for 3.5 parsing and exchange for 4.0 order
if nargin >= 4
        if  min(size(arg3)) == 1        % must be 3.5 syntax
                t = arg1;
                arg1 = arg3;
                arg3 = t;
                t = arg4;
                arg4 = arg2;
                arg2 = t;
                clear t
        end
end

for i = 1:nargin
      if isempty(eval(['arg', num2str(i)]))
         error ('Input arguments must not be empty.');
      end
end

the_passed_args = ['arg1'];
for i = 2:nargin
        the_passed_args = [the_passed_args, ', arg', num2str(i)];
end

numargs = nargin;
last_arg = eval(['arg',num2str(numargs)]);
if(isstr(last_arg))
	numargs = numargs - 1;
end

if numargs > 2
        % if arg1 and arg2 are not vectors, make them vectors
        if min(size(arg1)) > 1
                arg1 = arg1(1,:);
        end
        if min(size(arg2)) > 1
                arg2 = arg2(:,1);
        end
	lims = [min(arg1) max(arg1) min(arg2) max(arg2)];
else
	[mc,nc] = size(arg1);
	lims = [1 nc 1 mc];
end

c = []; h = [];
the_call = ['[c,h] = contour3(', the_passed_args, ');'];
eval(the_call);

for i = 1:length(h)
        set(h(i),'Zdata',zeros(size(get(h(i),'Zdata'))));
end
if ~ishold
        view(0,90);
	axis(lims);
	set(gca,'box','on');
end

if nargout > 0
	cout = c;
	hand = h;
end
