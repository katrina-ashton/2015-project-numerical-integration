 function error_array = MEKF_euler(h, t_0, t_max, pt, lim, Ref, Ref_mid, y1_d, y2_d, X_n_t, X_n, B, D_1, D_2)
t = t_0;
Q = B*transpose(B);
R_1 = D_1*transpose(D_1);
R_2 = D_2*transpose(D_2);
Ori = Ref;
Ori_t = Ref;
error_array = [];
P = 0;

while t <= t_max
    O = find_O(t);
    y1 = transpose(X_n)*y1_d;
    y2 = transpose(X_n)*y2_d;
    u = X_noisy(O, B);
    y1_noisy = X_noisy(y1, D_1);
    y2_noisy = X_noisy(y2, D_2);
    S = find_S(y1_noisy, y2_noisy, R_1, R_2);
    
    %%%
    %Frame:
    clf;
        
    quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori(1,1), Ori(1,2), Ori(1,3), 'r', 'LineWidth', 3); hold on
    quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori(2,1), Ori(2,2), Ori(2,3), 'b', 'LineWidth', 3); hold on
    quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori(3,1), Ori(3,2), Ori(3,3), 'g', 'LineWidth', 3); hold on
    
    quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori_t(1,1), Ori_t(1,2), Ori_t(1,3), 'k', 'LineWidth', 3); hold on
    quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori_t(2,1), Ori_t(2,2), Ori_t(2,3), 'k', 'LineWidth', 3); hold on
    quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori_t(3,1), Ori_t(3,2), Ori_t(3,3), 'k', 'LineWidth', 3); hold on

    axis([-1*lim, lim, -1*lim, lim, -1*lim, 1*lim]);
    pause(pt);   
        
    Ori = Ref*X_n;
    Ori_t = Ref*X_n_t;
    %%%
    
    error_matrix = X_n*X_n_t';
    
    error_angle = acos((error_matrix(1,1) + error_matrix(2,2) + error_matrix(3,3) - 1)/2);
    
    error_array = [error_array; t, error_angle];
    
    O_x = X_x(O);
    
    X_n_t = X_n_t + h*X_n_t*O_x;
    
    P = P + h*fP(Q, P, u, S);
    
    X_n = X_n + h*fX(P, X_n, u, R_1, R_2, y1_noisy, y2_noisy, y1_d, y2_d);
    
    t = t + h; 
end




%Angular velocity simulation:
function O = find_O(t_n)
w1_n = 1;
w2_n = 1;
w3_n = 1;
O = [w1_n; w2_n; w3_n];
end

%Gain equation:
function dP = fP(Q, P, u, S)
dP = Q + P*X_x(u)/2 - X_x(u)*P/2 - P*S*P;
end

%Relating gain to X_n:
function dX = fX(P, X_n, u, R_1, R_2, y_1, y_2, y1_d, y2_d)    
K = P*(y_1'*inv(R_1) + y_2'*inv(R_2));    
dX = X_n*u + dot(K, (y_1 + y_2 - X_n'*y1_d - X_n'*y2_d));
end

%Lower index opperator:
function X_x = X_x(v)
X_x = [0, -1*v(3), v(2); v(3), 0, -1*v(1); -1*v(2), v(1), 0];
end

%Adding noise:
%(remember to normalise y1 and y2!)
function X_noisy = X_noisy(M, k)
X_noisy = M + k .* randn(3,1);
end

%Working out S:
function S = find_S(y1_noisy, y2_noisy, R_1, R_2)
S = transpose(X_x(y1_noisy))*inv(R_1)*X_x(y1_noisy) + transpose(X_x(y2_noisy))*inv(R_2)*X_x(y2_noisy);
end


end