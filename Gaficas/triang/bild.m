function bild(KNOTEN,RAND,ELEMENTE)
% GEKELER: FINITE ELEMENTE----
% Zeichnet  Triangulierung----

% -- Rand am Anfang, damit ein flaches Bild entsteht
for I = 1:size(RAND,2)
    plot(KNOTEN(1,RAND(:,I)),KNOTEN(2,RAND(:,I)),'r')
    hold on
end
Z = zeros(1,size(KNOTEN,2));
trimesh(ELEMENTE(1:3,:)',KNOTEN(1,:),KNOTEN(2,:),Z);
hold on
plot(KNOTEN(1,:),KNOTEN(2,:),'.','MarkerSize',6);
hold on
for I = 1:size(RAND,2)
    plot(KNOTEN(1,RAND(:,I)),KNOTEN(2,RAND(:,I)),'r')
    hold on
end
