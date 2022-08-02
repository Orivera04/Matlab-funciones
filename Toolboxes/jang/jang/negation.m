% Illustration of negation in fuzzy sets.
% J.-S. Roger Jang, 1993

a = (0:0.02:1)';

s =   20; c1 = (1-a)./(1+s*a);
s =    2; c2 = (1-a)./(1+s*a);
s =    0; c3 = (1-a)./(1+s*a);
s = -0.7; c4 = (1-a)./(1+s*a);
s = -0.95; c5 = (1-a)./(1+s*a);
complement_all = [c1 c2 c3 c4 c5];
subplot(221);
plot(a, complement_all);
axis('square');
title('(a) Sugeno''s Complements');
xlabel('X = a');
ylabel('N(a)');
text(0.1, 0.1, 's = 20');
text(0.3, 0.3, 's = 2');
text(0.5, 0.5, 's = 0');
text(0.6, 0.7, 's = -0.7');
text(0.7, 0.9, 's = -0.95');

w = 0.4; c1 = (1-a.^w).^(1/w);
w = 0.7; c2 = (1-a.^w).^(1/w);
w =   1; c3 = (1-a.^w).^(1/w);
w = 1.5; c4 = (1-a.^w).^(1/w);
w =   3; c5 = (1-a.^w).^(1/w);
complement_all = [c1 c2 c3 c4 c5];
subplot(222);
plot(a, complement_all);
axis('square');
title('(b) Yager''s Complements');
xlabel('X = a');
ylabel('N(a)');
text(0.1, 0.1, 'w = 0.4');
text(0.3, 0.3, 'w = 0.7');
%text(0.5, 0.5, 'w = 1');
text(0.5, 0.5, 'w = 1');
text(0.6, 0.7, 'w = 1.5');
text(0.7, 0.9, 'w = 3');
