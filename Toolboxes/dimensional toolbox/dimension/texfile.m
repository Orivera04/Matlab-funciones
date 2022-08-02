function texfile(FILENAME,piset)
% Save piset as a LaTeX file
% Steffen Brueckner, 2002-02-07
    if ~exist('sym')
        warning('LaTeX output requires symbolic math toolbox');
        break;
    end
    
    [FID,MSG] = fopen(FILENAME,'w');
    if MSG
        warning(MSG);
        break;
    end

    fprintf(FID,'%s\n','\documentstyle{article}');
    fprintf(FID,'%s\n','\begin{document}');

    
    fprintf(FID,'%s\n','{\bfseries Dimensional Analysis Toolbox for Matlab Version 1.0}\newline');
    fprintf(FID,'%s\n\n','Copyright (c) Steffen Brueckner, 2002');

    fprintf(FID,'%s\n','{\tiny \begin{displaymath}');
    fprintf(FID,'%s\n',[' A = ' latex(sym(piset.A))]);
    fprintf(FID,'%s\n','\end{displaymath}}');

    fprintf(FID,'%s\n','{\tiny \begin{displaymath}');
    fprintf(FID,'%s\n',[' B = ' latex(sym(piset.B))]);
    fprintf(FID,'%s\n','\end{displaymath}}');

    fprintf(FID,'%s\n','{\tiny \begin{displaymath}');
    fprintf(FID,'%s\n',[' C = ' latex(sym(piset.C))]);
    fprintf(FID,'%s\n','\end{displaymath}}');
    
    fprintf(FID,'%s\n','{\tiny \begin{displaymath}');
    fprintf(FID,'%s\n',[' D = ' latex(sym(piset.D))]);
    fprintf(FID,'%s\n','\end{displaymath}}');

    % use my own formatting for TeX output ....
    fprintf(FID,'%s\n','\renewcommand{\arraystretch}{1.5}');
    L = latex(piset,1);
    if ~isequal(L,[])
        fprintf(FID,'%s\n','\begin{eqnarray}');
        for ii = 1:length(L)
            tmp = L{ii};
            jj = findstr('=',tmp);
            tmp = [tmp(1:jj-1) ' &=& ' tmp(jj+1:end) '\\'];
            fprintf(FID,'%s\n',tmp);
        end
        fprintf(FID,'%s\n','\end{eqnarray}');
    end
    fprintf(FID,'%s\n','\end{document}');
    
    fclose(FID);
    