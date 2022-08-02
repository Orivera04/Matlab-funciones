
% 3D rotation demo

clear all; close all


% Create base square vertices
cube = [ 0 0 0; 1 0 0; 1 1 0; 0 1 0 ];
% Use this base square to create another at z=1;
cube = [cube; cube + repmat([0 0 1],4,1)];

% multiply Y by 2
%cube = cube .* repmat([1 2 1],8,1);
% multiply Z by 3
%cube = cube .* repmat([1 1 3],8,1);

faces = [ 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8 ];

facecol = prism(6);


figure('name','Cube Rotations')
subplot(2,2,1);
Hp = patch('vertices',cube,'faces',faces,...
           'facevertexcdata',facecol,'facecolor','flat');
set(gca,'Xcolor',[0 0 0],'Ycolor',[1 0 0],'Zcolor',[0 0 1]);
set(gca,'Xlim',[-1.5 1.5],'Ylim',[-1.5 1.5],'Zlim',[-1.5 1.5]);
set(gca,'CameraTarget',[0 0 0]);
set(gca,'CameraPosition',[5 2 2])
set(gca,'CameraViewAngle',[35]);
set(gca,'Projection','perspective')
set(gca,'DataAspectRatio',[1 1 1]);
grid on


XYZ = Rz(cube',pi/4)';

subplot(2,2,2);
HpX = patch('vertices',XYZ,'faces',faces,...
            'facevertexcdata',facecol,'facecolor','flat');
set(gca,'Xcolor',[0 0 0],'Ycolor',[1 0 0],'Zcolor',[0 0 1]);
set(gca,'Xlim',[-1.5 1.5],'Ylim',[-1.5 1.5],'Zlim',[-1.5 1.5]);
set(gca,'CameraTarget',[0 0 0]);
set(gca,'CameraPosition',[5 2 2])
set(gca,'CameraViewAngle',[35]);
set(gca,'Projection','perspective')
set(gca,'DataAspectRatio',[1 1 1]);
grid on

rz = Rz(eye(3),pi/4);
ry = Ry(eye(3),pi/6);

XYZ = [(ry * rz * cube')]';

subplot(2,2,3);
HpX = patch('vertices',XYZ,'faces',faces,...
            'facevertexcdata',facecol,'facecolor','flat');
set(gca,'Xcolor',[0 0 0],'Ycolor',[1 0 0],'Zcolor',[0 0 1]);
set(gca,'Xlim',[-1.5 1.5],'Ylim',[-1.5 1.5],'Zlim',[-1.5 1.5]);
set(gca,'CameraTarget',[0 0 0]);
set(gca,'CameraPosition',[5 2 2])
set(gca,'CameraViewAngle',[35]);
set(gca,'Projection','perspective')
set(gca,'DataAspectRatio',[1 1 1]);
grid on

XYZ = [(rz * ry * cube')]';

subplot(2,2,4);
HpX = patch('vertices',XYZ,'faces',faces,...
            'facevertexcdata',facecol,'facecolor','flat');
set(gca,'Xcolor',[0 0 0],'Ycolor',[1 0 0],'Zcolor',[0 0 1]);
set(gca,'Xlim',[-1.5 1.5],'Ylim',[-1.5 1.5],'Zlim',[-1.5 1.5]);
set(gca,'CameraTarget',[0 0 0]);
set(gca,'CameraPosition',[5 2 2])
set(gca,'CameraViewAngle',[35]);
set(gca,'Projection','perspective')
set(gca,'DataAspectRatio',[1 1 1]);
grid on

return


figure
nf = shrinkfaces(faces,cube,.3);
Hp = patch('vertices',nf.vertices,'faces',nf.faces,'facevertexcdata',prism(6),'facecolor','flat')
view(3)





return


angle = [45 90 180];
for i=1:3,
    
	XYZ = Ry(cube',angle(i),'degrees')';
	subplot(2,2,i+1);
	HpX = patch('vertices',XYZ,'faces',faces,...
                'facevertexcdata',facecol,'facecolor','flat');
	set(gca,'Xcolor',[0 0 0],'Ycolor',[1 0 0],'Zcolor',[0 0 1]);
	set(gca,'Xlim',[-1.5 1.5],'Ylim',[-1.5 1.5],'Zlim',[-1.5 1.5]);
	set(gca,'CameraTarget',[0 0 0]);
	set(gca,'CameraPosition',[10 5 5])
	set(gca,'CameraViewAngle',[20]);
	set(gca,'Projection','perspective')
	set(gca,'DataAspectRatio',[1 1 1]);
	grid on
end

return
