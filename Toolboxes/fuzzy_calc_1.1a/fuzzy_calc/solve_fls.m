function sol=solve_fls(A,B);
% function sol=solve_fls(A,B);
% sol is a structured variable with fields:
% .exists - if 1, "solution exists", the system is consistent 
% .low - low solutions in trasposed form, as rows in a matrix
% .sol_numb - number of low solutions
% .hlp - contains the help matrix
% .ind - index vector
% .Xgr - greatest solution of the system
% .coef- S,E,G coefficient matrix
% .contr - contraditory equations, if the system is not consistent
% .A   - rearranged matrix Ainput
% .B   - rearranged matrix Binput
% .Ainput - input matrix A
% .Binput - input matrix B
% .problem_dimension  - shows the size of input matrix A, for instance '5 x 5'
% .percent_low_from_possible - for instance 31.2500%
% .time - solution time, seconds
% .t_fillhelp - time for filling help matrix,seconds
% .solver: the type of the solver 'standard', 'fast full version', or 'fast demo version'
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

disp(' ');
disp('---------------------------------------------------------------');
disp(' Standard Solver for fuzzy linear systems -  Rel. Jan.2004     ');
disp('         C Yordan Kyosev & Ketty Peeva                         ');
disp('    yordan_kyosev@gmx.net   kgp@tu-sofia.bg                    ');        
disp('                                                               ');        
disp('    Fuzzy Relational Calcululs Toolbox Rel. 1.1a                  ');        
disp('    Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva           ');        
disp('    Fuzzy Relational Calcululs Toolbox comes                   ');        
disp('    with ABSOLUTELY NO WARRANTY; for details see License.txt   ');        
disp('    This is free software, and you are welcome to redistribute ');        
disp('    it under certain conditions; see license.txt for details.;     ');        

tic
s=FillHelpMatrix(A,B);
prel_time=toc;

if s.exist
    hs=sterm(s.hlp(1,:));
    for i=2:length(s.hlp(:,1))
        disp(['Processing row Nr. ' num2str(i) ' start time ' num2str(clock)]);
        hs=hs*sterm(s.hlp(i,:));
    end
    
    
    minsol_=sterm2num(hs,length(s.Xgr));
    for i=1:length(minsol_)
        for j=1:length(minsol_{1})
            minsol(i,j)=minsol_{i}(j); 
        end
    end
    
    low_time=toc-prel_time;
    
    
    %fuzzy_maxmin(A,s.Xgr');
    
    for i=1 : length(minsol(:,1)) 

        if any(fuzzy_maxmin(A,minsol(i,:)')-B)
            disp(' Wrong solution');
        else
            solu=sprintf('%5.2f',minsol(i,:));
            disp(['Minimal solution ' num2str(i) ' is correct!. S=[' solu ' ]T']);
        end
    end;
    
    sol.exists=s.exist;
    sol.contr=s.contr;
    sol.low=minsol;
    sol.sol_numb=length(minsol(:,1));
    sol.Xgr=s.Xgr;
    sol.Ind=s.ind;
    sol.hlp=s.hlp;
    sol.coef=s.coef;
    sol.A=s.A;
    sol.B=s.B;
    sol.Ainput=s.Ainput;
    sol.Binput=s.Binput;

    sol.possible_paths=prod(s.ind);
    sol.problem_dimension=[num2str(length(A(:,1))) ' x ' num2str(length(A(1,:)))];
    sol.percent_low_from_possible=100*length(minsol)/prod(s.ind); % ; % kolto prozenta sa namerenite reshenia spriamo vsichki markirani
    sol.time=low_time+prel_time;
    sol.time_for_one_sol=sol.time/length(minsol);
    %sol.t_sort=t_sort1-t_sort0;
    sol.t_fillhelp=prel_time;
    %sol.t_mark=t_mark1-t_mark0;
    %sol.t_prov=t_prov1-t_prov0;
    sol.t_low=low_time;
    sol.t_low1=low_time/length(minsol);
    sol.solver='standard';
else
    disp('system has not exact solution')
end
