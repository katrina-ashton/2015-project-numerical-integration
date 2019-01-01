function t_y_array = euler_m_frame(X_n, Ref, Ref_mid, t_0, h, t_max, lim, pt)
n = 0;
t_n = t_0 + n*h;
t_y_array = [];
Ori = Ref;

    while t_n <= t_max
        %quiver3(Ref_mid, Ref_mid, Ref_mid, Ref(:,1), Ref(:,2), Ref(:,3))

        clf;
        
        quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori(1,1), Ori(1,2), Ori(1,3), 'r', 'LineWidth', 3); hold on
        quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori(2,1), Ori(2,2), Ori(2,3), 'b', 'LineWidth', 3); hold on
        quiver3(Ref_mid(1, 1), Ref_mid(2, 1), Ref_mid(3, 1), Ori(3,1), Ori(3,2), Ori(3,3), 'g', 'LineWidth', 3); hold on
        
        %scatter3(Ref(1,1), Ref(2,1), Ref(3,1), '*', 'b'); hold on
        %scatter3(Ref(1,2), Ref(2,2), Ref(3,2), 'o', 'b'); hold on
        %scatter3(Ref(1,3), Ref(2,3), Ref(3,3), '+', 'b'); hold on
        
        axis([-1*lim, lim, -1*lim, lim, -1*lim, 1*lim]);
        pause(pt);
        
        
        Ori = Ref*X_n;
        t_y_array = [t_y_array; Ori];
        
       
        n = n + 1;

        X_n = X_n + h*f(t_n, X_n);

        t_n = t_0 + n*h;
    end

end


function [f] = f(t_n, X_n)
Ox_n = Ox(t_n);
f = X_n*Ox_n;
end

function Ox_n = Ox(t_n)
% Would normally get angular velocities from hardware.
% Had this relying on t so it can actually change at each step.
w1_n = 1;
w2_n = 1;
w3_n = 1;
Ox_n = [0, -1*w3_n, w2_n; w3_n, 0, -1*w1_n; -1*w2_n, w1_n, 0];
end
    
