function result = loadurl(url)
% result = loadurl(url)
% Reads the URL given by the input
% string, url, into a temporary file
% using myread.java, loads it into a
% MATLAB variable, and returns the
% result. The URL can contain a MATLAB-
% readable text file, or a MAT-file.
t = tempname ;
myreader.geturl(url, t) ;
% load the temporary file, if it exists
try
    % try loading as an ascii file first
    result = load(t) ;
catch
    % try as a MAT file if ascii fails
    try
        result = load('-mat', t) ;
    catch
        result = [ ] ;
    end
end
% delete the temporary file
if (exist(t, 'file'))
    delete(t) ;
end
