EOM;

syms d2theta_0 d2theta_1 d2theta_2

dx_struct = solve(eq0,eq1,eq2,d2theta_0,d2theta_1,d2theta_2);

d2theta_0 = dx_struct.d2theta_0;
d2theta_1 = dx_struct.d2theta_1;
d2theta_2 = dx_struct.d2theta_2;

%Print equation to txt files
matlabFunction(dx_struct.d2theta_0, 'file', 'd2theta_0.txt');
matlabFunction(dx_struct.d2theta_1, 'file', 'd2theta_1.txt');
matlabFunction(dx_struct.d2theta_2, 'file', 'd2theta_2.txt');