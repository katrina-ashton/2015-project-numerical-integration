 function error_array = MEKF_q(h, r, t_0, t_max, pt, lim, Ref, Ref_mid, y1_d, y2_d, b_n, q_n_t, q_n, B_o, B_b, D_1, D_2, Pa, Pb, Pc)
t = t_0;
Q_o = B_o*B_o';
Q_b = B_b*B_b';
R_1 = D_1*D_1';
R_2 = D_2*D_2';
Ori = Ref;
Ori_t = Ref;
error_array = [];
Pa_array = Pa;

while t <= t_max
    O = find_O(t);
    y1 = find_yi(q_n_t, y1_d);
    y2 = find_yi(q_n_t, y2_d);
    u = X_noisy(O, B_o);
    y1_meas = X_noisy(y1, D_1);
    y2_meas = X_noisy(y2, D_2);
    y1_meas = y1_meas/norm(y1_meas);
    y2_meas = y2_meas/norm(y2_meas);
    S = find_S(y1_meas, y2_meas, R_1, R_2);
    y1_n = find_yi(q_n, y1_d);
    y2_n = find_yi(q_n, y2_d);
    
    %%%
    %Frame:
%     clf;
%         
%     quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori(1,1), Ori(1,2), Ori(1,3), 'r', 'LineWidth', 3); hold on
%     quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori(2,1), Ori(2,2), Ori(2,3), 'b', 'LineWidth', 3); hold on
%     quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori(3,1), Ori(3,2), Ori(3,3), 'g', 'LineWidth', 3); hold on
%     
%     quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori_t(1,1), Ori_t(1,2), Ori_t(1,3), 'k', 'LineWidth', 3); hold on
%     quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori_t(2,1), Ori_t(2,2), Ori_t(2,3), 'k', 'LineWidth', 3); hold on
%     quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori_t(3,1), Ori_t(3,2), Ori_t(3,3), 'k', 'LineWidth', 3); hold on
% 
%     axis([-1*lim, lim, -1*lim, lim, -1*lim, 1*lim]);
%     pause(pt);   
% 
%     Ori = Ref*quat2rot(q_n);
%     Ori_t = Ref*quat2rot(q_n_t);
    %%%
    
    %Comparing true to estimate:
    error_angle = 2*acos(abs(q_n'*q_n_t));
    error_array = [error_array; t, error_angle];
    
    u_x = X_x(u);
    
    
    %%%%
    Pa_old = Pa;
    Pb_old = Pb;
    Pc_old = Pc;
    
    %Euler's method non-geometric:
    Pa = Pa + h*fPa(Q_o, Pa_old, Pc_old, u, S, b_n);
    Pb = Pb + h*fPb(Q_b, Pc_old, S);
    Pc = Pc + h*fPc(u, b_n, Pc_old, Pa_old, S, Pb_old);
    
    %Choi's method:
    
    Pa_array = [Pa_array, Pa];
    
    %%%%
    
    
    %Need to implement bias observer and delta
    del = cross(y1_n, inv(R_1)*(y1_n - y1_meas)) + cross(y2_n, inv(R_2)*(y2_n - y2_meas));
    b_n = b_n + fb(Pc, del);
    
    %Updating q_n and q_n_t - Euler method non-geometric:
    q_n = q_n + h*(A(u - b_n - Pa*del)*q_n/2);
    q_n_t = q_n_t + h*(A(O)*q_n_t/2);
    
    %Norming q_n and q_n_t:
    q_n = q_n/norm(q_n);
    q_n_t = q_n_t/norm(q_n_t);
    
    t = t + h; 
end

end


%Angular velocity simulation:
function O = find_O(t)
% w1_n = rand(1);
% w2_n = rand(1);
% w3_n = rand(1);
% O = [w1_n; w2_n; w3_n];
O = [sin(2*pi*t/15); -1*sin(2*pi*t/18 + pi/20); cos(2*pi*t/17)];
end

%%%
%Gain equations:
function dPa = fPa(Q_o, Pa, Pc, u, S, b_n)
dPa = Q_o + 2*Ps(Pa*X_x(u - b_n) - Pc) -Pa*S*Pa;
end

function dPb = fPb(Q_b, Pc, S)
%Not sure if should be Pc or Pc' - paper says Pc, code says Pc'
%But I think Pc is symmetric anyway... Or is that just P?
dPb = Q_b - Pc'*S*Pc;
end

function dPc = fPc(u, b_n, Pc, Pa, S, Pb)
dPc = -1*X_x(u - b_n)*Pc - Pa*S*Pc - Pb;
end

function db = fb(Pc, del)
db = Pc'*del;
end

%%%

%Relating gain to X_n:
% function dX = fX(P, X_n, u, R_1, R_2, y1, y2, y1_d, y2_d)    
% l = cross((inv(R_1)*(y1 - (X_n')*y1_d)),y1) + cross((inv(R_2)*(y2 - (X_n')*y2_d)),y2);
% %l = 2*vex(Pa(y1*(y1 - (X_n')*y1_d)'*inv(R_1)) + Pa(y2*(y2 - (X_n')*y2_d)'*inv(R_2)));
% dX = X_x(u - P*l);
% end

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

%Working out yi:
function yi = find_yi(q_n, yi_d)
yi = pinv(qm(qm(qinv(q_n), p(yi_d)), q_n));
end

%Used for working out yi:
%%%
%x is (3x1)
function p = p(x)
p = [0; x];
end

function pinv = pinv(x)
pinv = x(2:4);
end
%%%

%A - used in some differential equations with quaternions:
function Ax = A(x)
x_x = X_x(x);
Ax = [0, -1*x'; x, -1*x_x];
end

%Working out S:
function S = find_S(y1, y2, R1, R2)
S = X_x(y1)'*inv(R1)*X_x(y1) + X_x(y2)'*inv(R2)*X_x(y2);
end

%Quaternion multiplication:
function product = qm(q1, q2)
s1 = q1(1);
s2 = q2(1);
v1 = q1(2:4);
v2 = q2(2:4);
product = [s1*s2 - v1'*v2; s1*v2 + s2*v1 + cross(v1, v2)];
end

%Quaternion inverse:
function inverse = qinv(q)
inverse = [q(1); -1*q(2:4)];
end

%Quaternion to rotation:
function X = quat2rot(q)
s = q(1);
v = q(2:4);
X = eye(3) + 2*s*X_x(v) + 2*(X_x(v)^2);
end