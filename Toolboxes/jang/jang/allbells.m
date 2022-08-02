% Illustration of different generalized bell MFs
% J.-S. Roger Jang, 1993

x = (-10:0.4:10)';

b = 2;
c = 0;
mf1 = gbell_mf(x, [2, b, c]); 
mf2 = gbell_mf(x, [4, b, c]); 
mf3 = gbell_mf(x, [6, b, c]); 
mf = [mf1 mf2 mf3];
subplot(221); plot(x, mf); title('(a) Changing ''a''');
axis([-inf inf 0 1.2]);

a = 5;
c = 0;
mf1 = gbell_mf(x, [a, 1, c]); 
mf2 = gbell_mf(x, [a, 2, c]); 
mf3 = gbell_mf(x, [a, 4, c]); 
mf = [mf1 mf2 mf3];
subplot(222); plot(x, mf); title('(b) Changing ''b''');
axis([-inf inf 0 1.2]);

a = 5;
b = 2;
mf1 = gbell_mf(x, [a, b, -5]); 
mf2 = gbell_mf(x, [a, b, 0]); 
mf3 = gbell_mf(x, [a, b, 5]); 
mf = [mf1 mf2 mf3];
subplot(223); plot(x, mf); title('(c) Changing ''c''');
axis([-inf inf 0 1.2]);

c = 0;
mf1 = gbell_mf(x, [4, 4, c]); 
mf2 = gbell_mf(x, [6, 6, c]); 
mf3 = gbell_mf(x, [8, 8, c]); 
mf = [mf1 mf2 mf3];
subplot(224); plot(x, mf); title('(d) Changing ''a'' and ''b''');
axis([-inf inf 0 1.2]);
