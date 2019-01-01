function X = mobius(h, A, B, Q, R, X)
alpha = eye(3) + h*B + o(h);
beta = h*Q +o(h);
gamma = h*R +o(h);
delta = eye(3) - h*A + o(h);
X = (alpha*X + beta)*inv(gamma*X+delta);
end

function o_h = o(h)
o_h = 0;
end