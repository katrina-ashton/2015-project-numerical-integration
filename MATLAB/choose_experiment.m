clear;
%%
%%% CHOOSE METHOD
%Method used for numerical integration:
 %0 = OFF
 %1 = ON
%Colour for graph:
 %y, m, c, r, g, b, w, k

%%%MEKF:
%Euler (non-geometric)
MEKF_euler = 0;
%Colour
MEKF_euler_c = 'b';

%Choi
MEKF_choi = 0;
%Colour
MEKF_choi_c = 'g';

%Mobius
MEKF_mobius = 0;
%Colour
MEKF_mobius_c = 'k';

%%%GAME:
%Euler (non-geometric)
GAME_euler = 1;
%Colour
GAME_euler_c = 'r';

%pseudo-Choi (extremely noisy)
GAME_choi = 0;
%Colour
GAME_choi_c = 'g';

%pseudo-Mobius
GAME_mobius = 1;
%Colour
GAME_mobius_c = 'y';

%%
%%% CHOOSE WHICH GRAPHS
%Number of runs to average over
num = 100;

%Choose whether each graph is on or off:
 %0 = OFF
 %1 = ON
%Error vs time
err = 1;

%Rolling time integral
int = 1;

%Display time taken for each method
time = 1;

%%%

%%
%%% CHOOSE OTHER VARIABLES
%Choose data type
 %0 = Custom
 %1 = UAV (high noise)
 %2 = Satellite (low noise) - took values from paper, but not working
%Note, setting this to 2 will change the velocity simulation
Data_type = 1;

%Measurement directions:
%Normed to allow for easier changes
y1_d = [1;0;0];
y1_d = y1_d/norm(y1_d);
y2_d = [0;1;0];
y2_d = y2_d/norm(y2_d);

%Time:
h = 0.001;
t_0 = 0;
t_max = 20;

%Used in Choi's method:
r = 1;

%Scale velocity:
V = 1;

%True rotation mean:
%Randomised after std_q0 is defined
X_n_t_mean = eye(3);

%Initial estimate of rotation:
X_n = eye(3);

%%%

%%
%%% SETTING ERROR COEFFICIENTS BASED ON Data_type
%%% Custom:
if Data_type == 0
%Measurement error coefficients:
B_o = degtorad(25)^2*eye(3);
D_1 = degtorad(30)^2*eye(3);
D_2 = degtorad(30)^2*eye(3);

%Initial value error estimate:
std_q0 = degtorad(60);

%Initial estimate of P:
P = (1/std_q0^2)*eye(3);
%%%

%%% UAV - do not change:
elseif Data_type == 1
%Measurement error coefficients:
B_o = degtorad(25)^2*eye(3);
D_1 = degtorad(30)^2*eye(3);
D_2 = degtorad(30)^2*eye(3);

%Initial value error estimate:
std_q0 = degtorad(60);

%Initial estimate of P:
P = (1/std_q0^2)*eye(3);
%%%

%%% Satellite - do not change:
elseif Data_type == 2
%Measurement error coefficients:
B_o = (0.31623^2*10^(-6))*eye(3);
D_1 = degtorad(1)^2*eye(3);
D_2 = degtorad(1)^2*eye(3);

%Initial value error estimate:
std_q0 = degtorad(60);

%Initial estimate of P:
P = (0.1/std_q0^2)*eye(3);
%%%
end
%%%

%%
%%% RESULTS:
t = [t_0:h:t_max]';

%Initialising variables:
i = 0;
MEKF_av1 = zeros(size(t));
MEKF_av2 = zeros(size(t));
MEKF_av3 = zeros(size(t));
GAME_av1 = zeros(size(t));
GAME_av2 = zeros(size(t));
GAME_av3 = zeros(size(t));
legend_names = {};
MEKF_av1_time = 0;
MEKF_av2_time = 0;
MEKF_av3_time = 0;
GAME_av1_time = 0;
GAME_av2_time = 0;
GAME_av3_time = 0;

%Legend:
if MEKF_euler == 1
    legend_names = [legend_names, {'MEKF Euler'}];
end
if MEKF_choi == 1
    legend_names = [legend_names, {'MEKF Choi'}];
end
if MEKF_mobius == 1
    legend_names = [legend_names, {'MEKF Mobius'}];
end
if GAME_euler == 1
    legend_names = [legend_names, {'GAME Euler'}];
end
if GAME_choi == 1
    legend_names = [legend_names, {'GAME pseudo-Choi'}];
end
if GAME_mobius == 1
    legend_names = [legend_names, {'GAME pseudo-Mobius'}];
end

%While loop to get averages:
while i < num
%Randomising X_n_t using std_q0:
v_rand = std_q0*rand(3,1);
X_n_t = X_n_t_mean*expm(X_x(v_rand));

%Incrementing counter:
i = i + 1;

