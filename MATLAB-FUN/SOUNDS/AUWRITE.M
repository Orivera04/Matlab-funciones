function auwrite(y,filename)
%AUWRITE Write mu-law encoded audio file.
%	AUWRITE(Y,'filename') converts Y to mu-law encoded bytes
%	and writes it to the specified audio file.
%	If no file name is given, /dev/audio is used, either on
%	the local machine, or on the remote machine specified by
%	the environment variable DISPLAY.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

mu = lin2mu(y);

if nargin == 2
    % Output to specified file.
    fp = fopen(filename,'wb');
    if fp == -1
        error(['Cannot open ' filename ' with write privilege.'])
    end
    fwrite(fp,mu,'uchar');
    fclose(fp);
else
    if isvms
       disp('Not available for VMS.');
       return;
    end
    % Is audio device local or remote?
    machinename = getenv('HOST');
    dspname = getenv('DISPLAY');
    dspname  = dspname(1:find(dspname == ':')-1);
    if strcmp(dspname,machinename) | strcmp(lower(dspname),'unix') | ...
       isempty(dspname) | isempty(machinename)
        % Audio device is (probably) on this machine.
        fp = fopen('/dev/audio','wb');
        if fp == -1
            disp('Audio capabilities are not available on this machine.')
        else
            fwrite(fp,mu,'uchar');
            fclose(fp);
        end
    else
        % Audio device is on a remote machine.
        % Write to a temporary file, then use a shell escape
        % to send the file to the remote /dev/audio.
        t = clock;
        tmpfile = ['/tmp/au' sprintf('%02.0f%02.0f%02.0f', t(4:6))];
        fp = fopen(tmpfile,'wb');
        if fp == -1
            error(['Cannot open ' tmpfile ' with write privilege.'])
        end
        fwrite(fp,mu,'uchar');
        fclose(fp);
        cp = computer;
        rsh = 'rsh ';
        if cp(1) == 'H'
           rsh = 'remsh ';
        end
        eval(['!cat ' tmpfile ' | ' rsh dspname ' ''cat > /dev/audio'' ']);
        delete(tmpfile);
    end
end
