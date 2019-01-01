    function t_y_array = euler_nm(y_n, t_0, h, t_max)
    n = 0;
    t_n = t_0 + n*h;
    t_y_array = [];

    while t_n <= t_max
        t_y_row = [t_n, y_n];
        t_y_array = [t_y_array; t_y_row];
       
        n = n + 1;

        y_n = y_n + h*f(t_n, y_n);

        t_n = t_0 + n*h;
    end

end


function [f] = f(t_n, y_n)
f = y_n;
end
    
