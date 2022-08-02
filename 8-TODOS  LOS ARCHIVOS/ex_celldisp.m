s1.a = 1; s1.b = 'zz';
s2.a = 26; s2.b = 'aa';  
x = { 'H20', 0, [4, 5] s1; 'CH3OH' 1, [6; 7] s2};
celldisp(x, 'y')
cellplot(x, 'legend')
colormap(gray)
brighten(gcf, 0.75)