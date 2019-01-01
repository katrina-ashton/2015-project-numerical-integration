triD = [1,1,0;1,1,1;0,1,1];
U = orth(triD);
U_1 = inv(U);
X_n = U*[1,0,0;0,2,0;0,0,3]*U_1;
k = 1;
t_0 = 0;
h = 0.05;
t_max = 1.5;
lim = 1.5;
pt = 0.4;


filename = 'eulermatrix_2.csv';

%%%
    
Array = euler_m_symmetric(X_n, k, t_0, h, t_max, lim, pt);

csvwrite(filename, Array);