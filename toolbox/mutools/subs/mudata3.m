% ABOUT MUSYNDEMO3:
%
% This demo provides a MIMO closed loop control system designed
% by using Mu-Tools. Use the pulldown menus to run
% the simulation. Double-click the blocks on the bottom for
% more functions.
%
% All of the parameters are read in from MATLAB workspace
% variables. The plant model is [a,b,c,d]. The input and output
% weighting functions are:
% [ wi1(s)   0  ]   [wo1(s)   0  ] respectively, where:
% [  0    wi2(s)];  [ 0    wo2(s)]
%
%          num_i1(s)              num_i2(s)
% w1(s) = ----------;   wi2(s) = ----------.
%          den_i1(s)              den_i2(s)
%
% The designed controller is given by [ak,bk,ck,dk]. During the
% simulation system perturbation and measurement noise are added.
%
% By changing the plant and the weighting function parameters, you
% can convert the example to solve a problem of your own.
%
% Re-Load Data
% Re-load data from file. This refreshes the data in the workspace.
%
% Re-Design
% After changing the workspace parameters, you should redesign the
% controller to fit your data.
%
% The following functions in MuSyn are used:
% sysic     --- system interconnection
% hinfsyn   --- H_infinity controller design
% mu        --- Mu analysis
% musynfit  --- curve fitting
% mmult     --- system multiplication
%
% Two SISO examples are given in musyndm1 and musyndm2.
%

%   Copyright 1991-2004 MUSYN Inc. and The MathWorks, Inc.
%   $Revision: 1.7.2.3 $

% Data file of mu-synthesis demo1 for SIMULINK
% [a b c d] for plant
% [ak bk ck dk] for controller
% [num den] for weighting
% g1 and k1 are closed loop system and controller system matrix
%

disp('Loading data');
a = [
  -2.2600e-02  -3.6600e+01  -1.8900e+01  -3.2100e+01
            0  -1.9000e+00   9.8300e-01            0
   1.2300e-02  -1.1700e+01  -2.6300e+00            0
            0            0   1.0000e+00            0];
b = [       0            0
  -4.1400e-01            0
  -7.7800e+01   2.2400e+01
            0            0 ];
c = [       0   5.7300e+01            0            0
            0            0            0   5.7300e+01];
d =[ 0     0
     0     0];
