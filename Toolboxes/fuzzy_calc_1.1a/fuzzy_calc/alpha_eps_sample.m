A=[0	0.3	0.4
    0.2	0.5	0.3
    0.8	0	0
    0.7	1.0 0.9];

B=[1	0.2	0.2
    0.1	0.4	0.9
    0.1	1	0
    0.7	0.4 0.3];

% bb=fuzzy_maxmin(A,[0 1 0.2]')

bb=[0.3000
    0.5000
         0
    1.0000];

A1=A'
X=fuzzy_alpha(A1,bb)
C=fuzzy_maxmin(A,X)-bb
disp_latex(A)
disp_latex(bb)

Xe=fuzzy_epsilon(A1,bb)
C=fuzzy_minmax(A,Xe)-bb
