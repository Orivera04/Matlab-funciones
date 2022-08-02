namelen = 10;                    % 10 bytes for name
reclen = namelen + 4;
fid = fopen('marks.bin', 'r+');  % open for read and write

rec = input( 'Which record do you want to change? ' );
fpos = (rec-1)*reclen;       % file position indicator
fseek(fid, fpos, 'bof');     % move file position indicator
str = fread(fid,namelen);    % read the name
name = char(str');
mark = fread(fid, 1, 'float');  % read the mark
fprintf('%s %4.0f\n', name, mark)

mark = input('Enter corrected mark: '); % new mark
fseek(fid, -4, 'cof');      % go back 4 bytes to start of mark
fwrite(fid, mark, 'float'); % overwrite mark
fprintf( 'Mark updated' );

fclose(fid);