%	Examples of linguistic variables and linguistic values

%	Copyright by Jyh-Shing Roger Jang, 6-2-93.

x = (0:100)';

young = gbell_mf(x, [20, 2, 0]); 
middle_aged = gbell_mf(x, [25, 3, 45]); 
old = gbell_mf(x, [30, 3, 100]);
very_old = old.^2;
very_young = young.^2;

all = [young middle_aged old very_young very_old];

subplot(211);
plot(x, all, '-'); xlabel('X = age'); ylabel('Membership Grades');
axis([-inf inf 0 1.1]);
text(72, 0.80, 'Old')
text(79, 0.70, 'Very')
text(79.5, 0.60, 'Old')
text(14, 0.90, 'Young')
text(8.5, 0.65, 'Very')
text(8, 0.55, 'Young')
text(40, 0.90, 'Middle Aged')
