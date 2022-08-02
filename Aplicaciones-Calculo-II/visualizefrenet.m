function visualizefrenet(j,x,Tg,Nm,Bn,t, factor, handles)
axes(handles.axes1)
hold on
y1 = x+ factor* Tg(1:end-1,:);
y2 = x+ factor* Nm(1:end-1,:);
y3 = x+ factor* Bn(1:end-1,:);
hp = [];

    while j<length(y1) && strncmp(get(handles.stop,'String'), 'Freeze',6)
        j = j+1;
        delete(hp)
        hp(1) = plot3([x(j,1) y1(j,1)], ...
              [x(j,2) y1(j,2)],...
              [x(j,3) y1(j,3)], 'g');
        hp(2) = plot3([x(j,1) y2(j,1)], ...
              [x(j,2) y2(j,2)],...
              [x(j,3) y2(j,3)], 'r');    
        hp(3) = plot3([x(j,1) y3(j,1)], ...
              [x(j,2) y3(j,2)],...
              [x(j,3) y3(j,3)],'y');
        set(hp, 'Linewidth', 3)  
        set(handles.stop, 'Userdata', j)
        pause(t(j+1)-t(j))
        
    end
  
