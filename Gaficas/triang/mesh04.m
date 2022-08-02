function ELEMENTE = mesh04(KNOTEN,RAND,ELEMENTE);
% eliminiert ELEMENTE ausserhalb des
% einfach zusammenhaengenden, nicht konvexen Gebietes
% nach einer DELAUNAY-Triangulierung

M        = size(KNOTEN,2);
N        = size(ELEMENTE,2);
KNOTEN   = [KNOTEN;zeros(1,M)];
ELEMENTE = [ELEMENTE;zeros(1,N)];
for I = 1:M
   if ismember(I,RAND(1,:))
      KNOTEN(3,I) = 1;
   end
end
for I = 1:N
   ELEMENTE(4,I) = sum(KNOTEN(3,ELEMENTE(1:3,I)));
end
XV = KNOTEN(1,[RAND(1,:),RAND(1,1)]);
YV = KNOTEN(2,[RAND(1,:),RAND(1,1)]);
P        = find(ELEMENTE(4,:) == 3);
RICHTUNG = zeros(1,length(P));
for I = 1:length(P)
   J = ELEMENTE(1:3,P(I));
   X = KNOTEN(1,J);
   Y = KNOTEN(2,J);
   ZX = sum(X)/3;
   ZY = sum(Y)/3;
   RICHTUNG(I) = inpolygon(ZX,ZY,XV,YV);
end
J        = find(RICHTUNG == 0);
P        = P(J);
INDEX    = [1:N];
INDEX(P) = 0;
J        = find(INDEX ~= 0);
INDEX    = INDEX(J);
ELEMENTE = ELEMENTE(1:3,INDEX);
