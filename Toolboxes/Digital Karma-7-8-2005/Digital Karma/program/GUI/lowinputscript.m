try
    set(findobj('Tag','lowinput'), 'string', num2str(round(eval(get(findobj('Tag','lowinput'),'string')))));
    if  exist('high')
        if  isfinite(str2num(get(findobj('Tag','lowinput'),'string'))) &...
                str2num(get(findobj('Tag','lowinput'),'string'))<str2num(get(findobj('Tag','highinput'),'string'));
            low = str2num(get(findobj('Tag','lowinput'),'string'));
        else; 
            set(findobj('Tag','lowinput'), 'string', str2num(get(findobj('Tag','highinput'),'string'))-1);
            low = str2num(get(findobj('Tag','lowinput'),'string'));
            if exist('a'); opening_iteration; CA_Display; end;
            errordlg('Low must be a number less than High','Error');
        end;
    else;
        if  isfinite(str2num(get(findobj('Tag','lowinput'),'string')));
            low = str2num(get(findobj('Tag','lowinput'),'string'));
        else; 
            set(findobj('Tag','lowinput'), 'string', str2num(get(findobj('Tag','highinput'),'string'))-1);
            low = str2num(get(findobj('Tag','lowinput'),'string'));
            if exist('a'); opening_iteration; CA_Display; end;
            errordlg('Low must be a number less than High','Error');
        end;
    end;
catch
    set(findobj('Tag','lowinput'), 'string', str2num(get(findobj('Tag','highinput'),'string'))-1);
    low = str2num(get(findobj('Tag','lowinput'),'string'));
    if exist('a'); opening_iteration; CA_Display; end;
    errordlg('Low must be a number','Error');
end
