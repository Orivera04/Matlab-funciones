set(0,'defaultaxesfontsize',(4/3)*20)
set(0,'defaulttextfontsize',(4/3)*20*2)
set(0,'defaulttextfontweight','bold')
set(0,'defaulttextfontname','Helvetica')
set(0,'defaultaxesposition',[ 0.13 .15 .775 .815])
vertices_mx = [0 0 0
    .5 1 0
    1 0 0
    .5 .5 1];
faces_mx = [1 2 3
    1 2 4
    1 3 4]; %Face 'A' is drawn separately
clf
patch('Vertices',vertices_mx,'faces',faces_mx,'FaceColor','y')
patch('Vertices',vertices_mx,'faces',[2 3 4],'FaceColor',[1 1 1])
view(162,44)
box;xyz
i = 1;
text(vertices_mx(i,1)-.15,vertices_mx(i,2)+.1,vertices_mx(i,3)+.05,'1 ',...
    'hor','right','vert','bot')
i = 2;
text(vertices_mx(i,1),vertices_mx(i,2),vertices_mx(i,3),'  2',...
    'hor','left','ver','bot')
i = 3;
text(vertices_mx(i,1)+.05,vertices_mx(i,2),vertices_mx(i,3)+.05,' 3',...
    'hor','left','ver','bot')
i = 4;
text(vertices_mx(i,1),vertices_mx(i,2),vertices_mx(i,3),' 4',...
    'hor','cen','ver','bot')
text(.7, .6, .4,'A')
