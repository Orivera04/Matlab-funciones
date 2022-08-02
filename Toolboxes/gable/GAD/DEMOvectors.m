     disp('>> % 	VECTORS');
     % 	VECTORS
     GAfigure; clc; %/
     disp('>> % 	VECTORS');
     % 	VECTORS
     global v w; %/
     clf; %/
     disp('>> %	Vectors can be defined using coordinates:');
     %	Vectors can be defined using coordinates:
     disp('>> v = e1 + e2;');
     v = e1 + e2;
     disp('>> w = e2 + 2*e3;');
     w = e2 + 2*e3;
     disp('>> draw(v,''b'');');
     draw(v,'b');
     GAtext(0.5*v -0.1*unit(w),'v'); %/
     disp('>> draw(w,''g'');');
     draw(w,'g');
     GAtext(0.5*w-0.1*unit(v),'w'); %/ 
     axis('vis3d'); %/
     va = [-0.1 1 0 2 -0.1 2]; %/
     axis(va); %/
     GAprompt; %/
     GAorbiter(60,6); %/
     GAprompt; %/
     disp('>> % 	Adding vectors, as usual:');
     % 	Adding vectors, as usual:
     disp('>> v+w');
     v+w
     draw(v+w,'r'); %/
     GAtext(0.7*(v+w) -0.1*unit(w),'v+w'); %/
     DrawPolyline({v,v+w},'k'); %/
     DrawPolyline({w,v+w},'k'); %/
     disp('>> % 	But vector addition is coordinate-free,');
     % 	But vector addition is coordinate-free,
     disp('>> %	so we will drop the axes.');
     %	so we will drop the axes.
     axis(va); %/
     GAprompt; %/
     axis off; %/
     GAprompt; %/
     disp('>> %	Vectors `are'' geometrical objects in space.');
     %	Vectors `are' geometrical objects in space.
     GAorbiter(360,10); %/