tmp1 = [
  -3.4099e-02  -2.0067e-03   6.5488e-02   1.0555e-01  -6.0522e-01  -6.2559e-02
  -2.1085e-04  -3.2805e-02   4.0256e+00   5.7643e-01   1.7385e+00  -2.2096e+00
  -1.8617e+00   3.3129e+00  -7.9847e+02  -6.9086e+02  -6.7781e+02   8.2340e+02
  -3.1998e-01  -4.6007e-01   6.2912e+02  -1.0313e+01  -5.4126e+01   8.5207e+01
  -4.2821e-01  -1.8486e+00   5.6614e+02  -5.5724e+01  -7.0614e+02   1.1138e+03
  -6.0960e-01   2.0714e+00  -8.2062e+02   2.4577e+01   5.0003e+02  -1.2733e+03
   9.1619e-01  -1.6138e+00   7.1983e+02  -3.6653e+00  -2.1145e+02   9.6092e+02
  -8.8412e-02   4.1243e-01  -1.4845e+02   7.4513e+00   1.7903e+02  -3.2784e+02
   1.0721e+00   6.9571e-02   1.8718e+02   3.9738e+01   4.5878e+02   1.7535e+02
  -2.1040e-02   1.3837e-02  -8.2479e+00  -3.4761e-01   2.5982e+00  -2.0069e+01
  -2.1530e-01   1.8773e-01  -9.8204e+01  -2.2321e+00   6.2793e+01  -2.5723e+02
  -7.0102e-02   1.6186e-01  -6.2015e+01   2.2087e+00   9.6096e+01  -1.9839e+02
   1.9801e-02  -6.6496e-02   2.3744e+01  -1.2195e+00  -4.2862e+01   7.8919e+01
   7.6094e-03   5.6376e-03  -2.5531e-01   4.2300e-01   6.0548e+00  -3.0430e+00
   1.8129e-04  -1.5759e-02   4.7424e+00  -4.5095e-01  -1.1708e+01   1.7913e+01
   1.8032e-01   1.4912e-01  -1.1045e+01   1.0394e+01   1.5033e+02  -7.6898e+01
];
tmp2=[
   2.4468e-01   6.3801e-02  -4.6503e-01  -4.8630e-04  -4.3850e-02  -3.2760e-02
   1.9488e+00  -4.1852e-01   1.1023e+00  -2.8463e-02  -3.1498e-01  -1.8073e-01
  -7.1107e+02   1.5082e+02  -3.9103e+02   9.6884e+00   1.0580e+02   5.9906e+01
  -7.9500e+01   1.5993e+01  -4.4135e+01   1.1811e+00   1.3224e+01   7.5714e+00
  -1.1103e+03   2.4038e+02  -1.0253e+03   1.9467e+01   1.9670e+02   1.0886e+02
   1.4190e+03  -3.0711e+02   1.2665e+03  -2.9841e+01  -3.2704e+02  -1.9684e+02
  -1.1618e+03   2.9805e+02  -1.1119e+03   2.8699e+01   3.2322e+02   2.0169e+02
   2.9190e+02  -8.8827e+01   5.4230e+02  -1.0041e+01  -1.0304e+02  -6.1443e+01
  -5.2963e+02  -9.6507e+01  -2.0285e+03   6.2428e+01   5.9450e+02   4.4464e+02
   2.4782e+01  -4.9728e+00   2.2657e+01  -1.1861e+00  -1.3195e+01  -1.1612e+01
   2.9858e+02  -7.2140e+01   3.0429e+02  -1.3979e+01  -1.5867e+02  -1.3505e+02
   2.0002e+02  -6.5942e+01   7.1136e+01  -7.6095e+00  -9.9935e+01  -1.0988e+02
  -7.6576e+01   2.7383e+01  -3.2169e+01   2.9940e+00   3.8594e+01   1.1352e+02
   2.3143e-02  -1.5941e+00  -2.5440e+01   2.4234e-01   1.4531e+00  -8.7931e+00
  -1.6179e+01   6.6496e+00  -3.3317e+00   7.7092e-01   1.0763e+01   1.9950e+01
   1.0431e+00  -3.6913e+01  -6.9221e+02   9.4368e+00   8.5960e+01  -2.2965e+01
];
tmp3=[
   3.6580e-02   2.2193e-03   1.1129e-02  -2.0999e-01
   5.8465e-02   1.0122e-02  -8.5159e-03  -7.8677e-02
  -1.8463e+01  -3.3117e+00   3.2439e+00   1.8809e+01
  -2.5840e+00  -4.3134e-01   2.9149e-01   4.3608e+00
  -2.4780e+01  -6.4904e+00   1.0396e+01  -2.4999e+01
   6.2814e+01   1.2108e+01  -1.0411e+01  -9.2767e+01
  -6.8809e+01  -1.2466e+01   8.6744e+00   1.2916e+02
   1.6466e+01   4.0887e+00  -4.9306e+00  -1.0201e+01
  -9.5010e+01  -2.1150e+01   4.5003e+01  -1.0128e+02
   3.5439e+00   7.9244e-01  -8.1123e-01  -6.8289e+00
   4.5377e+01   1.0021e+01  -8.0372e+00  -1.1419e+02
  -3.0613e+01   1.6541e+01  -1.2100e+01  -1.3955e+02
  -1.7357e+01  -6.8889e+00   1.6736e+00   9.6150e+01
   4.4737e+00  -7.5359e-01   2.7919e-01   3.1757e+01
  -7.7540e+00   1.0249e+00  -3.4293e+00   5.1969e+01
   1.9289e+01  -4.5934e+01   3.1770e+01  -1.5810e+03];
ak=[tmp1,tmp2,tmp3];
bk = [
  -8.5071e-01   4.3457e-01
   3.3895e-01   7.1398e-01
  -4.6381e+01  -3.3782e+01
  -1.9301e+00   5.6540e+00
   4.1636e+00   2.1823e+01
  -1.8753e+01  -1.7902e+01
   2.0240e+01   1.1280e+01
  -3.3365e+00  -3.8305e+00
   1.3131e+01  -7.2473e+00
  -3.4143e-01  -2.0461e-02
  -3.7483e+00  -7.0358e-01
  -1.7732e+00  -1.3110e+00
   6.1523e-01   5.9291e-01
   6.5383e-02  -1.0636e-01
   8.8769e-02   1.6806e-01
   1.4648e+00  -2.6835e+00];
