% DEMO_01.M ------------------
% GEKELER: FINITE ELEMENTE----
% Demo fuer Triangulierung----
% RAND(1,:) muss im math. pos. Sinn numeriert sein

clf
[KNOTEN,RAND,ELEMENTE] = beisp01;
bild(KNOTEN,RAND,ELEMENTE)
disp('Weiter mit bel. Taste')
pause
disp('Knoten in das Zentrum des umgebenden Polygons verschieben:')
[KNOTEN,RAND,ELEMENTE] = mesh01(KNOTEN,RAND,ELEMENTE);
bild(KNOTEN,RAND,ELEMENTE)
disp('Weiter mit bel. Taste')
pause
disp('Knoten manuell verschieben:')
KNOTEN = mesh02(KNOTEN,RAND,ELEMENTE);
bild(KNOTEN,RAND,ELEMENTE)
disp('Weiter mit bel. Taste')
pause
clf
disp('Lange Kanten durch kurze ersetzen:')
ELEMENTE = mesh03(KNOTEN,RAND,ELEMENTE);
bild(KNOTEN,RAND,ELEMENTE)
disp('Weiter mit bel. Taste')
pause
disp('Delaunay-Trinangulierung')
ELEMENTE  = delaunay(KNOTEN(1,:),KNOTEN(2,:));
ELEMENTE =  ELEMENTE';
flipud(ELEMENTE);
clf
bild(KNOTEN,RAND,ELEMENTE)
disp('Weiter mit bel. Taste')
pause
disp('Elemente ausserhalb')
disp('des einfach zusammenhaengenden Gebietes eliminieren:')
ELEMENTE = mesh04(KNOTEN,RAND,ELEMENTE);
clf
bild(KNOTEN,RAND,ELEMENTE)
