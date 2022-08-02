%	Example of composite linguistic values.  

%	Copyright by Jyh-Shing Roger Jang, 6-2-93.
%	(Tested on Matlab version 4.0a, HP workstation)
%	(Tested on Matlab version 3.5e, DEC 5000)

x = (0:100)';
young = gbell_mf(x, [20, 2, 0]); 
old = gbell_mf(x, [30, 3, 100]);
subplot(211);
plot(x, [young old]); xlabel('X = age'); ylabel('Membership Grades');
axis([-inf inf 0 1.1]);
title('(a) Primary Linguistic Values');
text(68, 0.8, 'Old')
text(20, 0.8, 'Young')

more_or_less_old = old.^0.5;
not_young_and_not_old = min(1-young, 1-old);
young_but_not_too_young = min(young, 1-young.^2);
extremely_old = old.^8;
all = [more_or_less_old not_young_and_not_old ...
       young_but_not_too_young extremely_old];

subplot(212);
plot(x, all); xlabel('X = age'); ylabel('Membership Grades');
axis([-inf inf 0 1.1]);
title('(b) Composite Linguistic Values');
text(33, 0.80, 'Not Young and Not Old')
text(42, 0.30, 'More or Less Old')
text(75, 0.50, 'Extremely Old')
text(3, 0.65, 'Young but')
text(1, 0.55, 'Not Too Young')
