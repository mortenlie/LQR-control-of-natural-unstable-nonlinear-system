function [ A,B,C,D ] = getSystemMatrices( X_eq,U_eq )
disp('Calculating the equations of motion...');
% Calculate the transition function x_dot = f(x,u)
syms d2theta_0 d2theta_1 d2theta_2
EOM;
dx_struct = solve(eq0,eq1,eq2,d2theta_0,d2theta_1,d2theta_2);
f = [dtheta_0;dtheta_1;dtheta_2;dx_struct.d2theta_0;dx_struct.d2theta_1;dx_struct.d2theta_2];


%% Perform the linearization
disp('Performing linearization...');
A_func = [ diff(f(1),theta_0)     diff(f(1),theta_1)     diff(f(1),theta_2)    diff(f(1),dtheta_0)    diff(f(1),dtheta_1)    diff(f(1),dtheta_2);
           diff(f(2),theta_0)     diff(f(2),theta_1)     diff(f(2),theta_2)    diff(f(2),dtheta_0)    diff(f(2),dtheta_1)    diff(f(2),dtheta_2);
           diff(f(3),theta_0)     diff(f(3),theta_1)     diff(f(3),theta_2)    diff(f(3),dtheta_0)    diff(f(3),dtheta_1)    diff(f(3),dtheta_2);
           diff(f(4),theta_0)     diff(f(4),theta_1)     diff(f(4),theta_2)    diff(f(4),dtheta_0)    diff(f(4),dtheta_1)    diff(f(4),dtheta_2);
           diff(f(5),theta_0)     diff(f(5),theta_1)     diff(f(5),theta_2)    diff(f(5),dtheta_0)    diff(f(5),dtheta_1)    diff(f(5),dtheta_2);
           diff(f(6),theta_0)     diff(f(6),theta_1)     diff(f(6),theta_2)    diff(f(6),dtheta_0)    diff(f(6),dtheta_1)    diff(f(6),dtheta_2)];

B_func = [ diff(f(1),tau);
           diff(f(2),tau);
           diff(f(3),tau);
           diff(f(4),tau);      
           diff(f(5),tau);
           diff(f(6),tau)];

C = ones(1,6);

D = 0;

system_constants;
theta_0 = X_eq(1);
theta_1 = X_eq(2);
theta_2 = X_eq(3);
dtheta_0 = X_eq(4);
dtheta_1 = X_eq(5);
dtheta_2 = X_eq(6);
tau = U_eq;

A = double(subs(A_func));
B = double(subs(B_func));
end

