y_z_n = [0; 1];
t_0 = 0;
h = 0.01;
t_max = 100;

filename = 'euler_second.csv';

%%%

Array = euler2_v(y_z_n, t_0, h, t_max);

csvwrite(filename, Array);


t = Array(:, 1);
y = Array(:, 2);

t_s = [0 : h : t_max];
y_s = sin(t_s);

plot(t, y, 'b', t_s, y_s, 'g')

