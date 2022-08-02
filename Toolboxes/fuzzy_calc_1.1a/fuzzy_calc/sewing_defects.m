b(1).str='	missing stitches ';
b(2).str='	the interweave of the threads visible on the upper (face) side';
b(3).str='	the interweave of the threads visible on the bottom (back) side';
b(4).str='	breack upper thread';
b(5).str='	breack down thread';

x(1).str=' low upper thread tension ' ;
x(2).str=' normal upper thread tension  ' ;
x(3).str=' high upper thread tension  ';
x(4).str=' upper thread tension greater than bottom thread tension';
x(5).str=' near to 1       proportion upper / bottom thread tension' ;
x(6).str=' upper thread tension less than bottom thread tension';
x(7).str=' low    upper thread tenacity ';
x(8).str=' normal upper thread tenacity ';
x(9).str=' high   upper thread tenacity ';

A=[0.0   0.0   0.0   0.0   0.0   0.0   0.0   0.0   0.0
0.0   0.0   1.0   1.0   0.0   0.0   0.0   0.0   0.0
1.0   0.0   0.0   0.0   0.0   1.0   0.0   0.0   0.0
0.0   0.0   0.7   0.0   0.0   0.0   1.0   0.0   0.0
0.0   0.0   0.0   0.0   0.0   0.7   0.0   0.0   0.0];

disp('Compose the symptoms vector. ');
disp('If the described symptom appeare, write 1, if not appeare - 0');
disp('or write the degree of appearance of this symptom between 0 and 1');
for i=1:length(b)
%B(i) = input(b(i).str,'s')
B(i) = input(b(i).str)
end
B=B';