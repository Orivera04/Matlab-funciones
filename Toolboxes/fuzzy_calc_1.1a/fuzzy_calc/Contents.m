% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% for use with the book
% "Fuzzy Relational Calculus - Theory, Applications and Software"
% (c) 2004 Ketty Peeva and Yordan Kyosev
% 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.
%
% Compositions
%
%   fuzzy_alpha.m       alpha composition 
%   fuzzy_epsilon.m     epsilon composition 
%   fuzzy_maxmin.m      max-min composition 
%   fuzzy_minmax.m      min-max composition 
%   maxmin_sample.m     sample matrices for performing max-min composition 
%   data4x2.m input     data for intersection and union operations 
%  
% 
% Solvers for fuzzy linear system of equation (FLSE)
%
%   solve_fls.m         (standard) solver for FLSE 
%   FillTypeMatrix.m    return the augmented matrix A:B in (G-E-S) form of the coefficients 
%   FillHelpMatrix.m    return the help matrix and checks consistency of  FLSE 
%   sortmat.m           return FLSE in normal form 
%   sample_solve_inv_probl.m example for solving FLSE 
%   fsdemo.p            fast solver for FLSE - limited demo version 
%
% 
% FLSE als inference engine
% 
%   diagn.m                     solve FLSE, returning the answer with descriptions of the fields 
%   sewing_defects.m example    input data for diagn.m 
%   sewing_defects1.m example   input data for diagn.m 
%  
% 
% Solver for fuzzy relational equation (FRE)
% 
%   re2le.m             convert fuzzy relational equation to FLSE 
%   fre.m               FRE solver 
%   fre_sample.m        input for FRE example 
%   fre_sample2.m       input for FRE example 
%   fre_sample3.m       input for FRE example 
%  
%
%
% Solver for FLP (Fuzzy linear programming)   
%
%   linprog.m           FLP solver, objective function with addition and multiplication 
%   linprogsample.m     input data for FLP example 
%   linprog_fuzzy.m     FLP solver, objective function with max - min operations 
%   inprogsample_f.m    input data for FLP example 
%  
% 
% Finite fuzzy machines
%   f_automata.m        example for finite fuzzy machines - behavior matrix 
%  
% 
% Intuitionistic calculus
%  
%   im.m            intuitionistic matrix object constructor 
%   transpose.m     equivalent to .'  - transposed IM 
%   sc_comp.m       standard - costandard composition of intuitionistic matrices 
%   ae_comp.m       alpha - epsilon composition of ihtuitionistic matrices 
%   disp_latex.m    display the intuitionistic matrix in LATEX format 
%   display.m       print intuitionistic matrix on the workspace 
%   i_sample4x3.m   input data for intuitionistic calculations 
%   data_intui.m    input data for intuitionistic FRE 
%   checkim.m       check if the input is IM
%   getnonim.m      return only fields, that not satisfy condition for IM
%
%  
% 
% Output formatting functions
% 
%   disp_latex.m    display input matrix in LATEX format 
%   disp_f.m        format the input matrix with 2 digits after decimal point 
%  
% 
% Sterm object - constructor and private functions
% CD-ROM:\m\@sterm
% 
%   sterm.m         consrtuct sum of terms 
%   absorbadd.m     apply absorption for addition  
%   char.m          convert sum of terms to char array for display 
%   display.m       display sum of terms 
%   mtimes.m p*q    multiplies sterms p and q 
%   plus.m p+q      adds  sterms p and q 
%   remove.m        remove element from sterm 
%   sterm2num.m     convert sterms to numeric array 
%   sterm2terms.m   convert sterms to term 
%  
% 
% Term object - constructor and private functions
% CD-ROM:\m\@term
% 
%   term.m      construct term object 
%   char.m      convert terms to char array for display 
%   display.m   display term 
%   eq.m        "equal to"  for two terms  
%   ge.m        "greater than or equal to" -  for two terms  
%   gt.m        "greater than" -  for two terms  
%   le.m        "less than" -  for two terms  
%   mtimes.m    p*q  multiplies terms p and q 
%   plus.m      p+q adds temrs p  and q 
%   sort.m      arrange term components ascending order of denominator 
%   term2num.m  convert term to numerical array 
%   term2vec.m  convert term to vector with n elements 
% 
%  
% Input data for systems of FLSE 
% The files return matrix A and column matrix B for FLSE   A ·X = B 
%   
%   zerodiag.m      return matrix A with zero diagonal, and different right hand side components of the B 
%   zerodiag2.m     return matrix A with two stripe zero diagonals 
%   zerodiag_eq.m   return matrix A with zero diagonal and equal right hand side components 
%   sample10x8.m    "sampleYYxZZ"  denotes " sample with size of A - YY x ZZ" 
