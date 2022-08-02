function new_mf = inc_ctrst(mf)
% INC_CTRST Contrast intensifier.
%	INC_CTRST(MF) returns a new (array of) membership
%		grades after the contrast intensification operator.

%	Jyh-Shing Roger Jang, 6-2-93.

index1 = find(mf < 0.5);
index2 = find(mf >= 0.5);

tmp = mf(index1);
mf(index1) = 2*tmp.*tmp;
tmp = 1-mf(index2);
mf(index2) = 1-2*tmp.*tmp; 
new_mf = mf;
