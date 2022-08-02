function [KNOTEN,RAND,ELEMENTE] = mesh01(KNOTEN,RAND,ELEMENTE);
% Gekeler: Finite Elemente
% verschiebt Knoten in das Zentrum des umgebenden Polygons
% Durchlauf in aufsteigender dann absteigender Numerierung
% fuer Dreiecke und Vierecke

ITER = 2;   % Anzahl der Durchlaeufe
KNOTEN  = [KNOTEN; zeros(1,size(KNOTEN,2))];
for I = 1:size(RAND,2)
    KNOTEN(3,RAND(1,I)) = 1;
end
[M,N]       = size(ELEMENTE);
IND         = find(KNOTEN(3,:) == 0);
for I1 = 1:ITER
for K = 1:length(IND)
   ELEMENTE = [ELEMENTE; [1:N]];
   for L = 1:N
      if any(ELEMENTE(1:M,L) == IND(K))
         ELEMENTE(M+1,L) = 0;
      end
   end
   J        = find(ELEMENTE(M+1,:) == 0);
   NEIGHBOR = [];
   for L = 1:length(J)
         NEIGHBOR = [NEIGHBOR; ELEMENTE(1:M,J(L))];
   end
   for I = 1:length(NEIGHBOR)
      for L = 1:I-1
         if NEIGHBOR(L) == NEIGHBOR(I)
            NEIGHBOR(I) = 0;
         end
      end
   end
   J        = find(NEIGHBOR ~= 0);
   NEIGHBOR = NEIGHBOR(J);
   P        = length(NEIGHBOR);
   KNOTEN(1,IND(K)) = sum(KNOTEN(1,NEIGHBOR))/P;
   KNOTEN(2,IND(K)) = sum(KNOTEN(2,NEIGHBOR))/P;
   ELEMENTE = ELEMENTE(1:M,:);
   KNOTEN   = KNOTEN(1:2,:);
end
   IND      = fliplr(IND);
end
