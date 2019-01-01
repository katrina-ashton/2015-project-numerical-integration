%%
% Author: Katrina Ashton
% Supervisor: Jochen Trumpf
% Script: X_x.m

% This script implements the Mobius scheme

% It takes h, A, B, Q, R and X as input, 
% where h is the time step and A, B, Q and R are coeeficients of an RDE
% of form (1), with X as the variable

%%

function X = mobius(h, A, B, Q, R, X)
alpha = eye(3) + h*B;
beta = h*Q;
gamma = h*R;
delta = eye(3) - h*A;
X = (alpha*X + beta)*inv(gamma*X+delta);
end
