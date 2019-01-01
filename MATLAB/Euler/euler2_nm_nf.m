y_n = 0;
z_n = 1;
t_0 = 0;
h = 0.75;
t_max = 100;

filename = 'euler_second.csv';

%%%

Array = euler2_nm(y_n, z_n, t_0, h, t_max);

csvwrite(filename, Array);


t = Array(:, 1);
y = Array(:, 2);

t_s = [0 : 0.75 : 100];
y_s = sin(t_s);

plot(t, y, t_s, y_s)

