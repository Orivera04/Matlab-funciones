% description of symptoms
b(1).str='	the interweave of the threads visible on the upper (face) side';
b(2).str='	the interweave of the threads visible on the bottom (back) side';
b(3).str='	breack upper thread';
b(4).str='	breack down thread';

% description of causes
x(1).str=' low upper thread tension ' ;
x(2).str=' high upper thread tension  ';
x(3).str=' upper thread tension greater than bottom thread tension';
x(4).str=' upper thread tension less than bottom thread tension';
x(5).str=' low    upper thread tenacity ';

% note, that this matrix is only demo example, it is not verified as expert
% knowledge and do not work correctly for some cases, because is only small part from the whole
% matrix.
A=[0.0  0.5   1.0   0.0   0.0
1.0  0.0   0.0   1.0   0.0
0.0  1.0   0.8   0.0   1.0
0.0  0.0   0.0   0.5   0.0];

disp('Compose the symptoms vector. ');
disp('If the described symptom appeare, write 1, if not appeare - 0');
disp('or write the degree of appearance of this symptom between 0 and 1');
for i=1:length(b)
B(i) = input(b(i).str);
end
B=B';