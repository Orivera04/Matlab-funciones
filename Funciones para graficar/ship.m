% Draw a ship

shipgray = [.7 .75 .75];
% Hull:
vert = [...
 -1	.7	0
  0.8	0.8	0
  1.3	0	0
  0.8	-.8	0
  -1	-.7	0
  -1	1	1
  1	1	1
  1.5	0	1.2
  1	-1	1
 -1	-1	1];

vert(:,1) = 5*vert(:,1);
vert(:,3) = 0.7*vert(:,3);

faces = {...
[1 2 7 6];
[2 3 8 7];
[3 8 9 4];
[4 9 10 5];
[1 5 10 6];
[6 7 8 9 10];
[1 2 3 4 5]};

for i=1:size(faces,1)
  patch('Vertices',vert,'Faces',faces{i},'FaceColor',shipgray,...
        'EdgeColor',0.5*shipgray)
end

%for i=1:size(faces,1)
%  patch('Vertices',vert,'Faces',faces{i},'FaceColor','none',...
%        'EdgeColor',0.5*shipgray)
%end
% Superstructure:
neck = 0.5;
vert = [...
-1	1	0
-.6	1	0
-.2	(1 - neck)	0
.2	(1 - neck)	0
.6	1-neck/2	0
1	1-neck/2	0
1	-(1-neck/2)	0
.6	-(1-neck/2)	0
.2	-(1 - neck)	0
-.2	-(1 - neck)	0
-.6	-1	0
-1	-1	0
-1	1	1
-.6	1	1
-.2	(1 - neck)	1
.2	(1 - neck)	1
.6	1-neck/2	1
1	1-neck/2	1
1	-(1-neck/2)	1
.6	-(1-neck/2)	1
.2	-(1 - neck)	1
-.2	-(1 - neck)	1
-.6	-1	1
-1	-1	1];
vert(:,1) = 3*vert(:,1) + 1;
vert(:,3) = 0.8*vert(:,3) + .7;
faces = [...
1 2 14 13
2 3 15 14
3 4 16 15
4 5 17 16
5 6 18 17
6 7 19 18
8 7 19 20
9 8 20 21
10 9 21 22
11 10 22 23
12 11 23 24
1 12 24 13];
patch('Vertices',vert,'Faces',faces,'FaceColor',shipgray,...
        'EdgeColor',0.5*shipgray)
faces = 13:24;
patch('Vertices',vert,'Faces',faces,'FaceColor',shipgray,...
        'EdgeColor',0.5*shipgray)

view(26,30)

axis equal vis3d



