function t_y_array = euler2_v(y_z_n, t_0, h, t_max)
n = 0;
t_n = t_0 + n*h;
t_y_array = [];

    while t_n <= t_max
        y_n = y_z_n(1,1);
        t_y_row = [t_n, y_n];
        t_y_array = [t_y_array; t_y_row];
       
        n = n + 1;
        
        y_z_n = y_z_n + h*[0, 1; -1, 0]*y_z_n;

        t_n = t_0 + n*h;
    end

end
