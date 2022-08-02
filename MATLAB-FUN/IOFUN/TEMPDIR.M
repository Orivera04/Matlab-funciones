function tmp_dir = tempdir()
%TEMPDIR Returns the name of the temporary directory if one exists

%	Marc Ullman  2-8-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

comp = [computer '   '];
if (comp(1:2) =='PC')
	tmp_dir = getenv('TEMP');		% Microsoft's recommended name
	if ( isempty(tmp_dir) )
		tmp_dir = getenv('TMP');	% What everybody else uses
	end
	if ( ~isempty(tmp_dir) )
		% Make sure name ends with a valid path separator
		last_char = tmp_dir(length(tmp_dir));
		if ((last_char ~= '\') & (last_char ~= '/'))
			tmp_dir = [tmp_dir '\'];
		end
	end
elseif (comp(1:3) == 'MAC')
	tmp_dir = '';
elseif (comp(4:6) == 'VMS')
	tmp_dir = 'SYS$SCRATCH:';
else
	% Assume we are on a UNIX system
	tmp_dir = '/tmp/';
end
