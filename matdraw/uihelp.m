function uihelp(arg1,arg2,arg3,arg4)
%UIHELP   Generate code to implement uicontrol help 
%         UIHELP(FIG,FILENAME) scans the figure FIG
%         to find all uicontrols.  It then generates
%         a function such that if the function is
%         assigned to FIG's KEYPRESSFCN property,
%         pressing the 'h' key while the cursor is 
%         over a uicontrol will display a help message
%         in the MATLAB command window.  The function
%         is then written to FILENAME.
%
%         The default help message is:
%         'No help available for this UIcontrol'
%         and may be changed easily by the uicontrol
%         designer.  The section relating to each
%         uicontrol is marked with the uicontrol's
%         style and tag for easy reference.
%
%         If FILENAME is not specified, the default
%         filename of 'uihelper' is used.
%
%         UIHELP(FIG,'dlg',FILENAME) generates code
%         to make use of the HELPDLG function instead
%         of displaying help in the command window.
%
%         UIHELP(FIG,'normalized',FILENAME) generates
%         the code assuming uicontrols with the UNITS 
%         property set to 'normalized' so that the 
%         help notices will still be appropriate if
%         the figure is resized.  The default behavior
%         assumes uicontrols with fixed units (points,
%         inches, etc.
%
%         The 'dlg' or 'normalized' options may appear
%         in any argument position in the UIHELP call.
%
%         Send comments or questions to kerog@draper.com


% Version 1.0
% Copyright (c) 1995 by Keith Rogers

%%%  Defaults %%%

fig = gcf;
output = 'disp';
filename = 'uihelper';
units = 'fixed';
for(i=1:nargin);
	eval(['arg = arg' num2str(i) ';']);
	if(~isempty(arg));
		if(~isstr(arg));
			fig = arg;
		elseif(strcmp(arg,'dlg'))
			output = arg;
		elseif(strcmp(arg,'normalized'))
			units = arg;
		else
			filename = arg;
		end
	end
end

if(strcmp(filename(length(filename)-1:length(filename)),'.m'))
	filename = filename(1:length(filename)-2);
end
fd = fopen([filename '.m'],'w');

if(fd == -1)
	error(['Couldn''t open file: ' filename '!']);
end

if(~ishandle(fig))
	error('No such figure!');
elseif(~strcmp(get(fig,'Type'),'figure'))
	error('Handle is not a figure!');
end

kids = findobj(fig,'Type','uicontrol');

if(isempty(kids))
	error('No uicontrols in this figure!');
else

	%%%%%%%%%%%%%%%%%
	% Initial Lines %
	%%%%%%%%%%%%%%%%%

	fprintf(fd,['function ' filename '()\n']);
	fprintf(fd,'if(get(gcf,''CurrentCharacter'') == ''h'')\n');

	fprintf(fd,'\trootloc = getset(0,''PointerLocation'',''Units'',''Points'');\n');
	fprintf(fd,'\tfigpos = getset(gcf,''Position'',''Units'',''Points'');\n');
	if(strcmp(units,'fixed'))
		fprintf(fd,'\tloc = rootloc-figpos(1:2);\n');
	else
		fprintf(fd,'\tloc = (rootloc-figpos(1:2))./figpos(3:4);\n');
	end

	%%%%%%%%%%%%%%%%%%%
	% First uicontrol %
	%%%%%%%%%%%%%%%%%%%

	percents = '%';
	if(strcmp(units,'fixed'))
		pos = getset(kids(1),'Position','Units','Points');
	else
		pos = getset(kids(1),'Position','Units','Normalized');
	end
	tag = get(kids(1),'Tag');
	style = get(kids(1),'Style');

        %%%%%%%%%%%%%%%%%
		% Comment Block %
        %%%%%%%%%%%%%%%%%

	temp = ['% ' style ': ' tag ' %'];
	fprintf(fd,'\n');
	fprintf(fd,'\t%s\n',percents(ones(1,length(temp))));
	fprintf(fd,'\t%s\n',temp);
	fprintf(fd,'\t%s\n',percents(ones(1,length(temp))));
	fprintf(fd,'\n');

        %%%%%%%%%%%%%%%%%%%%%%%%
		% Initial IF statement %
        %%%%%%%%%%%%%%%%%%%%%%%%

	fprintf(fd,'\tif(uh_isin(loc,[%f %f %f %f]))\n',pos);
	if(strcmp(output,'disp'))
		fprintf(fd,'\t\tdisp('' '');\n');
		fprintf(fd,'\t\tdisp(''No help available for this UIcontrol'');\n');
	else
		fprintf(fd,'\t\thelpdlg(''No help available for this UIcontrol'');\n');
	end
end

if(length(kids) > 1)
	for(i=2:length(kids))
		if(strcmp(units,'fixed'))
			pos = getset(kids(i),'Position','Units','Points');
		else
			pos = getset(kids(i),'Position','Units','Normalized');
		end
		tag = get(kids(i),'Tag');
		style = get(kids(i),'Style');

			%%%%%%%%%%%%%%%%%
			% Comment Block %
			%%%%%%%%%%%%%%%%%

		temp = ['% ' style ': ' tag ' %'];
		fprintf(fd,'\n');
		fprintf(fd,'\t%s\n',percents(ones(1,length(temp))));
		fprintf(fd,'\t%s\n',temp);
		fprintf(fd,'\t%s\n',percents(ones(1,length(temp))));
		fprintf(fd,'\n');

			%%%%%%%%%%%%%%%%%%%%
			% ELSEIF statement %
			%%%%%%%%%%%%%%%%%%%%
		fprintf(fd,'\telseif(uh_isin(loc,[%f %f %f %f]))\n',pos);
		if(strcmp(output,'disp'))
			fprintf(fd,'\t\tdisp('' '');\n');
			fprintf(fd,'\t\tdisp(''No help available for this UIcontrol'');\n');
		else
			fprintf(fd,'\t\thelpdlg(''No help available for this UIcontrol'');\n');
		end
	end
end
fprintf(fd,'\tend\n');
fprintf(fd,'end\n');
fclose(fd);

fprintf(fd,'function bool = uh_isin(point,box)\n');
fprintf(fd,'if((point(1) > box(1)) & (point(1) < box(1)+box(3)) & ...\n');
fprintf(fd,'\t(point(2) > box(2)) & (point(2) < box(2)+box(4)))\n');
fprintf(fd,'\tbool = 1;\n');
fprintf(fd,'else\n');
fprintf(fd,'\tbool = 0;\n');
fprintf(fd,'end\n');

