X_n = [0.36, 0.48, -0.8; -0.8, 0.6, 0; 0.48, 0.64, 0.6];
Ref = [1, 0, 0;0, 1, 0; 0, 0, 1];
Ref_mid = [0; 0; 0];
t_0 = 0;
h = 0.25;
t_max = 1;

filename = 'eulermatrix.csv';

%%%
    
Array = euler_m(X_n, Ref, Ref_mid, t_0, h, t_max);

csvwrite(filename, Array);
