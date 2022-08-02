try
    if exist('a');
        set(findobj('Tag','columnsinputbox'), 'string',...
            num2str(round(eval(get(findobj('Tag','columnsinputbox'),'string')))));
        if str2num(get(findobj('Tag','columnsinputbox'),'string'))>=1 &...
                str2num(get(findobj('Tag','columnsinputbox'),'string'))<=columns;
            columnsshown=str2num(get(findobj('Tag','columnsinputbox'),'string'));
        else;
            columnsshown=columns;
            set(findobj('Tag','columnsinputbox'), 'String', columns);
            if exist('a'); opening_iteration; CA_Display; end;
            if zoom_worked==1;
                errordlg('Columns must be a number between 1 and total columns of the matrix','Error');
            end;
        end;
    else; set(gcbo, 'string','');
    end;
catch
    columnsshown=columns;
    set(findobj('Tag','columnsinputbox'), 'String', columns);
    if exist('a'); opening_iteration; CA_Display; end;
    if zoom_worked==1;
        errordlg('Columns must be a number between 1 and total columns of the matrix','Error');
    end;
end
zoom_worked=0;