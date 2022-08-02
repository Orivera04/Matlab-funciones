% ocean.m, example test data
% ocean depth data
x = 0:.5:4;  % x-axis (varies across the rows of z)
y = 0:.5:6;  % y-axis (varies down the columns of z)
z=[100    99   100    99   100    99    99    99   100
   100    99    99    99   100    99   100    99    99
    99    99    98    98   100    99   100   100   100
   100    98    97    97    99   100   100   100    99
   101   100    98    98   100   102   103   100   100
   102   103   101   100   102   106   104   101   100
    99   102   100   100   103   108   106   101    99
    97    99   100   100   102   105   103   101   100
   100   102   103   101   102   103   102   100    99
   100   102   103   102   101   101   100    99    99
   100   100   101   101   100   100   100    99    99
   100   100   100   100   100    99    99    99    99
   100   100   100    99    99   100    99   100    99];
mesh(x,y,z)
xlabel('X-axis, km')
ylabel('Y-axis, km')
zlabel('Ocean Depth, m')
title('Figure 19.4: Ocean Depth Measurements')