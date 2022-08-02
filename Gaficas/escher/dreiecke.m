function dreiecke(figNumber,GalleryGUIFlag)
% DREIECKE  Draws a tiling of triangles.

%   Corinna Hager , University of Stuttgart. 19/02/03.
%
% Gallery initialization =================
if ~exist('GalleryGUIFlag'), figNumber=0; end;
% Create help.
infoStr= ...                                            
        ['                                               '  
         ' Parkett mit gleichseitigen Dreiecken.         '  
         ' Laves-Netz: (6,6,6)                           '
         '                                               '
         ' by Corinna Hager                              '  
         '                                               '  
         '                                               '  
         ' File name: dreiecke.m                         '];
gallinit(figNumber,infoStr);

A = [0 1 0.5; 0 0 sqrt(3)*0.5];
B = [1 0.5 1.5; 0 sqrt(3)*0.5 sqrt(3)*0.5];

for a = -5:5
    for b = -5:5
        fill(A(1,:)+a+b*0.5,A(2,:)+b*sqrt(3)*0.5,'w');
        fill(B(1,:)+a+b*0.5,B(2,:)+b*sqrt(3)*0.5,'w')
        hold on;
    end
end

colordef white;
box on;
axis ([-2 2 -2 2]);
axis equal;
axis off;