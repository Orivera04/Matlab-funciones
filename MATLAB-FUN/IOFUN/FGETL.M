function line = fgetl(fid)
%FGETL	Return the next line of the file as a string.
%       FGETL(FID) returns the next line of a file associated with file
%       identifier fid as a MATLAB string. The newline and a carriage return
%	if it preceeds it are NOT included. Use FGETS() to get the next line
%	with those characters INCLUDED. If just an end-of-file is encountered
%	then -1 is returned.
%
%       IMPORTANT: Please note that this is intended to be used ONLY with 
%                  text files. If by mistake you read a "binary" file
%                  without newline characters this routine may take a
%		   long time for large files.
%
%	Example: (equivalent to 'type fgetl.m')
%	
%	    fid=fopen('fgetl.m');
%	    while 1
%	        line = fgetl(fid);
%		if ~isstr(line), break, end
%		disp(line)
%	    end
%	    fclose(fid);
%

%	Jan 92 - 30
%	Feb 92 - 3
%	May 92 - 5
%	Oct 92 - 23
%	Nov 92 - 13, 15, 19
%       Dec 93 - 2
%	Martin Knapp-Cordes, Steve Bangert, Mark Reichelt
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%
%	Algorithm suggested by Cleve Moler.
%	Newline = 10 (decimal)
%	Carriage Return = 13 (decimal)
%	Blocksize = 128 (decimal)
%	The ASCII character set is assumed.
%	C "binary" stream files only for fseek to work properly.
%
%----------------------------------------------------------------------------
%
	if (nargin ~= 1)
	    error ('Wrong number of arguments.')
	end

	comp = computer;
	if (comp(1:3) =='MAC')
		NEWLINE = 13;
	else
        NEWLINE = 10;
	end
	CR = 13;
	BLOCKSIZE = 128;

	line = '';
	fidvec = fopen('all');
	for i = 1:size(fidvec,2)
	    if (fid == fidvec(i))

                % Read characters (as many as BLOCKSIZE) into vector block.
		[block, count] = fread(fid, BLOCKSIZE, 'uchar');

                % If the file was empty, return -1.
		if ~count, line = -1; return, end

                % Find indices of all NEWLINE characters.
		index = find(block == NEWLINE);

                % If a NEWLINE was found, create a string (possibly
                % empty) of everything in the block before it. 
		if ~isempty(index)
		    if index(1) ~= 1 
			if block(index(1) - 1) == CR
		            line = setstr(block(1:(index(1) - 2))');
			else
		    	    line = setstr(block(1:(index(1) - 1))');
			end
		    else
		    	line = '';
		    end

                    % Rewind file position indicator to just after index(1).
		    fseek (fid, index(1) - count, 'cof');
		    return

                % No NEWLINES were found, and the end of file was reached.
		elseif count < BLOCKSIZE
		    line = setstr(block');
		    return
		end

                % At this point, there were no NEWLINES, and there
                % were at least BLOCKSIZE characters read into block.

                % Read more blocks until a NEWLINE is found, or
                % end of the file is reached (count < BLOCKSIZE).
		while (isempty(index) & count == BLOCKSIZE)
		    line = [line setstr(block')];
		    [block, count] = fread(fid, BLOCKSIZE, 'uchar');
		    index = find(block == NEWLINE);
		end

                % If a NEWLINE was found, create a string (possibly
                % empty) of everything in the block before it. 
		if ~isempty(index)
		    if index(1) ~= 1 
			if block(index(1) - 1) == CR
		            line = [line setstr(block(1:(index(1) - 2))')];
		        else
		    	    line = [line setstr(block(1:(index(1) - 1))')];
			end
		    end

                    % Rewind file position indicator to just after index(1).
		    fseek (fid, index(1) - count, 'cof');
		    return

                % No NEWLINES were found, and end of the file was reached.
		elseif count < BLOCKSIZE
		    line = [line setstr(block')];
		    return
		end
	    end
	end
	error ('Invalid file identifier.')
