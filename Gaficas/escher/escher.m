function escher
%Erzeugt Schritt fuer Schritt ein vollstaendiges Parkett.

figure;
% Erzeugung der Eckpunkte des ersten Steins%
A=    [-2 0 1 1.5 2 1.7 2 0 -1 -1.5 -2 -2.1 -1.9 -2 -2.3 -2; ...
       -2 -1.25 -1.75 -1.2 -1 1.5 2 2.75 2.25 2.8 3 2.5 1.5 1 -1.5 -2];


%erstes Bild - die 5 Eckpunkte%

str=[-2 2 -2 -1; 2 2 -1 2; 2 -2 2 3; ...
        -2 -2 3 1; -2 -2 1 -2];

for m = 1:5
    fill(str(m,1:2),str(m,3:4),'k');
    colordef white;
    axis equal;
    axis off;
    hold on;
end
hold on;
pause(3);

%zweites Bild - der Parkettstein%
fill(A(1,:),A(2,:),'w');
hold on;
pause(3);

%drittes Bild - Drehung um (-2/2)%
B1=[-A(1,:)-4 ;-A(2,:)+4];
fill(B1(1,:),B1(2,:),'b');
hold on;
pause(3);

%viertes Bild - Gleitspiegelung1%
B2=[A(1,:)+4 ;-A(2,:)];
fill(B2(1,:),B2(2,:),'y');
hold on;
B3=[A(1,:)-4 ;-A(2,:)];
fill(B3(1,:),B3(2,:),'y');
hold on;
pause(3);

%fuenftes Bild - Gleitspiegelung2%
B4=[-A(1,:) ;A(2,:)+4];
fill(B4(1,:),B4(2,:),'r');
hold on;
B5=[-A(1,:) ;A(2,:)-4];
fill(B5(1,:),B5(2,:),'r');
hold on;
pause(3);

%letztes Bild - das fertige Parkett%

for m = -2:1:2
    for n = -2:1:2
        A1=[A(1,:)+m*8; A(2,:)+n*8];
        A2=[B1(1,:)+m*8; B1(2,:)+n*8];
        A3=[B3(1,:)+m*8; B3(2,:)+n*8];
        A4=[B4(1,:)+m*8; B4(2,:)+n*8];
        fill(A1(1,:),A1(2,:),'w');
        hold on;
        fill(A2(1,:),A2(2,:),'b');
        hold on;
        fill(A3(1,:),A3(2,:),'y');
        hold on;
        fill(A4(1,:),A4(2,:),'r');
        hold on;
    end
end