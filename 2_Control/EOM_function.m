function [dX] = EOM_function(t, X)
load('u.mat');

d2theta_0 = get_d2theta_0(X,u);

d2theta_1 = get_d2theta_1(X,u);

d2theta_2 = get_d2theta_2(X,u);

dX = [X(4); X(5); X(6); d2theta_0; d2theta_1; d2theta_2];
end