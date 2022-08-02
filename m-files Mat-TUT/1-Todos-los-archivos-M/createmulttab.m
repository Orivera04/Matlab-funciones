% Prompt the user for rows and columns and
%  create a multiplication table to store in
%  a file "mymulttable.dat"
 
num_rows = input('Enter the number of rows: ');
num_cols = input('Enter the number of columns: ');
multmatrix = multtable(num_rows, num_cols);
save mymulttable.dat multmatrix -ascii
