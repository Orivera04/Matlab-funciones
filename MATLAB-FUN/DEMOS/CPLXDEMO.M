%CPLXDEMO Maps of functions of a complex variable.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

disp(' ')
disp(' ')
disp('Functions of a complex variable, f(z).')
disp('The domain is the unit disc, displayed in polar coordinates.')
disp('The height of the surface is the real part, real(f(z)).')
disp('The color of the surface is the imaginary part, imag(f(z)).')
disp('The color map varies the hue in the HSV color model.')
disp('There is a pause after each function; hit return to continue.')
disp(' ')

clf reset
colormap(hsv(64))
z = cplxgrid(30);

cplxmap(z,z)
title('z')
disp('f(z) = z.')
disp(' '), pause

disp('f(z) = z^3.  Three maxima at the cube roots of 1.')
cplxmap(z,z.^3)
title('z^3')
disp(' '), pause

disp('f(z) = (z^4-1)^(1/4).  Four zeros at the fourth roots of 1.')
cplxmap(z,(z.^4-1).^(1/4));
title('(z^4-1)^(1/4)')
disp(' '), pause

disp('f(z) = 1/z.  A simple pole at the origin.')
cplxmap(z,1./(z+eps*(abs(z)==0)),5*pi)
title('1/z')
disp(' '), pause

disp('f(z) = atan(2*z).  Branch cut singularities at +-i/2. ')
cplxmap(z,atan(2*z),1.9)
title('atan(2*z)')
disp(' '), pause

disp('f(z) = z^1/2.  Viewed from the negative imaginary axis.')
axis('auto')
cplxroot(2)
view(0,0)
title('sqrt(z)')
disp(' '), pause

disp('f(z) = z^1/2.  Another view.  The Riemann surface for the square root.')
view(-37.5,30)
cplxroot(2)
title('sqrt(z)')
disp(' '), pause

disp('f(z) = z^1/3.  The Riemann surface for the cube root.')
cplxroot(3)
title('z^(1/3)')
disp(' '), pause

spinmap

disp('End')
