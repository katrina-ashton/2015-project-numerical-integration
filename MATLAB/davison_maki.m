%Using Kenney and Leipnik's modified version
%(Bottom of pg 4)
function X = davison_maki(h, A, B, Q, R, X)
%Fundamental solution matrix:
mat = [-1*A, R;Q, B];

%Updating X:
X = (mat(4:6,1:3)*h + mat(4:6,4:6)*h*X)*inv(mat(1:3,1:3)*h+mat(1:3,4:6)*h*X);
end
