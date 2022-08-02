
s1 = {'Un peu', 'd''humour '};
s2 = {' de sel',  ' beaucoup '}; 
s = strcat(s1, s2)
sr = strrep(s, {'e','u'}, {'E', 'U'})
ss = strvcat(s)
ss = strjust(ss, 'center')