%Getting results as a matrix:
if MEKF_euler == 1
    tic
    MEKF_results = MEKF(h, r, t_0, t_max, y1_d, y2_d, X_n_t, X_n, B_o, D_1, D_2, P, V, 1, Data_type);
    MEKF_av1 = MEKF_av1 + MEKF_results;
    MEKF_av1_time = MEKF_av1_time + toc;
end
if MEKF_choi == 1
    tic
    MEKF_results = MEKF(h, r, t_0, t_max, y1_d, y2_d, X_n_t, X_n, B_o, D_1, D_2, P, V, 2, Data_type);
    MEKF_av2 = MEKF_av2 + MEKF_results;
    MEKF_av2_time = MEKF_av2_time + toc;
end
if MEKF_mobius == 1
    tic
    MEKF_results = MEKF(h, r, t_0, t_max, y1_d, y2_d, X_n_t, X_n, B_o, D_1, D_2, P, V, 3, Data_type);
    MEKF_av3 = MEKF_av3 + MEKF_results;
    MEKF_av3_time = MEKF_av3_time + toc;
end
if GAME_euler == 1
    tic
    GAME_results = GAME(h, r, t_0, t_max, y1_d, y2_d, X_n_t, X_n, B_o, D_1, D_2, P, V, 1, Data_type);
    GAME_av1 = GAME_av1 + GAME_results;
    GAME_av1_time = GAME_av1_time + toc;
end
if GAME_choi == 1
    tic
    GAME_results = GAME(h, r, t_0, t_max, y1_d, y2_d, X_n_t, X_n, B_o, D_1, D_2, P, V, 2, Data_type);
    GAME_av2 = GAME_av2 + GAME_results;
    GAME_av2_time = GAME_av2_time + toc;
end
if GAME_mobius == 1
    tic
    GAME_results = GAME(h, r, t_0, t_max, y1_d, y2_d, X_n_t, X_n, B_o, D_1, D_2, P, V, 3, Data_type);
    GAME_av3 = GAME_av3 + GAME_results;
    GAME_av3_time = GAME_av3_time + toc;
end
end

%Averaging:
MEKF_av1 = MEKF_av1/num;
MEKF_av2 = MEKF_av2/num;
MEKF_av3 = MEKF_av3/num;
GAME_av1 = GAME_av1/num;
GAME_av2 = GAME_av2/num;
GAME_av3 = GAME_av3/num;

MEKF_av1_time = MEKF_av1_time/num;
MEKF_av2_time = MEKF_av2_time/num;
MEKF_av3_time = MEKF_av3_time/num;
GAME_av1_time = GAME_av1_time/num;
GAME_av2_time = GAME_av2_time/num;
GAME_av3_time = GAME_av3_time/num;
    
%Plotting results:    
t = [t_0:h:t_max]';

%Error
if err == 1;
figure;

if MEKF_euler == 1
    plot(t, MEKF_av1, MEKF_euler_c); hold on
end

if MEKF_choi == 1
    plot(t, MEKF_av2, MEKF_choi_c); hold on
end

if MEKF_mobius == 1
    plot(t, MEKF_av3, MEKF_mobius_c); hold on
end

if GAME_euler == 1
    plot(t, GAME_av1, GAME_euler_c); hold on
end

if GAME_choi == 1
    plot(t, GAME_av2, GAME_choi_c); hold on
end

if GAME_mobius == 1
    plot(t, GAME_av3, GAME_mobius_c); hold on
end

xlabel('Time');
ylabel('Angle of error');
legend(legend_names);

end

%Rolling integral
if int == 1;
figure;

if MEKF_euler == 1
    MEKF_int1 = h*cumtrapz(MEKF_av1);
    plot(t, MEKF_int1, MEKF_euler_c); hold on
end

if MEKF_choi == 1
    MEKF_int2 = h*cumtrapz(MEKF_av2);
    plot(t, MEKF_int2, MEKF_choi_c); hold on
end

if MEKF_mobius == 1
    MEKF_int3 = h*cumtrapz(MEKF_av3);
    plot(t, MEKF_int3, MEKF_mobius_c); hold on
end

if GAME_euler == 1
    GAME_int1 = h*cumtrapz(GAME_av1);
    plot(t, GAME_int1, GAME_euler_c); hold on
end

if GAME_choi == 1
    GAME_int2 = h*cumtrapz(GAME_av2);
    plot(t, GAME_int2, GAME_choi_c); hold on
end

if GAME_mobius == 1
    GAME_int3 = h*cumtrapz(GAME_av3);
    plot(t, GAME_int3, GAME_mobius_c); hold on
end

xlabel('Time');
ylabel('Rolling integral of error angle');
legend(legend_names, 'Location', 'southeast');

end

%Computational time
if time == 1
if MEKF_euler == 1
    MEKF_av1_time
end

if MEKF_choi == 1
    MEKF_av2_time
end

if MEKF_mobius == 1
    MEKF_av3_time
end

if GAME_euler == 1
    GAME_av1_time
end

if GAME_choi == 1
    GAME_av2_time
end

if GAME_mobius == 1
    GAME_av3_time
end
end    
%%%
