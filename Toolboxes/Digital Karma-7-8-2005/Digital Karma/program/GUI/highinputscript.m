try
    set(findobj('Tag','highinput'), 'string', num2str(round(eval(get(findobj('Tag','highinput'),'string')))));
    if exist('low')
        if  isfinite(str2num(get(findobj('Tag','highinput'),'string'))) & str2num(get(findobj('Tag','highinput'),'string'))>low;
            high = str2num(get(findobj('Tag','highinput'),'string'));
        else; 
            set(findobj('Tag','highinput'), 'string', str2num(get(findobj('Tag','lowinput'),'string'))+1);
            high = str2num(get(findobj('Tag','highinput'),'string'));
            if exist('a'); opening_iteration; CA_Display; end;
            errordlg('High must be a number greater than Low','Error');
        end;
    else;
        if  isfinite(str2num(get(findobj('Tag','highinput'),'string')));
            high = str2num(get(findobj('Tag','highinput'),'string'));
        else; 
            set(findobj('Tag','highinput'), 'string', str2num(get(findobj('Tag','lowinput'),'string'))+1);
            high = str2num(get(findobj('Tag','highinput'),'string'));
            if exist('a'); opening_iteration; CA_Display; end;
            errordlg('High must be a number greater than Low','Error');
        end;
    end;
catch
    set(findobj('Tag','highinput'), 'string', str2num(get(findobj('Tag','lowinput'),'string'))+1);
    high = str2num(get(findobj('Tag','highinput'),'string'));
    if exist('a'); opening_iteration; CA_Display; end;
    errordlg('High must be a number','Error');
end