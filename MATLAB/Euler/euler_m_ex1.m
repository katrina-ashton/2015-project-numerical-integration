function t_y_array = euler_m_ex1(m, X_n, k, U, U_1, t_0, h, t_max)
n = 0;
t_n = t_0 + n*h;
t_y_array = [];

    while t_n <= t_max
        True_diag = zeros(m);
        for i = 1:m
            True_diag(i,i) = diag(k, i, t_n);
        end
        True = U*True_diag*U_1;
        
        diff = norm(True) - norm(X_n);
        
        t_y_array = [t_y_array; t_n, diff];
        
       
        n = n + 1;

        X_n = X_n + h*f(t_n, X_n, k, m);

        t_n = t_0 + n*h;
    end

end


function [f] = f(t_n, X_n, k, m)
I = zeros(m);
for i = 1:m
    I(i,i) = 1;
end   
f = -1*X_n*X_n+k*k*I;
end

function [entry] = diag(k, i, t)
entry = (k*sinh(k*t) + i*cosh(k*t))/(cosh(k*t)+(i/k)*sinh(k*t));
end