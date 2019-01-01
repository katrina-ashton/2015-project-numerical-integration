h = 0.001;
t_0 = 0;
t_max = 5;
lim = 1.5;
pt = 0.01;

X_n_t = [0.36, 0.48, -0.8; -0.8, 0.6, 0; 0.48, 0.64, 0.6];
X_n = [0,0,1;1,0,0;0,1,0];

Ref = eye(3);
Ref_mid = [0; 0; 0];

B = 0.2;
D_1 = 0.05;
D_2 = 0.05;

y1_d = [1;0;0];
y2_d = [0;1;0];

Array = MEKF_euler(h, t_0, t_max, pt, lim, Ref, Ref_mid, y1_d, y2_d, X_n_t, X_n, B, D_1, D_2);

t = Array(:, 1);
error = Array(:, 2);

plot(t, error);