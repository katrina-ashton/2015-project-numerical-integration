function X = choi(h, r, A, B, Q, R, X, X_array)
A_bar = find_A_bar(r,A,h);
B_bar = find_B_bar(r,B,h);
Q_bar = find_Q_bar(r,Q,h,X_array);
R_bar = find_R_bar(r,R,h);

X = sylvester((B_bar - X*R_bar), (A_bar - R_bar*X), -1*(Q_bar + X*R_bar*X));
end


function A_bar = find_A_bar(r,A,h)
sum = 0;
    for i = 1:r
        sum = sum + 1/i;
    end
A_bar = (-1*sum/2)*eye(3) + h*A;
end

function B_bar = find_B_bar(r,B,h)
sum = 0;
    for i = 1:r
        sum = sum + 1/i;
    end
B_bar = (-1*sum/2)*eye(3) + h*B;
end

function Q_bar = find_Q_bar(r,Q,h,X_array)
sum = 0;
if size(X_array, 2)/3 - 1 < r
    for i = 1:r
        sum = sum + (((-1)^(i-1))/i)*nchoosek(r,i)*X_array(:,1:3);
    end
else    
    for i = 1:r
        k = size(X_array, 2)/3 - 1;
        sum = sum + (((-1)^(i-1))/i)*nchoosek(r,i)*X_array(:,(3*(k-i+1)+1):(3*(k-i+1)+3));
    end
end
Q_bar = sum + h*Q;
end

function R_bar = find_R_bar(r,R,h)
R_bar = h*R;
end