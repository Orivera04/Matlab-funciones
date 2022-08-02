function matops                                %last updated 6/16/94
%MATOPS  Screen aid that lists matrix operations.
%
%        Use in the form  ==>  matops  <==
%
%  By: David R. Hill, Math. Dept., Temple University
%      Philadelphia, Pa. 19122, Email: hill@math.temple.edu
tab1=...
['                          MATRIX OPERATIONS                    ';
 '                                                               ';
 ' symbol     name          form                                 ';
 '                                                               ';
 '   +      addition        A + B     (A & B the same size)      ';
 '   -      subtraction     A - B     (A & B the same size)      ';
 '   *      multiplication   A*B      (# cols of A = # rows of B)';
 '   *      scalar mult.     t*A      (t is a scalar; either a   ';
 '                                     real or complex number)   '];
 tab1a=...
[ '   ^      exponentiation   A^k      (A must be square &        ';
 '             (powers)                  k a positive integer)   ';
 '                                                               ';
 '   ''      transpose        A''       (converts the rows of A    ';
 '                                     to columns)               ';
 '   There is no division of matrices.                           ';
 '                                                               ';
 '_______________________________________________________________'];
tab2=...
['For further information enter the following commands:          ';
 '                                                               ';
 '    more on, help arith, more off                              '];
 clc
 disp(tab1),disp(tab1a),disp(tab2)

