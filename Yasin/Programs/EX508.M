function [y1,y2]=ex508(x1,x2)
y1=new1(x1)
y2=new2(x1,x2)

function y1=new1(x1)
y1=x1^2

function y2=new2(x1,x2)
y2=x1*x2-x2
