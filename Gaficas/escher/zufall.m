function zufall(figNumber,GalleryGUIFlag)
% ZUFALL  Creates a tiling with random colors - 
% without any symmetry.

%   Corinna Hager , University of Stuttgart. 19/02/03.
%
% Gallery initialization =================
if ~exist('GalleryGUIFlag'), figNumber=0; end;
% Create help.
infoStr= ...                                            
        ['                                               '  
         ' Zufallsfaerbung des Netzes:                   '
         ' keine Symmetrie, daher kein Farbparkett.      '
         '                                               '
         ' by Corinna Hager                              '  
         '                                               '  
         '                                               '  
         ' File name: zufall.m                           '];
gallinit(figNumber,infoStr);

A=[-3 0 0 -0.5 -1 -1.5 -3 -3 -2 -3; ...
        0 0 3 3 4 3 3 1.5 1 0.5];

for z1 = -2:1:2
    for z2 = -2:1:2

        A1=[A(1,:)+6*z1; A(2,:)+6*z2];
        A2=[A(2,:)+6*z1; -A(1,:)+6*z2];
        A3=[-A(1,:)+6*z1; -A(2,:)+6*z2];
        A4=[-A(2,:)+6*z1; A(1,:)+6*z2];
        
        %Erzeugung der zufaelligen Faerbung%
        Z=rand(2,2);
        if Z(1,1) < 0.25 
          f='y';
        elseif Z(1,1) < 0.5
          f='b';
        elseif Z(1,1) < 0.75 
          f='r';
        else 
          f='w';
        end
        fill(A1(1,:),A1(2,:),f);
        hold on;
        
        if Z(1,2) < 0.25 
          f='y';
        elseif Z(1,2) < 0.5
          f='b';
        elseif Z(1,2) < 0.75 
          f='r';
        else 
          f='w';
        end
        fill(A2(1,:),A2(2,:),f);
        hold on;
        
        if Z(2,1) < 0.25 
          f='y';
        elseif Z(2,1) < 0.5
          f='b';
        elseif Z(2,1) < 0.75 
          f='r';
        else 
          f='w';
        end
        fill(A3(1,:),A3(2,:),f);
        hold on;
        
        if Z(2,2) < 0.25 
          f='y';
        elseif Z(2,2) < 0.5
          f='b';
        elseif Z(2,2) < 0.75 
          f='r';
        else 
          f='w';
        end
        fill(A4(1,:),A4(2,:),f);
        hold on;
    end
end

axis equal;
axis off;