% % Mfile name
%   mtl_aae_sim_bin2decusf.m

% Version:
%   Matlab R2007a

% Revised: 
%   August 28, 2008

% Authors:
%   Luke Snyder, Dr. Autar Kaw
%   University of South Florida
%   kaw@eng.usf.edu
%   Website: http://numericalmethods.eng.usf.edu
       
% Purpose
%   To illustrate the concept of the conversion of a fixed binary number to
%   decimal format.

% Keywords
%   Binary to decimal conversion
%   Fixed point register

% Clearing all data, variable names, and files from any other source and
% clearing the command window after each successive run of the program.
clc
clear all

% Inputs:
%    This is the only place in the program where the user makes the changes
%    based on their wishes.
    % Enter number to be converted to decimal number:
    % NOTE: Do NOT remove the apostrophe(') symbol from the number or the
    % worksheet will not work!
    bin_num = '111111101.11';
       
% *************************************************************************

disp(sprintf('\n\nConcepts of Conversion of Base 2 Fixed Register Binary '))
disp(sprintf('Number to Base 10 Decimal'))
disp(sprintf('\nUniversity of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu'))
disp(sprintf('Website: http://numericalmethods.eng.usf.edu'))
disp(sprintf('\nNOTE: This worksheet illustrates the use of Matlab to convert')) 
disp('a fixed binary point number to a decimal number.')

disp(sprintf('\n**************************Introduction***************************'))
         
disp(sprintf('\nThe following worksheet illustrates how to convert a fixed point '))
disp(sprintf('register binary (base-2) number to a decimal number (base-10) '))
disp(sprintf('using loops and various conditional statements. The user inputs a '))
disp(sprintf('binary number in the Input section of the program, and then an '))
disp(sprintf('equivalent decimal number is given as an output.'))

disp(sprintf('\n\n***************************Input Data******************************'))
disp(sprintf('\n'));
str = ['Binary number to convert to decimal number, bin_num = ',bin_num];
disp(str);

disp(sprintf('\n\n***************************Procedure******************************'))

% Using the floor command to isolate the "integer" part of the base-2 number.
int_bin = str2num(bin_num);
int_bin = floor(int_bin);

% Determining the length of the entire binary number and all the characters
% in the string.
n = length(bin_num);

% Converting each individual number in the "integer" part back to a string 
% which also enters it into a character array.
str_int = num2str(int_bin);

% Determining the length of the character array for use in loop.
m = length(str_int);

% Using a loop to sum values of the "integer" portion of the base-2 number.
% The loop variable 'sumint' is used for summation and is initialized at 0.
sumint = 0;

for i = 1:1:m
    
    % Converting each number in the character array to a number in another
    % array.
    bin_int(i) = str2num(str_int(i));
    
    % Summing values based on the values in the new array.  This value is
    % the summation of each individual digit in the "integer" part of the
    % base-2 number.
    sumint = sumint + bin_int(i)*2^(m-i);
    
end

% Using a loop to sum values of the "fractional" portion of the base-2
% number. The loop variable 'sumfrac' is used for summation and is
% initialized at 0.
sumfrac = 0;

% This loop variable, 'j' is used to create a new array of numbers that
% represent the "fractional" portion of the binary number.  
j = 1;

% Note that the starting point in this loop is the length of the integer
% portion (m), plus 2 which effectively "skips" the decimal point in the
% character array.  The ending point (n) is equal to the length of the entire
% character array (bin_num).
for i = m+2:1:n
    
    % Using the loop variable 'j' to create a new number array.
    bin_frac(j) = str2num(bin_num(i));
    
    % Creating a new character array of only the "fractional" portion for
    % later use.
    bin_frac_str(j) = bin_num(i);
    
    % Summing values of the "fractional" portion using loop variable
    % 'sumfrac'.
    sumfrac = sumfrac + bin_frac(j)*2^(-j);
    
    % Adding '1' to the loop variable each time such that it creates a new
    % position in the array for the next iteration.
    j = j+1;
    
end

% Adding the "fractional" portion of the base-2 number with the "integer"
% portion which yeilds the base-10 number.
total_dec = sumint + sumfrac;

% Displaying the results:
% Integer Portion
fprintf('\n');
str1 = 'The conversion of the "integer" portion (';
str2 = ') of the base-2 number';
str3 = ['to a base-10 number yields a value of, sumint = ',num2str(sumint,'%g'),'.'];
str = [str1,str_int,str2];
disp(str)
disp(str3)
% Fractional Portion
fprintf('\n');
str1 = 'The conversion of the "fractional" portion (';
str2 = ') of the base-2 number';
str = [str1,bin_frac_str,str2];
disp(str);
str3 = ['to a base-10 number yields a value of, sumfrac = ',num2str(sumfrac,'%g'),'.'];
disp(str3)
disp(sprintf('\nThe total value of the conversion of the base-2 number to a base-10'));
disp(sprintf('number is, total_dec = %f',total_dec));


disp(sprintf('\n\n***************************Conclusion******************************'))
disp(sprintf('This worksheet illustrates the use of Matlab to convert a base-2 '))
disp(sprintf('binary number to a base-10 number. It is important to understand '))
disp(sprintf('the binary system as it has numerous applications. Critical to this '))
disp(sprintf('understanding is being able to convert decimal numbers to binary '))
disp(sprintf('numbers, and vice-versa.'))

disp(sprintf('\n\n***************************Refrences******************************'))
disp('See: <a href = "http://numericalmethods.eng.usf.edu/mtl/gen/01aae/mtl_gen_aae_txt_binaryrepresentation.pdf">Binary Representation of Numbers</a>')

disp(sprintf('\n\nLegal Notice: The copyright for this application is owned'))
disp(sprintf('by the author(s). Neither MathWorks nor the author(s)'))
disp(sprintf('are responsible for any errors contained within and are '))
disp(sprintf('not liable for any damages resulting from the use of this'))
disp(sprintf('material. This application is intended for non-commercial,'))
disp(sprintf('non-profit use only. Contact the author for permission if'))
disp(sprintf('you wish to use this application in for-profit activities.'))
