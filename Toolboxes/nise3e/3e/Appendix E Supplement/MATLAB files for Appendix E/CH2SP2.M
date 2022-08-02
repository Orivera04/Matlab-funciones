% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% ch2sp2     In this example, we find Laplace transforms of time functions using 
% the command, laplace(f), where f is a time function, f(t). As an example, we use 
% the time functions that resulted from the calculations in Cases 2 and 3 in 
% Section 2.2 in the text and work in reverse to obtain their Laplace transforms. 
% We will see that the command, laplace(f), yields F(s) in partial fractions. In 
% addition to pretty printing discussed in the previous example, the Symbolic Math 
% Toolbox contains other commands that can change the look of the displayed result 
% for readability and form. Some of these commands are: collect(F) - collect common 
% coefficient terms of F; expand(F) - expands product of factors of F; 
% factor(F) - factors F; simple(F) - finds simplest form of F with the least 
% number of terms; simplify(F) - simplifies F; vpa(expression,places) - standing 
% for variable precision arithmetic, this  command converts fractional symbolic 
% terms into decimal terms with a specified number of decimal places. For 
% example, the symbolic fraction, 3/16, would be converted to 0.1875 if the 
% argument, places, were 4. In the example below, we find the Laplace 
% transform of a time function. The result is displayed as partial fractions. 
% To combine the partial fractions, we use the command, simplify(F), where F 
% is the Laplace transform of f(t) found using laplace(f). Finally, we use 
% F=vpa(F,3) to convert the symbolic fractions to decimals in the displayed  
% result.

'(ch2sp2)'                   % Display label.
syms t                       % Construct symbolic object for 
                             % time variable 't'.
'Laplace transform'	        % Display label.					 
'f(t) from Case 2'           % Display label.
f=2*exp(-t)-2*t*exp(-2*t)-2*exp(-2*t);
                             % Define f(t) from Case 2 example.
pretty(f)                    % Pretty print f(t) from Case 2 example.
'F(s) for Case 2'            % Display label.
F=laplace(f);                % Find Laplace transform.
pretty(F)                    % Pretty print partial fractions of
                             % F(s) for Case 2.
F=simplify(F);               % Combine partial fractions.
pretty(F)                    % Pretty print combined partial fractions.
'f(t) for Case 3'            % Display label.
f=3/5-3/5*exp(-t)*[cos(2*t)+(1/2)*sin(2*t)];         
                             % Define f(t) from Case 3 example.
pretty(f)                    % Pretty print f(t) for Case 3.
'F(s) for Case 3 - Symbolic fractions'
                             % Display label.
F=laplace(f);                % Find Laplace transform.
pretty(F)                    % % Pretty print partial fractions of
                             % F(s) for Case 3.
'F(s) for Case 3 - Decimal representation'
                             % Display label.
F=vpa(F,3);                  % Convert symbolic numerical fractions to
                             % 3-place decimal representation for F(s).
pretty(F)                    % Pretty print decimal representation.
F=simplify(F);               % Combine partial fractions.
pretty(F)                    % Pretty print combined partial fractions.
