function farbe1(figNumber,GalleryGUIFlag)
% FARBE1  Creates a colored tiling - 
% possibility number 1.

%   Corinna Hager , University of Stuttgart. 19/02/03.
%
% Gallery initialization =================
if ~exist('GalleryGUIFlag'), figNumber=0; end;
% Create help.
infoStr= ...                                            
        ['                                               '  
         ' Andere Faerbungsmoeglichkeit:                 '
         ' Es entsteht eine symmetrische Faerbung.       '
         ' Ein Farbparkett, aber nicht drehinvariant.    '
         '                                               '
         ' by Corinna Hager                              '  
         '                                               '  
         '                                               '  
         ' File name: farbe1.m                           '];
gallinit(figNumber,infoStr);

A=[-3 0 0 -0.5 -1 -1.5 -3 -3 -2 -3; ...
        0 0 3 3 4 3 3 1.5 1 0.5];

for z1 = -2:1:2
    for z2 = -2:1:2

        A1=[A(1,:)+6*z1; A(2,:)+6*z2];
        A2=[A(2,:)+6*z1; -A(1,:)+6*z2];
        A3=[-A(1,:)+6*z1; -A(2,:)+6*z2];
        A4=[-A(2,:)+6*z1; A(1,:)+6*z2];
        
        fill(A1(1,:),A1(2,:),'y');
        hold on;
        fill(A2(1,:),A2(2,:),'r');
        hold on;
        fill(A3(1,:),A3(2,:),'w');
        hold on;
        fill(A4(1,:),A4(2,:),'b');
        hold on;
    end
end

axis equal;
axis off;