tmp1 = [
  -3.4706e-01   7.2483e-01  -5.4507e+01  -5.1763e+00  -2.2208e+01   2.3755e+01
  -8.9001e-01  -3.1507e-01   1.7927e+01   2.9831e+00  -6.0757e-01  -1.0385e+01
];
tmp2 = [
  -1.9992e+01   4.9810e+00  -1.4959e+01   3.1571e-01   3.2783e+00   1.8419e+00
   1.1712e+01  -9.9753e-01  -1.0916e+00  -1.3159e-01  -1.9487e+00  -1.2125e+00
];
tmp3 = [
  -4.5040e-01  -1.0131e-01   1.5793e-01  -2.9013e-01
   7.2607e-01   7.2962e-02   1.0574e-01  -3.0434e+00];
ck = [tmp1, tmp2, tmp3];
dk =[0     0
     0     0];
num_i1 = [  50        5000];
den_i1 = [   1       10000];
num_i2 = [  50        5000];
den_i2 = [   1       10000];
num_o1 = [
   5.0000e-01   1.5000e+00];
den_o1 = [
   1.0000e+00   3.0000e-02];
num_o2 = [
   5.0000e-01   1.5000e+00];
den_o2 = [
   1.0000e+00   3.0000e-02];
tmp1 = [
  -3.4099e-02  -2.0067e-03   6.5488e-02   1.0555e-01  -6.0522e-01  -6.2559e-02
  -2.1085e-04  -3.2805e-02   4.0256e+00   5.7643e-01   1.7385e+00  -2.2096e+00
  -1.8617e+00   3.3129e+00  -7.9847e+02  -6.9086e+02  -6.7781e+02   8.2340e+02
  -3.1998e-01  -4.6007e-01   6.2912e+02  -1.0313e+01  -5.4126e+01   8.5207e+01
  -4.2821e-01  -1.8486e+00   5.6614e+02  -5.5724e+01  -7.0614e+02   1.1138e+03
  -6.0960e-01   2.0714e+00  -8.2062e+02   2.4577e+01   5.0003e+02  -1.2733e+03
   9.1619e-01  -1.6138e+00   7.1983e+02  -3.6653e+00  -2.1145e+02   9.6092e+02
  -8.8412e-02   4.1243e-01  -1.4845e+02   7.4513e+00   1.7903e+02  -3.2784e+02
   1.0721e+00   6.9571e-02   1.8718e+02   3.9738e+01   4.5878e+02   1.7535e+02
  -2.1040e-02   1.3837e-02  -8.2479e+00  -3.4761e-01   2.5982e+00  -2.0069e+01
  -2.1530e-01   1.8773e-01  -9.8204e+01  -2.2321e+00   6.2793e+01  -2.5723e+02
  -7.0102e-02   1.6186e-01  -6.2015e+01   2.2087e+00   9.6096e+01  -1.9839e+02
   1.9801e-02  -6.6496e-02   2.3744e+01  -1.2195e+00  -4.2862e+01   7.8919e+01
   7.6094e-03   5.6376e-03  -2.5531e-01   4.2300e-01   6.0548e+00  -3.0430e+00
   1.8129e-04  -1.5759e-02   4.7424e+00  -4.5095e-01  -1.1708e+01   1.7913e+01
   1.8032e-01   1.4912e-01  -1.1045e+01   1.0394e+01   1.5033e+02  -7.6898e+01
  -3.4706e-01   7.2483e-01  -5.4507e+01  -5.1763e+00  -2.2208e+01   2.3755e+01
  -8.9001e-01  -3.1507e-01   1.7927e+01   2.9831e+00  -6.0757e-01  -1.0385e+01
            0            0            0            0            0            0
];
tmp2 = [
   2.4468e-01   6.3801e-02  -4.6503e-01  -4.8630e-04  -4.3850e-02  -3.2760e-02
   1.9488e+00  -4.1852e-01   1.1023e+00  -2.8463e-02  -3.1498e-01  -1.8073e-01
  -7.1107e+02   1.5082e+02  -3.9103e+02   9.6884e+00   1.0580e+02   5.9906e+01
  -7.9500e+01   1.5993e+01  -4.4135e+01   1.1811e+00   1.3224e+01   7.5714e+00
  -1.1103e+03   2.4038e+02  -1.0253e+03   1.9467e+01   1.9670e+02   1.0886e+02
   1.4190e+03  -3.0711e+02   1.2665e+03  -2.9841e+01  -3.2704e+02  -1.9684e+02
  -1.1618e+03   2.9805e+02  -1.1119e+03   2.8699e+01   3.2322e+02   2.0169e+02
   2.9190e+02  -8.8827e+01   5.4230e+02  -1.0041e+01  -1.0304e+02  -6.1443e+01
  -5.2963e+02  -9.6507e+01  -2.0285e+03   6.2428e+01   5.9450e+02   4.4464e+02
   2.4782e+01  -4.9728e+00   2.2657e+01  -1.1861e+00  -1.3195e+01  -1.1612e+01
   2.9858e+02  -7.2140e+01   3.0429e+02  -1.3979e+01  -1.5867e+02  -1.3505e+02
   2.0002e+02  -6.5942e+01   7.1136e+01  -7.6095e+00  -9.9935e+01  -1.0988e+02
  -7.6576e+01   2.7383e+01  -3.2169e+01   2.9940e+00   3.8594e+01   1.1352e+02
   2.3143e-02  -1.5941e+00  -2.5440e+01   2.4234e-01   1.4531e+00  -8.7931e+00
  -1.6179e+01   6.6496e+00  -3.3317e+00   7.7092e-01   1.0763e+01   1.9950e+01
   1.0431e+00  -3.6913e+01  -6.9221e+02   9.4368e+00   8.5960e+01  -2.2965e+01
  -1.9992e+01   4.9810e+00  -1.4959e+01   3.1571e-01   3.2783e+00   1.8419e+00
   1.1712e+01  -9.9753e-01  -1.0916e+00  -1.3159e-01  -1.9487e+00  -1.2125e+00
            0            0            0            0            0            0
];
tmp3 = [
   3.6580e-02   2.2193e-03   1.1129e-02  -2.0999e-01  -8.5071e-01   4.3457e-01
   5.8465e-02   1.0122e-02  -8.5159e-03  -7.8677e-02   3.3895e-01   7.1398e-01
  -1.8463e+01  -3.3117e+00   3.2439e+00   1.8809e+01  -4.6381e+01  -3.3782e+01
  -2.5840e+00  -4.3134e-01   2.9149e-01   4.3608e+00  -1.9301e+00   5.6540e+00
  -2.4780e+01  -6.4904e+00   1.0396e+01  -2.4999e+01   4.1636e+00   2.1823e+01
   6.2814e+01   1.2108e+01  -1.0411e+01  -9.2767e+01  -1.8753e+01  -1.7902e+01
  -6.8809e+01  -1.2466e+01   8.6744e+00   1.2916e+02   2.0240e+01   1.1280e+01
   1.6466e+01   4.0887e+00  -4.9306e+00  -1.0201e+01  -3.3365e+00  -3.8305e+00
  -9.5010e+01  -2.1150e+01   4.5003e+01  -1.0128e+02   1.3131e+01  -7.2473e+00
   3.5439e+00   7.9244e-01  -8.1123e-01  -6.8289e+00  -3.4143e-01  -2.0461e-02
   4.5377e+01   1.0021e+01  -8.0372e+00  -1.1419e+02  -3.7483e+00  -7.0358e-01
  -3.0613e+01   1.6541e+01  -1.2100e+01  -1.3955e+02  -1.7732e+00  -1.3110e+00
  -1.7357e+01  -6.8889e+00   1.6736e+00   9.6150e+01   6.1523e-01   5.9291e-01
   4.4737e+00  -7.5359e-01   2.7919e-01   3.1757e+01   6.5383e-02  -1.0636e-01
  -7.7540e+00   1.0249e+00  -3.4293e+00   5.1969e+01   8.8769e-02   1.6806e-01
   1.9289e+01  -4.5934e+01   3.1770e+01  -1.5810e+03   1.4648e+00  -2.6835e+00
  -4.5040e-01  -1.0131e-01   1.5793e-01  -2.9013e-01            0            0
   7.2607e-01   7.2962e-02   1.0574e-01  -3.0434e+00            0            0
            0            0            0            0            0            0
];
k1 = [
   1.6000e+01
            0
            0
            0
            0
            0
            0
            0
            0
            0
            0
            0
            0
            0
            0
            0
            0
            0
         -Inf];
