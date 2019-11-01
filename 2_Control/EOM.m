

%clear all; format compact

% Symbolic variables
syms m_0 m_1 m_2 g r r_ee L1 L2 theta_0 theta_1 theta_2 tau b

%Generalized coordinates
GC = [{theta_0}, {theta_1}, {theta_2}];
dtheta_0 = fulldiff(theta_0,GC);
dtheta_1 = fulldiff(theta_1,GC);
dtheta_2 = fulldiff(theta_2,GC);

% Geometry of masses (Center of gravity in center of links)
x_1 = r_ee*cos(theta_0)+1/2*L1*cos(theta_0+theta_1);
y_1 = r_ee*sin(theta_0)+1/2*L1*sin(theta_0+theta_1);
x_2 = r_ee*cos(theta_0)+L1*cos(theta_0+theta_1)+1/2*L2+cos(theta_0+theta_1+theta_2);
y_2 = r_ee*sin(theta_0)+L1*sin(theta_0+theta_1)+1/2*L2+sin(theta_0+theta_1+theta_2);

% Velocity terms
dx_1 = fulldiff(x_1,GC);
dy_1 = fulldiff(y_1,GC);
dx_2 = fulldiff(x_2,GC);
dy_2 = fulldiff(y_2,GC);

% Kinetic energy
T = 1/4*m_0*r^2*dtheta_0^2 + 1/2*m_1*(dx_1^2+dy_1^2)+1/2*m_2*(dx_2^2+dy_2^2); %Found bug, dtheta_1 --> dtheta_0

% Potential energy
V = m_1*g*y_1 + m_2*g*y_2;

% Lagrangian
L = T - V;

% Non-conservative terms
Xi0 = tau-b*dtheta_0;
Xi1 = -b*dtheta_1;
Xi2 = -b*dtheta_2;

% EOMs
eq0 = fulldiff(diff(L,dtheta_0),GC) - diff(L,theta_0) == Xi0;
eq1 = fulldiff(diff(L,dtheta_1),GC) - diff(L,theta_1) == Xi1;
eq2 = fulldiff(diff(L,dtheta_2),GC) - diff(L,theta_2) == Xi2;

