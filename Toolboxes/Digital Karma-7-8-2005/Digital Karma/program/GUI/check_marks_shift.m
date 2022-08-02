set(findobj('Tag','movemenu'), 'checked', 'off'); set(findobj('Tag','movetoggle'), 'value', 0);
set(findobj('Tag','changermenu'), 'checked', 'off'); set(findobj('Tag','changertoggle'), 'value', 0);
set(findobj('Tag','panmenu'), 'checked', 'off'); set(findobj('Tag','pantoggle'), 'value', 0);
set(findobj('Tag','wrapmenu'), 'checked', 'off'); set(findobj('Tag','wraptoggle'), 'value', 0);

switch shiftclickvariable
    case 'move'
        set(findobj('Tag','movemenu'), 'checked', 'on'); set(findobj('Tag','movetoggle'), 'value', 1);
    case 'changer'
        set(findobj('Tag','changermenu'), 'checked', 'on'); set(findobj('Tag','changertoggle'), 'value', 1);
    case 'pan'
        set(findobj('Tag','panmenu'), 'checked', 'on'); set(findobj('Tag','pantoggle'), 'value', 1);
    case 'wrap'
        set(findobj('Tag','wrapmenu'), 'checked', 'on'); set(findobj('Tag','wraptoggle'), 'value', 1);
end;

if exist ('a'); opening_iteration; CA_Display; end;


