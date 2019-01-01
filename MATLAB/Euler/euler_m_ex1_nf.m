m = 3;
k = 2;
t_0 = 0;
h = 0.1;
t_max = 20;

triD = zeros(m);
for i = 1:m
    triD(i,i) = 1;
    if (i + 1) <= m
        triD(i, i+1) = 1;
    end
    if (i - 1) > 0
        triD(i, i-1) = 1;
    end    
end    
U = orth(triD);
U_1 = inv(U);
X_n = zeros(m);
for i = 1:m
    triD(i,i) = i;
end    
X_n = U*X_n*U_1;

%%%
    
Array = euler_m_ex1(m, X_n, k, U, U_1, t_0, h, t_max);

t = Array(:, 1);
diff = Array(:, 2);

plot(t, diff);