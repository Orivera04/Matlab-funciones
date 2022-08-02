function farbe3(figNumber,GalleryGUIFlag)
% FARBE1  Creates a colored tiling - 
% possibility number 3.

%   Corinna Hager , University of Stuttgart. 19/02/03.
%
% Gallery initialization =================
if ~exist('GalleryGUIFlag'), figNumber=0; end;
% Create help.
infoStr= ...                                            
        ['                                               '  
         ' Dritte Faerbungsmoeglichkeit:                 '
         ' Nochmal ein drehinvariantes Farbparkett.      '
         '                                               '
         ' by Corinna Hager                              '  
         '                                               '  
         '                                               '  
         ' File name: farbe3.m                           '];
gallinit(figNumber,infoStr);

A=[-3 0 0 -0.5 -1 -1.5 -3 -3 -2 -3; ...
        0 0 3 3 4 3 3 1.5 1 0.5];

for z1 = -2:1:2
    for z2 = -2:1:2

        A1=[A(1,:)+6*z1; A(2,:)+6*z2];
        A2=[A(2,:)+6*z1; -A(1,:)+6*z2];
        A3=[-A(1,:)+6*z1; -A(2,:)+6*z2];
        A4=[-A(2,:)+6*z1; A(1,:)+6*z2];
        
        c=mod(z1,2);
        d=mod(z2,2);
        %Farbauswahl%
        
        if c == 0
          f1 = 'r';
          f3 = 'y';
        else 
          f1 = 'y';
          f3 = 'r';
        end
        
        if d == 0
          f2 = 'w';
          f4 = 'b';
        else 
          f2 = 'b';
          f4 = 'w';
        end
        
        fill(A1(1,:),A1(2,:),f1);
        hold on;
        fill(A2(1,:),A2(2,:),f2);
        hold on;
        fill(A3(1,:),A3(2,:),f3);
        hold on;
        fill(A4(1,:),A4(2,:),f4);
        hold on;
    end
end

axis equal;
axis off;