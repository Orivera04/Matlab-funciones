set(findobj('Tag','selectionmenu'), 'checked', 'off'); set(findobj('Tag','selectiontoggle'), 'value', 0);
set(findobj('Tag','notoolsmenu'), 'checked', 'off');

switch currentmousetool
    case 'selection'
        set(findobj('Tag','selectionmenu'), 'checked', 'on'); set(findobj('Tag','selectiontoggle'), 'value', 1);
        set(gcf,'WindowButtonDownFcn','mouse_location; selecting_button_down_script;');
        set(gcf,'WindowButtonMotionFcn','mouse_location; selecting_button_move_script;');
        set(gcf,'WindowButtonUpFcn','selecting_button_up_script;');
case 'none'
        set(findobj('Tag','notoolsmenu'), 'checked', 'on');
        set(gcf,'WindowButtonDownFcn',' '); set(gcf,'WindowButtonUpFcn',' ');
        set(gcf,'WindowButtonMotionFcn',' '); changerbuttondownvalue=0;
end;

if exist ('a'); opening_iteration; CA_Display; end;
