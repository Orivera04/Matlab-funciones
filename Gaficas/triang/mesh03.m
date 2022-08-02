function ELEMENTE = mesh03(KNOTEN,RAND,ELEMENTE);
% GEKELER: FINITE ELEMENTE ---------
% gemeinsame lange Kanten zweier Dreiecke
% werden durch kurze ersetzt

TOL           = 1.0e-03;
N             = size(KNOTEN,2);
M             = size(ELEMENTE,2);
EL1           = [ELEMENTE; ELEMENTE(1:2,:)];
AUX           = zeros(3,M);
for I = 1:M
   LX         = KNOTEN(1,EL1([2:4],I)) - KNOTEN(1,EL1(1:3,I));
   LY         = KNOTEN(2,EL1([2:4],I)) - KNOTEN(2,EL1(1:3,I));
   C          = sqrt(LX.*LX + LY.*LY);
   J          = min(find(C == max(C)));
   AUX(1:2,I) = [I;C(J)];
   ELEMENTE(:,I) = EL1(J:J+2,I);  % Erste Kante ist laengste
end
bild(KNOTEN,RAND,ELEMENTE)

for I = 2:M
   for K = 1:I-1
      if ismember(ELEMENTE(1,I),ELEMENTE(1:2,K)) &...
         ismember(ELEMENTE(2,I),ELEMENTE(1:2,K)) &...
         abs(AUX(2,I) - AUX(2,K)) < TOL
         % ELEMENTE "I" und "K" haben gemeinsame laengste Kante
         Q = [ELEMENTE(3,I), ELEMENTE(3,K)];
         LX = KNOTEN(1,Q(1)) - KNOTEN(1,Q(2));
         LY = KNOTEN(2,Q(1)) - KNOTEN(2,Q(2));
         D  = sqrt(LX.*LX + LY.*LY);
         if D < AUX(2,I) - TOL
            AUX(3,I) = K;
         end
      end
   end
end
pause
grafik = 1;
if grafik == 1
   clf
   bild(KNOTEN,RAND,ELEMENTE)
   for I = 1:M
      if AUX(3,I) ~= 0
         P  = ELEMENTE(1:2,I);
         Q  = [ELEMENTE(3,I);ELEMENTE(3,AUX(3,I))];
         plot(KNOTEN(1,P),KNOTEN(2,P),'k');
         hold on
         plot(KNOTEN(1,Q),KNOTEN(2,Q),'--k');
         hold on
      end
   end
end
pause
hold off
for I = 1:M
   if AUX(3,I) ~= 0
      K = AUX(3,I);
      ELEMENTE(:,I) = [ELEMENTE(3,I);ELEMENTE(1,I);ELEMENTE(3,K)];
      ELEMENTE(:,K) = [ELEMENTE(3,K);ELEMENTE(2,I);ELEMENTE(3,I)];
   end
end
