function nonescher1(figNumber,GalleryGUIFlag)
% NONESCHER1  Draws a tiling that is not an Escher-tiling.

%   Corinna Hager , University of Stuttgart. 19/02/03.
%
% Gallery initialization =================
if ~exist('GalleryGUIFlag'), figNumber=0; end;
% Create help.
infoStr= ...                                            
        ['                                               '  
         ' Parkett mit punktsymmetrischen Steinen;       '
         ' also kein Escher-Parkett.                     '
         ' Laves-Netz: (4,4,4,4)                         '
         '                                               '
         ' by Corinna Hager                              '  
         '                                               '  
         '                                               '  
         ' File name: nonescher2.m                       '];
gallinit(figNumber,infoStr);

A=[0 0 -0.5 0 -0.5 -1 -3 -3 -2.5 -3 -2.5 -2 0; ...
        0 2 2.5 3 3.5 3 3 1 0.5 0 -0.5 0 0];

for z1 = -2:1:2
    for z2 = -2:1:2

        A1=[A(1,:)+6*z1; A(2,:)+6*z2];
        A2=[A(2,:)+6*z1; -A(1,:)+6*z2];
        A3=[-A(1,:)+6*z1; -A(2,:)+6*z2];
        A4=[-A(2,:)+6*z1; A(1,:)+6*z2];
       
        fill(A1(1,:),A1(2,:),'w');
        hold on;
        fill(A2(1,:),A2(2,:),'w');
        hold on;
        fill(A3(1,:),A3(2,:),'w');
        hold on;
        fill(A4(1,:),A4(2,:),'w');
        hold on;
    end
end

box on;
axis ([-7 7 -7 7]);
axis equal;
axis off;