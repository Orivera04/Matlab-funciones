namelen = 10;                                  % 10 bytes for name
fid = fopen('marks.bin', 'w');                 % open for write only
str = '?';                                     % not empty to start

while ~isempty(str)
    str = input( 'Enter name: ', 's' );
    if ~isempty(str)        
        if length(str) > namelen
            name = str(1:namelen);             %only first ten chars allowed
        else
            name = str;
            name(length(str)+1:namelen) = ' '; %pad with blanks if too short
        end
        fwrite(fid, name);
        mark = input( 'Enter mark: ' );
        fwrite(fid, mark, 'float');            % 4 bytes for mark
    end
end

fclose(fid);