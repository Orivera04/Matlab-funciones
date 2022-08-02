% L3_5. See Example 3.9.  Copyright S. Nakamura, 1995
clear
a = [ 1.3340e-04  4.1230e+01  7.9120e+02 -1.5440e+03;
      1.7770e+00  2.3670e-05  2.0700e+01 -9.0350e+01;
      9.1880e+00           0 -1.0150e+01  1.9880e-04;
      1.0020e+02  1.4420e+04 -7.0140e+02  5.3210e+00]
y=sum(a')';
format long e
x=a\y
format short
