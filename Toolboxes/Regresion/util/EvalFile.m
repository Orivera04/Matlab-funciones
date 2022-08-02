function inputParams = EvalFile (parameters)
% Opens a file and then runs eval() on every line. Line by line.
% The file is closed after evaluating the final line.
    fid = fopen(parameters);
    while 1
        tline = fgetl(fid);
        if ~ischar(tline)
            break
        end
        eval(tline)
    end
    fclose(fid);
end