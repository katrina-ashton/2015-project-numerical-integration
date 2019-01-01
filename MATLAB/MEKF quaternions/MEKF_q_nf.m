r = 3;
t_0 = 0;
lim = 1.5;
pt = 0.000001;

%Starting by choosing a rotation then converting to quaternion,
%So I can look at my "true" frame and see if it's working as expected
X_n_t = [0.36, 0.48, -0.8; -0.8, 0.6, 0; 0.48, 0.64, 0.6];
X_n_t_aa = vrrotmat2vec(X_n_t);

q_n_t = [cos(X_n_t_aa(4)/2); sin(X_n_t_aa(1)/2); sin(X_n_t_aa(2)/2); sin(X_n_t_aa(3)/2)];  

%From comparison paper
q_n = [1;0;0;0];

Ref = eye(3);
Ref_mid = [0; 0; 0];

%%%
%UAV:
h = 0.001;
t_max = 10;
%25, 0.1, 30, 30 degrees standard deviation in noise
B_o = degtorad(25)^2*eye(3);
B_b = degtorad(0.1)^2*eye(3);
D_1 = degtorad(30)^2*eye(3);
D_2 = degtorad(30)^2*eye(3);

%60, 20 degrees standard deviation in noise
std_q0 = degtorad(60);
std_b0 = degtorad(20);

Pa = (1/std_q0^2)*eye(3);
Pb = (1/std_b0^2)*eye(3);
Pc = zeros(3);
%%%

y1_d = [1;0;0];
y2_d = [0;1;0];

b_n = std_b0 * randn(3,1);

q_n_t = q_n_t + std_q0*rand(1);
q_n_t = q_n_t/norm(q_n_t);

Array = MEKF_q(h, r, t_0, t_max, pt, lim, Ref, Ref_mid, y1_d, y2_d, b_n, q_n_t, q_n, B_o, B_b, D_1, D_2, Pa, Pb, Pc);

figure;

t = Array(:, 1);
error = Array(:, 2);

plot(t, error);