function [num,den]=rationalReduce(num,den)
d=rationalGCD(num,den);
num=num/d;
den=den/d;