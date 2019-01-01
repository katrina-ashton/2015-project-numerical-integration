    function t_y_array = euler_m(X_n, Ref, Ref_mid, t_0, h, t_max)
    n = 0;
    t_n = t_0 + n*h;
    t_y_array = [];
    %length_1 = 
    %length_2 =
    %length_3 =

    while t_n <= t_max
        
        figure
        quiver3(Ref_mid, Ref_mid, Ref_mid, Ref(:,1), Ref(:,2), Ref(:,3))
        oa = oaxes;
        set(oa,'XColor','b','YColor',[0 .5 0],'ZColor','r','Linewidth',2,...
        'HideParentAxes','off')
        
        %scatter3(Ref(1,1), Ref(2,1), Ref(3,1), '*', 'b'); hold on
        %scatter3(Ref(1,2), Ref(2,2), Ref(3,2), 'o', 'b'); hold on
        %scatter3(Ref(1,3), Ref(2,3), Ref(3,3), '+', 'b'); hold on
        
        view
        
        Ref = Ref*X_n;
        t_y_array = [t_y_array; Ref];
        
       
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
    
