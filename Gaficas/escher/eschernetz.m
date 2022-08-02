function eschernetz(figNumber,GalleryGUIFlag)
% NONESCHER1  Draws a tiling that is not an Escher-tiling.

%   Corinna Hager , University of Stuttgart. 19/02/03.
%
% Gallery initialization =================
if ~exist('GalleryGUIFlag'), figNumber=0; end;
% Create help.
infoStr= ...                                            
        ['                                               '  
         ' Parkett, dass den Forderungen eines           '
         ' Escher-Parketts genuegt.                      '
         ' Laves-Netz: (4,3,3,4,3)                       '
         ' Escher-Parkett Nr. 11                         '
         '                                               '
         ' by Corinna Hager                              '  
         '                                               '  
         '                                               '  
         ' File name: eschernetz.m                       '];
gallinit(figNumber,infoStr);

% Erzeugung der Eckpunkte des ersten Steins%
A=    [-2 0 1 1.5 2 1.7 2 0 -1 -1.5 -2 -2.1 -1.9 -2 -2.3 -2; ...
       -2 -1.25 -1.75 -1.2 -1 1.5 2 2.75 2.25 2.8 3 2.5 1.5 1 -1.5 -2];

B1=0.25*[-A(1,:)-4 ;-A(2,:)+4];
B3=0.25*[A(1,:)-4 ;-A(2,:)];
B4=0.25*[-A(1,:) ;A(2,:)+4];

%letztes Bild - das fertige Parkett%

for m = -1:1:1
    for n = -1:1:1
        A1=[0.25*A(1,:)+m*2; 0.25*A(2,:)+n*2];
        A2=[B1(1,:)+m*2; B1(2,:)+n*2];
        A3=[B3(1,:)+m*2; B3(2,:)+n*2];
        A4=[B4(1,:)+m*2; B4(2,:)+n*2];
        fill(A1(1,:),A1(2,:),'w');
        box on;
        axis([-1.5 1.5 -1.5 1.5]);
        axis equal;
        axis off;
        hold on;
        fill(A2(1,:),A2(2,:),'w');
        hold on;
        fill(A3(1,:),A3(2,:),'w');
        hold on;
        fill(A4(1,:),A4(2,:),'w');
        hold on;
    end
end