function [cout,hand] = contour3(arg1,arg2,arg3,arg4,arg5)
%CONTOUR3 3-D contour plot.
%	CONTOUR3(Z) plots the contour lines of Z in 3-D.  
%	CONTOUR3(Z,N) plots N contour lines in 3-D.  The default is N=10.
%	CONTOUR3(X,Y,Z) or CONTOUR3(X,Y,Z,N) uses the matrices X and Y
%	to define the axis limits.
%
%	C = CONTOUR3(...) returns contour matrix C as described in CONTOURC.
%	[C,H] = CONTOUR3(...) returns a column vector H of handles to LINE
%	objects, one handle per line. 
%
% 	See also CONTOURC, CONTOUR.

%	Clay M. Thompson 3-20-91
%	Modified 1-17-92, LS.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

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
         error ('Invalid Argument - Input matrix is empty');
      end
end

% true 4.0 parsing, etc.

if(nargin < 1)
        error('Not enough input arguments.')
else

        %%%
        %%% let's trim off the last arg if it's a string
        %%% (line_spec) for now.  we'll do something with it later.
        %%%
        line_spec = '';

        num_args = nargin;
        last_arg = eval(['arg',num2str(num_args)]);
        if(isstr(last_arg))
                line_spec = last_arg;
                num_args = num_args - 1;
        end

% get color order for cycling of contour colors unless a linetype was passed in
	if ~isempty(line_spec)
		[j1,j2] = colstyle(line_spec);
	else
		j1 = '-';
		j2 = [];
	end
        if isempty(j2) % no color spec was given
                colortab = get(newplot,'colororder');
                [mc,nc] = size(colortab);
        end

        %%%
        %%% check x and y to be sure they are vectors, if they were inputs
        %%%
        if num_args > 2
                % if arg1 and arg2 are not vectors, make them vectors
                if min(size(arg1)) > 1
                        arg1 = arg1(1,:);
                end
                if min(size(arg2)) > 1
                        arg2 = arg2(:,1);
                end
	elseif num_args == 2
		if max(size(arg2)) == 1 % might be N or a contour level
			if ~(arg2 == fix(arg2) & arg2 > 0)
				arg2 = [arg2 arg2];
			end
		end
        end

        %%%
        %%% now let's assemble the list of args to pass to the internal
        %%% contour command, which only returns the data vector, and no longer
        %%% does any plotting:
        %%%
        the_passed_args = ['arg1'];
        for i = 2:num_args
                the_passed_args = [the_passed_args, ', arg', num2str(i)];
        end

        %%%
        %%% do the call, get the c vector:
        %%%
        c = [];
        the_call = ['c = contourc(', the_passed_args, ');'];
        eval(the_call);
	if nargout > 0
		cout = c;
	end

	newplot;

        %%%
        %%% now we have to do the plot.
        %%%
	csize = size(c);
        limit = csize(2);
        i = 1;

        h = [];
        color_h = [];

        while(i < limit)
                z_level = c(1,i);
                npoints = c(2,i);
		nexti = i+npoints+1;
		while (nexti < limit)
			if (z_level == c(1, nexti))
				npoints = npoints + c(2,nexti) + 1;
				c(1,nexti) = nan;
				c(2,nexti) = nan;
			else
				break;
			end
			nexti = i+npoints+1;
		end
                xdata = c(1,i+1:i+npoints);
                ydata = c(2,i+1:i+npoints);
                zdata = z_level * ones(1,npoints);
                cu = line('XData',xdata,'YData',ydata,'ZData',zdata);
                h = [h; cu(:)];
                color_h = [color_h ; z_level];
                i = nexti;
        end
        if ~ishold
		view(322.5,30);
        end

        if isempty(j2)
                % set linecolors - all LEVEL lines should be same color
                % first find number of unique contour levels
                [zlev, ind] = sort(color_h);
                h = h(ind);     % handles are now sorted by level
                ncon = length(find(diff(zlev))) + 1;    % number of unique levels
                if ncon > mc    % more contour levels than colors, so cycle colors
                        % build list of colors with cycling
                        ncomp = round(ncon/mc); % number of complete cycles
                        remains = ncon - ncomp*mc;
                        one_cycle = (1:mc)';
                        index = one_cycle(:,ones(1,ncomp));
                        index = [index(:); (1:remains)'];
                        colortab = colortab(index,:);
                end
                j = 1;
                zl = min(zlev);
                for i = 1:length(h)
                        if zl < zlev(i)
                                j = j + 1;
                                zl = zlev(i);
                        end
                        set(h(i),'linestyle',j1,'color',colortab(j,:));
                end
        else
		  if ~isempty(j1)
            status = set(h,'linestyle',j1);
		  end
		  if ~isempty(j2)
            status = set(h,'color',j2);
		  end
        end

%%%
%%% If command was of the form 'cout = contour(...)', let's return
%%% the results of the contourc command:
%%%
        if(nargout > 1)
                hand = h;
        end
end

