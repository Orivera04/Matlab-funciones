set(findobj('Tag','cellvaluesmenu'), 'checked', 'off');
set(findobj('Tag','selectionvaluesmenu'), 'checked', 'off');
set(findobj('Tag','bytevaluesmenu'), 'checked', 'off'); set(findobj('Tag','bytevaluestoggle'), 'value', 0);
clear byteselection;

if cellvaluemouseover==1; set(findobj('Tag','cellvaluesmenu'), 'checked', 'on'); end;
if selectionvaluemouseover==1; set(findobj('Tag','selectionvaluesmenu'), 'checked', 'on'); end;
if bytevaluemouseover==1;
    set(findobj('Tag','bytevaluesmenu'), 'checked', 'on'); set(findobj('Tag','bytevaluestoggle'), 'value', 1);
end;


if exist ('a'); opening_iteration; CA_Display; end;