function selectmod(stin)

prechandle=findobj(gcf,'Tag','PopupMenu2');
threshhandle=findobj(gcf,'Tag','EditText3');
restarthandle=findobj(gcf,'Tag','EditText4');

switch stin,
case 'on',
   set(prechandle,'Enable','on');
   set(threshhandle,'Enable','on');
case 'off',
   set(prechandle,'Value',1);
   set(prechandle,'Enable','off');
   set(threshhandle,'Enable','off');
case 'ron'
   set(restarthandle,'Enable','on');
case 'roff'
   set(restarthandle,'Enable','off');
end
