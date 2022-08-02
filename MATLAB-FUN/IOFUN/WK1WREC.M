function wk1wrec(fid, rectype, vreclen)
% WK1WREC Write a wk1 record header.
%	WK1WREC(fid, rectype, vreclen) writes out the WK1 record header
%

%	Brian M. Bourgault 10/22/93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%

	%
	%	Write out the record type
	%
	fwrite(fid, rectype(1), 'ushort');

	%
	%	Write out the record length
	%
	if rectype(2) ~= -1
		% fixed length records
		fwrite(fid, rectype(2), 'ushort');
		reclen = rectype(2);
	else
		% variable length records
		fwrite(fid, vreclen, 'ushort');
		reclen = vreclen;
	end

