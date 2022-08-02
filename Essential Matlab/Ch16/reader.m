namelen = 10;                  % 10 bytes for name
fid = fopen('marks.bin', 'r');

while ~feof(fid)
    str = fread(fid,namelen);  % ASCII codes of name were stored in file
    name = char(str');         % transpose data and interpret as characters
    mark = fread(fid, 1, 'float');
    fprintf('%s %4.0f\n', name, mark)
end

fclose(fid);