%%
% Author: Katrina Ashton
% Supervisor: Jochen Trumpf
% Script: X_x.m

% This script implements Choi's method

% It takes h, r, A, B, Q, R and X as input, 
% where h is the time step, A, B, Q and R are coeeficients of an RDE
% of form (1), with X as the variable
% and every entry of the solution is r + 1 times differentiable

%%

function X = choi(h, r, A, B, Q, R, X, X_array)
%Finding the coefficients in the Sylvester equation
A_bar = find_A_bar(r,A,h);
B_bar = find_B_bar(r,B,h);
Q_bar = find_Q_bar(r,Q,h,X_array);
R_bar = find_R_bar(r,R,h);

% Solving the Sylvester equation
X = sylvester((B_bar - X*R_bar), (A_bar - R_bar*X), ...
    -1*(Q_bar + X*R_bar*X));
end

%%
function A_bar = find_A_bar(r,A,h)
sum = 0;
    for i = 1:r
        sum = sum + 1/i;
    end
A_bar = (-1*sum/2)*eye(3) + h*A;
end

%%
function B_bar = find_B_bar(r,B,h)
sum = 0;
    for i = 1:r
        sum = sum + 1/i;
    end
B_bar = (-1*sum/2)*eye(3) + h*B;
end

%%
function Q_bar = find_Q_bar(r,Q,h,X_array)
sum = 0;
if size(X_array, 2)/3 - 1 < r
    for i = 1:r
        sum = sum + (((-1)^(i-1))/i)*nchoosek(r,i)*X_array(:,1:3);
    end
else    
    for i = 1:r
        k = size(X_array, 2)/3 - 1;
        sum = sum + (((-1)^(i-1))/i)*nchoosek(r,i)*...
            X_array(:,(3*(k-i+1)+1):(3*(k-i+1)+3));
    end
end
Q_bar = sum + h*Q;
end

%%
function R_bar = find_R_bar(r,R,h)
R_bar = h*R;
end