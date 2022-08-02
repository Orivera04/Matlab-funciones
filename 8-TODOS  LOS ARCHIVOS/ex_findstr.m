s1 = 'trente trois teutons têtus';
s2 = 't'
a  = findstr(s1,s2)
a  = find(s1 == s2) % ne fonctioone que parce que s2 est scalaire
s2 = 'tr'
a  = findstr(s1,s2)
s2 = ' ti'
a  = findstr(s1,s2)