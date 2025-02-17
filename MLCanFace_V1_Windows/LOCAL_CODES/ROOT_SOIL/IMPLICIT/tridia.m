
function x = tridia(n, a, b, c, r)

%=========================================================================
% TRIDIA solves triadiagonal systems of equations using Thomas algorithm.
% The system of equation to be solved has the form (Ax = d), where A is 
% the triadiagonal matrix with [a b c] forming its diagonals. n is the 
% size of the system, i.e., the number of equations to be solved.
%
% Written by Geremew G. Amenu, UIUC, 2006
% All rights reserved!
%
% -------------------------- Input Variables -----------------------------
%       n           % length of diagonal element vector
%       a(1:n)      % subdiagonal elements
%       b(1:n)      % diagonal elements
%       c(1:n)      % superdiagonal elements
%       r(1:n)      % right hand side
%       
% -------------------------- Output Variables ----------------------------
%       x(1:n)     % solution vector
% 
% -------------------------- Local Variables -----------------------------
%       gam(1:n), bet
%
%=========================================================================

bet = b(1);
x(1) = r(1) / bet;

% Forward elimination
for j = 2:n
    gam(j) = c(j-1) / bet;
    bet = b(j) - a(j) * gam(j);
    x(j) = (r(j) - a(j)*x(j-1)) / bet;
end 

% Back substitution
for j = n-1:-1:1
    x(j) = x(j) - gam(j+1) * x(j+1);
end 


%=================================== End =================================
