y_n = 1;
t_0 = 0;
h = 0.25;
t_max = 4;

filename = 'euler_first.csv';

%%%
    
Array = euler_nm(y_n, t_0, h, t_max);

csvwrite(filename, Array);



t = Array(:, 1);
y = Array(:, 2);

plot(t, y);