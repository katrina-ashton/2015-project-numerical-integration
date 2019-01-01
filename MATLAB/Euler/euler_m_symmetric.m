function t_y_array = euler_m_symmetric(X_n, k, t_0, h, t_max, lim, pt)
n = 0;
t_n = t_0 + n*h;
t_y_array = [];

    while t_n <= t_max       
        %scatter3(Ref(1,1), Ref(2,1), Ref(3,1), '*', 'b'); hold on
        %scatter3(Ref(1,2), Ref(2,2), Ref(3,2), 'o', 'b'); hold on
        %scatter3(Ref(1,3), Ref(2,3), Ref(3,3), '+', 'b'); hold on
        
        axis([-1*lim, lim, -1*lim, lim, -1*lim, 1*lim]);
        pause(pt);
        
        
        Ref = Ref*X_n;
        t_y_array = [t_y_array; Ref];
        
       
        n = n + 1;

        X_n = X_n + h*f(t_n, X_n, k);

        t_n = t_0 + n*h;
    end

end


function [f] = f(t_n, X_n, k)
I = [1,0,0;0,1,0;0,0,1];
f = -1*X_n*X_n+k*k*I;
end

function [entry] = diag(k, i, t)
entry = (k*sinh(k*t) + i*cosh(k*t))/(cosh(k*t)+(i/k)*sinh(k*t));
end

function [difference] = compare(T, X_N)
end