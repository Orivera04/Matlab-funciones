try
    rowserror=0;
    set(findobj('Tag','rowsinputbox'), 'string', num2str(round(eval(get(findobj('Tag','rowsinputbox'),'string')))));
    if dimension==1;
        if str2num(get(findobj('Tag','rowsinputbox'),'string'))>=1;
            rows = str2num(get(findobj('Tag','rowsinputbox'),'string'));
        else; rowserror=1; end;
    elseif dimension==2;
        if str2num(get(findobj('Tag','rowsinputbox'),'string'))>=1 & str2num(get(findobj('Tag','rowsinputbox'),'string'))<=totalrows;
            rowsshown=str2num(get(findobj('Tag','rowsinputbox'),'string'));
        else; rowserror=2; end;
    end;

    if rowserror==1;
        rows=20;
        set(findobj('Tag','rowsinputbox'), 'string', 20);
        if exist('a'); opening_iteration; CA_Display; end;
        if zoom_worked==1; errordlg('Rows must be a number, 1 or higher','Error'); end;
    elseif rowserror==2;
        rowsshown=totalrows;
        set(findobj('Tag','rowsinputbox'), 'string', rowsshown);
        if exist('a'); opening_iteration; CA_Display; end;
        if zoom_worked==1; errordlg('Rows must be a number between 1 and total rows of the matrix','Error'); end;
    end;
catch
    if dimension==1;
        rows=20;
        set(findobj('Tag','rowsinputbox'), 'string', 20);
        if exist('a'); opening_iteration; CA_Display; end;
        if zoom_worked==1; errordlg('Rows must be a number, 1 or higher','Error'); end;
    elseif dimension==2;
        rowsshown=totalrows;
        set(findobj('Tag','rowsinputbox'), 'string', rowsshown);
        if exist('a'); opening_iteration; CA_Display; end;
        if zoom_worked==1; errordlg('Rows must be a number between 1 and total rows of the matrix','Error'); end;
    end;
end
zoom_worked=0;