function habilitar(handle,modo,boton)
if (modo=='f') & (boton=='s')
    set(handle,'Enable','inactive');
    set(handle,'ForegroundColor',[0.5 0.5 0.5]);
elseif (modo=='f') & (boton=='n')
    set(handle,'Enable','inactive');
    set(handle,'ForegroundColor',[0.5 0.5 0.5]);
    set(handle,'BackgroundColor',[0.8 0.8 0.8]);
elseif (modo=='v') & (boton=='s')
    set(handle,'Enable','on');
    set(handle,'ForegroundColor','k');
elseif (modo=='v') & (boton=='n')
    set(handle,'Enable','on');
    set(handle,'ForegroundColor','b');
    set(handle,'BackgroundColor','w');
end