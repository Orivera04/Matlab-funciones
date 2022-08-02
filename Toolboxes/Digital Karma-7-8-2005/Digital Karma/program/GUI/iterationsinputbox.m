try
    set(findobj('Tag','iterationsinput'), 'string', num2str(round(eval(get(findobj('Tag','iterationsinput'),'string')))));
    if str2num(get(findobj('Tag','iterationsinput'),'string'))>=0;
        iterations = str2num(get(findobj('Tag','iterationsinput'),'string'));
    else;
        set(findobj('Tag','iterationsinput'), 'string', 10);
        iterations = str2num(get(findobj('Tag','iterationsinput'),'string'));
        errordlg('Iterations must be a number, 0 or higher','Error');
    end;
catch
    set(findobj('Tag','iterationsinput'), 'string', 10);
    iterations = str2num(get(findobj('Tag','iterationsinput'),'string'));
    errordlg('iterations must be a number, 0 or higher','Error');
end