k1 = [tmp1, tmp2, tmp3, k1];
tmp1 = [
  -3.4099e-02  -2.0067e-03   6.5488e-02   1.0555e-01  -6.0522e-01  -6.2559e-02
  -2.1085e-04  -3.2805e-02   4.0256e+00   5.7643e-01   1.7385e+00  -2.2096e+00
  -1.8617e+00   3.3129e+00  -7.9847e+02  -6.9086e+02  -6.7781e+02   8.2340e+02
  -3.1998e-01  -4.6007e-01   6.2912e+02  -1.0313e+01  -5.4126e+01   8.5207e+01
  -4.2821e-01  -1.8486e+00   5.6614e+02  -5.5724e+01  -7.0614e+02   1.1138e+03
  -6.0960e-01   2.0714e+00  -8.2062e+02   2.4577e+01   5.0003e+02  -1.2733e+03
   9.1619e-01  -1.6138e+00   7.1983e+02  -3.6653e+00  -2.1145e+02   9.6092e+02
  -8.8412e-02   4.1243e-01  -1.4845e+02   7.4513e+00   1.7903e+02  -3.2784e+02
   1.0721e+00   6.9571e-02   1.8718e+02   3.9738e+01   4.5878e+02   1.7535e+02
  -2.1040e-02   1.3837e-02  -8.2479e+00  -3.4761e-01   2.5982e+00  -2.0069e+01
  -2.1530e-01   1.8773e-01  -9.8204e+01  -2.2321e+00   6.2793e+01  -2.5723e+02
  -7.0102e-02   1.6186e-01  -6.2015e+01   2.2087e+00   9.6096e+01  -1.9839e+02
   1.9801e-02  -6.6496e-02   2.3744e+01  -1.2195e+00  -4.2862e+01   7.8919e+01
   7.6094e-03   5.6376e-03  -2.5531e-01   4.2300e-01   6.0548e+00  -3.0430e+00
   1.8129e-04  -1.5759e-02   4.7424e+00  -4.5095e-01  -1.1708e+01   1.7913e+01
   1.8032e-01   1.4912e-01  -1.1045e+01   1.0394e+01   1.5033e+02  -7.6898e+01
            0            0            0            0            0            0
   1.4368e-01  -3.0008e-01   2.2566e+01   2.1430e+00   9.1940e+00  -9.8346e+00
   7.0648e+00  -6.3450e+01   4.6422e+03   4.6953e+02   1.7142e+03  -2.0808e+03
            0            0            0            0            0            0
            0            0            0            0            0            0
            0            0            0            0            0            0
            0            0            0            0            0            0
];
tmp2 = [
   2.4468e-01   6.3801e-02  -4.6503e-01  -4.8630e-04  -4.3850e-02  -3.2760e-02
   1.9488e+00  -4.1852e-01   1.1023e+00  -2.8463e-02  -3.1498e-01  -1.8073e-01
  -7.1107e+02   1.5082e+02  -3.9103e+02   9.6884e+00   1.0580e+02   5.9906e+01
  -7.9500e+01   1.5993e+01  -4.4135e+01   1.1811e+00   1.3224e+01   7.5714e+00
  -1.1103e+03   2.4038e+02  -1.0253e+03   1.9467e+01   1.9670e+02   1.0886e+02
   1.4190e+03  -3.0711e+02   1.2665e+03  -2.9841e+01  -3.2704e+02  -1.9684e+02
  -1.1618e+03   2.9805e+02  -1.1119e+03   2.8699e+01   3.2322e+02   2.0169e+02
   2.9190e+02  -8.8827e+01   5.4230e+02  -1.0041e+01  -1.0304e+02  -6.1443e+01
  -5.2963e+02  -9.6507e+01  -2.0285e+03   6.2428e+01   5.9450e+02   4.4464e+02
   2.4782e+01  -4.9728e+00   2.2657e+01  -1.1861e+00  -1.3195e+01  -1.1612e+01
   2.9858e+02  -7.2140e+01   3.0429e+02  -1.3979e+01  -1.5867e+02  -1.3505e+02
   2.0002e+02  -6.5942e+01   7.1136e+01  -7.6095e+00  -9.9935e+01  -1.0988e+02
  -7.6576e+01   2.7383e+01  -3.2169e+01   2.9940e+00   3.8594e+01   1.1352e+02
   2.3143e-02  -1.5941e+00  -2.5440e+01   2.4234e-01   1.4531e+00  -8.7931e+00
  -1.6179e+01   6.6496e+00  -3.3317e+00   7.7092e-01   1.0763e+01   1.9950e+01
   1.0431e+00  -3.6913e+01  -6.9221e+02   9.4368e+00   8.5960e+01  -2.2965e+01
            0            0            0            0            0            0
   8.2768e+00  -2.0621e+00   6.1930e+00  -1.3071e-01  -1.3572e+00  -7.6256e-01
   1.8178e+03  -4.0987e+02   1.1393e+03  -2.7510e+01  -2.9870e+02  -1.7046e+02
            0            0            0            0            0            0
            0            0            0            0            0            0
            0            0            0            0            0            0
            0            0            0            0            0            0
];
tmp3 = [
   3.6580e-02   2.2193e-03   1.1129e-02  -2.0999e-01            0  -4.8746e+01
   5.8465e-02   1.0122e-02  -8.5159e-03  -7.8677e-02            0   1.9422e+01
  -1.8463e+01  -3.3117e+00   3.2439e+00   1.8809e+01            0  -2.6576e+03
  -2.5840e+00  -4.3134e-01   2.9149e-01   4.3608e+00            0  -1.1060e+02
  -2.4780e+01  -6.4904e+00   1.0396e+01  -2.4999e+01            0   2.3857e+02
   6.2814e+01   1.2108e+01  -1.0411e+01  -9.2767e+01            0  -1.0745e+03
  -6.8809e+01  -1.2466e+01   8.6744e+00   1.2916e+02            0   1.1597e+03
   1.6466e+01   4.0887e+00  -4.9306e+00  -1.0201e+01            0  -1.9118e+02
  -9.5010e+01  -2.1150e+01   4.5003e+01  -1.0128e+02            0   7.5243e+02
   3.5439e+00   7.9244e-01  -8.1123e-01  -6.8289e+00            0  -1.9564e+01
   4.5377e+01   1.0021e+01  -8.0372e+00  -1.1419e+02            0  -2.1478e+02
  -3.0613e+01   1.6541e+01  -1.2100e+01  -1.3955e+02            0  -1.0160e+02
  -1.7357e+01  -6.8889e+00   1.6736e+00   9.6150e+01            0   3.5252e+01
   4.4737e+00  -7.5359e-01   2.7919e-01   3.1757e+01            0   3.7465e+00
  -7.7540e+00   1.0249e+00  -3.4293e+00   5.1969e+01            0   5.0865e+00
   1.9289e+01  -4.5934e+01   3.1770e+01  -1.5810e+03            0   8.3932e+01
            0            0            0            0  -2.2600e-02  -3.6600e+01
   1.8646e-01   4.1944e-02  -6.5384e-02   1.2011e-01            0  -1.9000e+00
   5.1305e+01   9.5165e+00  -9.9186e+00  -4.5601e+01   1.2300e-02  -1.1700e+01
            0            0            0            0            0            0
            0            0            0            0            0   5.7300e+01
            0            0            0            0            0            0
            0            0            0            0            0            0
];
g1 = [
            0   2.4901e+01  -8.5071e-01   4.3457e-01   2.0000e+01
            0   4.0911e+01   3.3895e-01   7.1398e-01            0
            0  -1.9357e+03  -4.6381e+01  -3.3782e+01            0
            0   3.2397e+02  -1.9301e+00   5.6540e+00            0
            0   1.2504e+03   4.1636e+00   2.1823e+01            0
            0  -1.0258e+03  -1.8753e+01  -1.7902e+01            0
            0   6.4633e+02   2.0240e+01   1.1280e+01            0
            0  -2.1949e+02  -3.3365e+00  -3.8305e+00            0
            0  -4.1527e+02   1.3131e+01  -7.2473e+00            0
            0  -1.1724e+00  -3.4143e-01  -2.0461e-02            0
            0  -4.0315e+01  -3.7483e+00  -7.0358e-01            0
            0  -7.5120e+01  -1.7732e+00  -1.3110e+00            0
            0   3.3973e+01   6.1523e-01   5.9291e-01            0
            0  -6.0945e+00   6.5383e-02  -1.0636e-01            0
            0   9.6296e+00   8.8769e-02   1.6806e-01            0
            0  -1.5376e+02   1.4648e+00  -2.6835e+00            0
  -1.8900e+01  -3.2100e+01            0            0            0
   9.8300e-01            0            0            0            0
  -2.6300e+00            0            0            0            0
   1.0000e+00            0            0            0            0
            0            0            0            0            0
            0   5.7300e+01            0            0            0
            0            0            0            0         -Inf];
g1 = [tmp1, tmp2, tmp3, g1];
disp('...done');