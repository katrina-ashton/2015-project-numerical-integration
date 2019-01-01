 function error_array = GAME(h, r, t_0, t_max, y1_d, y2_d, X_n_t, X_n, B, D_1, D_2, P, V, method, data_type)
t = t_0;
Q = B*transpose(B);
R_1 = D_1*transpose(D_1);
R_2 = D_2*transpose(D_2);
error_array = [];
P_array = P;

while t <= t_max + h/10
    %O is true value of omega, u is the measurement
    O = V*find_O(t, data_type);
    u = X_noisy(O, B);
      
    %y1 and y2 give true values
    y1 = transpose(X_n_t)*y1_d;
    y2 = transpose(X_n_t)*y2_d;

    %Simulating measured yi values
    y1_meas = X_noisy(y1, D_1);
    y2_meas = X_noisy(y2, D_2);
    y1_meas = y1_meas/norm(y1_meas);
    y2_meas = y2_meas/norm(y2_meas);
    
    %Estimating yi
    y1_n = transpose(X_n)*y1_d;
    y2_n = transpose(X_n)*y2_d;
    
    S = find_S(y1_n, y2_n, R_1, R_2);
    C = find_C(y1_n, y2_n, y1_meas, y2_meas, R_1, R_2);
    A = find_A(C);
    l = find_l(R_1, R_2, y1_n, y2_n, y1_meas, y2_meas);
    
    %Comparing true to estimate:
    error_matrix = X_n*X_n_t';
    error_angle = acos((error_matrix(1,1) + error_matrix(2,2) + error_matrix(3,3) - 1)/2); 
    error_array = [error_array; t, error_angle];
    
    O_x = X_x(O);
    
    %Updating X_n_t using Euler's method - geometric
    X_n_t = X_n_t*expm(h*O_x);
    
    %Updating P using Euler's method -non-geometric (method 1):
    if method == 1
    P = P + h*fP(Q, P, u, S, A, l);
    
    %Updating P using Choi's method (method 2):
    elseif method == 2
    P = choi(h, r, -1*X_x(2*u-P*l)/2, X_x(2*u-P*l)/2, Q, S-A, P, P_array); 
    
    %Updating P using a Mobius scheme (method 3):
    elseif method == 3
    P = mobius(h, -1*X_x(2*u-P*l)/2, X_x(2*u-P*l)/2, Q, S-A, P);    
    end
        
    %Updating X_n using Euler's method - geometric:
    X_n = X_n*expm(h*fX(P, u, l));
    
    t = t + h; 
end
end




%Angular velocity simulation:
function O = find_O(t, type)
% w1_n = rand(1);
% w2_n = rand(1);
% w3_n = rand(1);
% O = [w1_n; w2_n; w3_n];
if type <= 1
O = [sin(2*pi*t/15); -1*sin(2*pi*t/18 + pi/20); cos(2*pi*t/17)];

elseif type == 2
O = sin(2*pi*t/150)*[1;-1;1];

end
end

%Gain equation - used for Euler's method (non-geometric):
function dP = fP(Q, P, u, S, A, l)
dP = Q + Ps(P*X_x(2*u-P*l)) - P*S*P + P*A*P;
end

%Relating gain to X_n:
function dX = fX(P, u, l)    
dX = X_x(u - P*l);
end

%%%
%Used in fX:
% function X = vex(X_x)
% X = zeros(3,1);
% X(1) = X_x(3,2);
% X(2) = X_x(1,3);
% X(3) = X_x(2,1);
% end
% 
% function Pa = Pa(X)
% Pa = (X - X')/2;    
% end

%%%

%Lower index opperator:
function X_x = X_x(v)
X_x = [0, -1*v(3), v(2); v(3), 0, -1*v(1); -1*v(2), v(1), 0];
end

%Symmetric projection:
function sym = Ps(X)
sym = (X + X')/2;
end

%Adding noise:
%(remember to normalise y1 and y2!)
function X_noisy = X_noisy(M, k)
X_noisy = M + k * randn(3,1);
end

%Working out S:
function S = find_S(y1, y2, R1, R2)
S = X_x(y1)'*inv(R1)*X_x(y1) + X_x(y2)'*inv(R2)*X_x(y2);
end

%Working out C:
function C = find_C(y1_n, y2_n, y1, y2, R1, R2)
C = Ps(inv(R1)*(y1_n-y1)*y1_n') + Ps(inv(R2)*(y2_n-y2)*y2_n');   
end    

%Working out A:
function A = find_A(C)
A = trace(C)*eye(3) - C;    
end    

%Working out l:
function l = find_l(R_1, R_2, y1, y2, y1_meas, y2_meas)    
l = cross((inv(R_1)*(y1 - y1_meas)),y1) + cross((inv(R_2)*(y2 - y2_meas)),y2);
end
