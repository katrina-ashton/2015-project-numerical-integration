h = 0.001;
r = 3;
t_0 = 0;
t_max = 10;
lim = 1.5;
pt = 0.000001;

X_n_t = [0.36, 0.48, -0.8; -0.8, 0.6, 0; 0.48, 0.64, 0.6];
X_n = eye(3);

Ref = eye(3);
Ref_mid = [0; 0; 0];

%Should work even though these are the values for the quaternion
%implementation
B_o = degtorad(25)^2*eye(3);
B_b = degtorad(0.1)^2*eye(3);
D_1 = degtorad(30)^2*eye(3);
D_2 = degtorad(30)^2*eye(3);

std_q0 = degtorad(60);
std_b0 = degtorad(20);

%Couldn't find a value for K0 - Using the value for Pa as P
%This is probably pretty dodgy
P = (1/std_q0^2)*eye(3);

y1_d = [1;0;0];
y2_d = [0;1;0];

Array = MEKF(h, r, t_0, t_max, pt, lim, Ref, Ref_mid, y1_d, y2_d, X_n_t, X_n, B_o, D_1, D_2, P);

figure;

t = Array(:, 1);
error = Array(:, 2);

plot(t, error);