x = [0 0 1 1 0
    1 1 1 0 0
    1 .5 .5 .5 .5
    0 NaN NaN NaN NaN];
y = [0 1 1 0 0
    0 1 0 0 1
    1 .5 .5 .5 .5
    1 NaN NaN NaN NaN];
z = [0 0 0 0 0
    0 0 0 0 0
    0 1 1 1 1
    0 NaN NaN NaN NaN];
patch(x,y,z,'y')
view(3);xyz,box