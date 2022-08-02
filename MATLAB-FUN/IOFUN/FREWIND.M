function frewind(fid)
%FREWIND Rewind an open file.
%	FREWIND(FID) sets the file pointer to the beginning of the 
%	file associated with file identifier fid.
%
%	WARNING: Rewinding a fid associated with a tape device may not work
%		 even though no error message is generated!

%	Jan 92 - 30
%       Jul 92 - 13
%	Nov 92 - 2, 3
%	Martin Knapp-Cordes
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%
%----------------------------------------------------------------------------
%
	if (nargin ~= 1)
	    error ('Wrong number of arguments.')
	end

	fidvec = fopen('all');
	for i = 1:size(fidvec,2)
	     if (fid == fidvec(i))
		status = fseek(fid, 0, -1);
		if (status == -1)
		    error ('Rewind failed.')
		end
		return
	     end
	end
	error ('Invalid file identifier.')
