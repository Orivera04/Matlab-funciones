function imprpuzzle (copia)
for i=1:3
    for j=1:3
        if copia(i,j)==0
            m(i,j)=' ';
        else
            m(i,j)=num2str(copia(i,j));
        end
    end
end

fprintf('                    * * * * * * * * * * * * *\n');
fprintf('                    *       *       *       *\n');
fprintf('                    *   %s   *   %s   *   %s   *\n',m(1,1),m(1,2),m(1,3));
fprintf('                    *       *       *       *\n');
fprintf('                    * * * * * * * * * * * * *\n');
fprintf('                    *       *       *       *\n');
fprintf('                    *   %s   *   %s   *   %s   *\n',m(2,1),m(2,2),m(2,3));
fprintf('                    *       *       *       *\n');
fprintf('                    * * * * * * * * * * * * *\n');
fprintf('                    *       *       *       *\n');
fprintf('                    *   %s   *   %s   *   %s   *\n',m(3,1),m(3,2),m(3,3));
fprintf('                    *       *       *       *\n');
fprintf('                    * * * * * * * * * * * * *\n');
fprintf('\n');