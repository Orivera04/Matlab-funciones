[X,Y,Z] = peaks;
[C,h] = contour(X,Y,Z,8); % ask for fewer contours
clabel(C,h)
title('Figure 26.25: Contour Plot With In-line Labels')