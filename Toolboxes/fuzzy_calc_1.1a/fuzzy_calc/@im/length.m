function [ij]=size(A)
ij(1)=length(A.m(:,1))
ij(2)=length(A.m(1,:))