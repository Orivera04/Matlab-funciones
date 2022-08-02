function KNOTEN = mesh02(KNOTEN,RAND,ELEMENTE);
% verschiebt Knoten manuell
% fuer Dreiecke und Vierecke
disp('Zum Beenden auf Rahmens tippen')
xmin = min(KNOTEN(1,:));
xmax = max(KNOTEN(1,:));
ymin = min(KNOTEN(2,:));
ymax = max(KNOTEN(2,:));
axis([xmin xmax ymin ymax]);
grid on
hold on
while (1)
   [U,V]     = ginput(1);
   if U < xmin | U > xmax, break, end
   if V < ymin | V > ymax, break, end
   DIST      = KNOTEN(1:2,:);
   DIST(1,:) = DIST(1,:) - U;
   DIST(2,:) = DIST(2,:) - V;
   i         = sqrt(-1);
   DIST      = abs(DIST(1,:) + i*DIST(2,:));
   AUX       = min(DIST);
   J         = find(DIST == AUX);
   KNOTEN(1:2,J) = [U; V];
   X         = KNOTEN(1,:);
   Y         = KNOTEN(2,:);
   Z         = zeros(1,size(KNOTEN,2));
   clf
   axis([xmin xmax ymin ymax]);
   grid on
   hold on
   trimesh(ELEMENTE',X,Y,Z);
   hold on
   plot(X,Y,'.','MarkerSize',6);
end
grid off
