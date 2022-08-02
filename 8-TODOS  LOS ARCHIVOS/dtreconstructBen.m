function dtreconstruct
%create the signal components
t = -pi:.05:pi;
signal = cell(1,7);
for i = 1:7
   signal{i} = exp(-j*2*pi/7*i*t); 
    
end

f=figure('Visible','Off','Position',[360 500 400 400]);

minval = 1;
maxval = 7;

slhan = uicontrol('Style','slider','Position',[140 280 100 50],'Min',minval,'Max',maxval,'Value',minval,'SliderStep',[.1429 .1429],'CallBack',@callbackfn);

hmintext = uicontrol('Style','text','BackgroundColor','white','Position',[90 285 40 15],'String',num2str(minval));

hmaxtext = uicontrol('Style','text','BackgroundColor','white','Position',[250 285 40 15],'String',num2str(maxval));

hsttext = uicontrol('Style','text','BackgroundColor','white','Position',[170 340 40 15],'Visible','off');

axhan = axes('Units','Pixels','Position',[100 50 200 200]);

set(f,'Name','Sinc Function Reconstruction');
movegui(f,'center')
set([slhan hmintext hmaxtext hsttext axhan],'Units','Normalized')
set(f,'Visible','On')


    function callbackfn(source,eventdata)
        num = floor(get(slhan,'Value'));
        set(hsttext,'Visible','on','String',num2str(num))
        sincfn = zeros(1,length(t));
        for i = 1:num
            sincfn = sincfn + signal{i};
        end
        
        stem(axhan,t,sincfn)

    end


end