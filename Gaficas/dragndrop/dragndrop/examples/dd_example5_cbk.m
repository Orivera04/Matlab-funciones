function testcallback_7(drag,drop);
% DD_EXAMPLE5_CBK      Callback for DD_EXAMPLE5.

%Generate 3D plots (pcolor) from matrices, line plots from vectors.  Allow
%multiple lines to be plotted.  3D plots are selected via a popupmenu.  2D
%plots are selected via a listbox.
%
%Data is stored in figure's appdata, with the same name as used in the
%uicontrol

%Make drop target the current axes.
set(gcf,'CurrentAxes',drop);

style = get(drag,'Style');
switch style
    case 'popupmenu'        %3D
        val = get(drag,'Value');
        strng = get(drag,'String');
        str = strng{val};
        data = getappdata(gcf,str);
        
        cla
        surf(data);
        view(2)
        title(str)
        shading interp
    case 'listbox'
        val = get(drag,'Value');
        strng = get(drag,'String');
        for ii=1:length(val)    %Allow for multiple items
            str = strng{val(ii)};
            data{ii} = getappdata(gcf,str);
        end;
        colors = get(gcf,'defaultAxesColorOrder');
        cla
        for ii=1:length(data)
            plot(data{ii},'Color',colors(ii,:));
            hold on
        end;
        hold off
        legend(strng(val))
end;

