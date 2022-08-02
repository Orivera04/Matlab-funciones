try
    set(findobj('Tag','delayinput'), 'string', num2str(round(eval(get(findobj('Tag','delayinput'),'string')))));
    if str2num(get(findobj('Tag','delayinput'),'string'))>=0;
        delay = str2num(get(findobj('Tag','delayinput'),'string'));
    else; 
        set(findobj('Tag','delayinput'), 'string', 0);
        delay = str2num(get(findobj('Tag','delayinput'),'string'));
        errordlg('Delay must be a number, 0 or higher','Error');
    end;
catch
    set(findobj('Tag','delayinput'), 'string', 0);
    delay = str2num(get(findobj('Tag','delayinput'),'string'));
    errordlg('Delay must be a number, 0 or higher','Error');
end
