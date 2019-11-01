%% Description
% Project ECE 289
% Control and simulation of nonlinear open-loop unstable system using
% Linear quadratic regulator strategy
% Morten Lie 
% Fall 2017

% System is based on a double linked arm connected to a disc which is able
% to spin about it's centroid. For the controlled case, a motor is
% connected to the disc, trying to stabilize the freely movable links to
% the upright position. 

% Sit back, press F5 and enjoy! :) 

clear all;
clc;
close all;
warning('off');

%% Linearize system
% Equilibrium point
X_eq = [pi/2;0;0;0;0;0];
U_eq = 0;

[A,B,C,D] = getSystemMatrices(X_eq,U_eq);

%% Controllability check
disp('Performing controllability check...');
controllability = [B A*B A^2*B A^3*B A^4*B A^5*B];
if rank(controllability) == size(A,1)
    disp('System is controllable! ');
else
    disp('System is uncontrollable!');
end

%% Apply LQR Control
Q = diag([10 5 5 1 1 1]);
R = 0.1;
K = lqr(A,B,Q,R);

Q_linear = diag([1 0 0 0 0 0]);
R_linear = 1;
K_linear = lqr(A,B,Q_linear,R_linear);

%% Closed loop poles
closed_loop_poles = eig(A-B*K);
fprintf('\nClosed loop poles are\n %d, %d, %d, %d, %d, %d\n\n\n\n',closed_loop_poles(1),closed_loop_poles(2),closed_loop_poles(3),closed_loop_poles(4),closed_loop_poles(5),closed_loop_poles(6));

%% Simulation part 2
input('Press enter to proceed to simulation');
t_start = 0;
dt = 0.01;
t_end = 5;
t = t_start:dt:t_end;
X = zeros(6,length(t));
X(:,1) = [pi/2;pi/25;0;0;0;0];

for i = 1:length(t)
    u = 0;
    save('u.mat','u');  
    [tout, Xout] = ode45(@EOM_function,t_start:dt:2*dt,X(:,i)');
    X(:,i+1) = Xout(2,:)';
    fprintf('Open loop simulation progress: %d%%\n',floor(i/(length(t)-1)*100));
end
fprintf('Open loop simulation finished!\n\n\n');

%%  Animation part 2
input('Press enter to animate system without controls');
show_animation = 'y';
while strcmp(show_animation,'y')
    for i = 1:length(t)
        draw_disclink(X(:,i),i*dt,0);
        pause(0.005);
    end
    close;
    show_animation = input('Replay animation? [y/n]\n','s');
end


%% Simulation part 3d
X1 = zeros(6,length(t));
X1(:,1) = [pi/2;pi/100;0;0;0;0];
X1_ref = X_eq;
u1_matrix = zeros(1,length(t));

quit = 0;
for i = 1:length(t)-1
    tic;
    u1_matrix(1,i) = K*(X1_ref - X1(:,i));
    if abs(u1_matrix(1,i)) > 10000 || quit == 1
        if quit == 0
            input('The system just went unstable, hit enter to continue');
            quit = 1;
        end
        u1_matrix(1,i) = 0;
    end
    u = u1_matrix(1,i);
    
    save('u.mat','u');
    
    [tout, Xout] = ode45(@EOM_function,t_start:dt:2*dt,X1(:,i)');
    X1(:,i+1) = Xout(2,:)';
    fprintf('First simulation of system with controls progress: %d%%\n',floor(i/(length(t)-1)*100));
end
fprintf('Simulation of system with controls finished!\n\n\n');

% Linear simulation
sys = ss(A-B*K_linear,[],C,[]);
[~,T1_linear,X1_linear] = initial(sys,X1(:,1),t_end);
X1_linear = X1_linear';
T1_linear = T1_linear';

%%  Animation part 3d
input('Press enter to animate system with controls, part 3d');
show_animation = 'y';
while strcmp(show_animation,'y')
    for i = 1:length(t)
        draw_disclink(X1(:,i),i*dt,u1_matrix(1,i));
        pause(0.005);
    end
    close;
    show_animation = input('Replay animation? [y/n]\n','s');
end

%% Simulation part 3e
X2 = zeros(6,length(t));
X2(:,1) = [pi/2;pi/25;0;0;0;0];
X2_ref = X_eq;

u2_matrix = zeros(1,length(t));

quit = 0;
for i = 1:length(t)-1
    tic;
    u2_matrix(1,i) = K*(X2_ref - X2(:,i));
    if abs(u2_matrix(1,i)) > 10000 || quit == 1
        if quit == 0
            input('The system just went unstable, hit enter to continue');
            quit = 1;
        end
        u2_matrix(1,i) = 0;
    end
    u = u2_matrix(1,i);
    
    save('u.mat','u');
    
    [tout, Xout] = ode45(@EOM_function,t_start:dt:2*dt,X2(:,i)');
    X2(:,i+1) = Xout(2,:)';
    fprintf('Second simulation of system with controls progress: %d%%\n',floor(i/(length(t)-1)*100));
end
fprintf('Simulation of system with controls finished!\n\n\n');

% Linear simulation
sys = ss(A-B*K_linear,[],C,[]);
[~,T2_linear,X2_linear] = initial(sys,X2(:,1),t_end);
X2_linear = X2_linear';
T2_linear = T2_linear';

%%  Animation part 3e
input('Press enter to animate system with controls, part 3e');
show_animation = 'y';
    while strcmp(show_animation,'y')
    for i = 1:length(t)
        draw_disclink(X2(:,i),i*dt,u2_matrix(1,i));
        pause(0.005);
    end
    close;
    show_animation = input('Replay animation? [y/n]\n','s');
    end

%% Plots part 3d
input('Press enter to view the plots');
close all;

f1 = figure(1); movegui(f1,'northwest');
hold on;
plot(t,X1(1,:),'b');
plot(t,X1_ref(1,1)*ones(1,length(t)),'b--');
plot(t,X1(2,:),'r');
plot(t,X1(3,:),'y');
plot(t,X1(4,:),'c');
plot(t,X1(5,:),'k');
plot(t,X1(6,:),'g');
hold off;
xlabel('Time [s]');
ylabel('Angle and Angular velocity Rad/Rad[s]');
h1 = legend('$\theta_0$','$\theta_{0 r}$','$\dot{\theta}_0$','$\theta_1$','$\dot{\theta_1}$','$\theta_2$','$\dot{\theta_2}$');
set(h1,'Interpreter', 'latex');
title('Nonlinear states with initial condition close to equlibrium');
grid on;

f2 = figure(2); movegui(f2,'north');
hold on;
plot(T1_linear,X1_linear(1,:),'b--');
plot(T1_linear,X1_linear(2,:),'r--');
plot(T1_linear,X1_linear(3,:),'y--');
plot(T1_linear,X1_linear(4,:),'c--');
plot(T1_linear,X1_linear(5,:),'k--');
plot(T1_linear,X1_linear(6,:),'g--');
hold off;
xlabel('Time [s]');
ylabel('Angle and Angular velocity Rad/Rad[s]');
h2 = legend('$\theta_0$','$\dot{\theta}_0$','$\theta_1$','$\dot{\theta_1}$','$\theta_2$','$\dot{\theta_2}$');
set(h2,'Interpreter', 'latex');
title('Linear states with initial condition close to equlibrium');
grid on;

f3 = figure(3); movegui(f3,'northeast');
hold on;
plot(t,u1_matrix(1,:));
plot(t,u2_matrix(1,:));
hold off;
xlabel('Time [s]');
ylabel('Torque [Nm]');
title('Actuator (Torque on disc)');
legend('u small perturbation','u large perturbation');
grid on;

%% Plots part 3e
f4 = figure(4); movegui(f4,'southwest');
hold on;
plot(t,X2(1,:),'b');
plot(t,X2_ref(1,1)*ones(1,length(t)),'b--');
plot(t,X2(2,:),'r');
plot(t,X2(3,:),'y');
plot(t,X2(4,:),'c');
plot(t,X2(5,:),'k');
plot(t,X2(6,:),'g');
hold off;
xlabel('Time [s]');
ylabel('Angle and Angular velocity Rad/Rad[s]');
h3 = legend('$\theta_0$','$\theta_{0 r}$','$\dot{\theta}_0$','$\theta_1$','$\dot{\theta_1}$','$\theta_2$','$\dot{\theta_2}$');
set(h3,'Interpreter', 'latex');
title('Nonlinear states with initial condition ''far'' from equlibrium');
grid on;

f5 = figure(5); movegui(f5,'south');
hold on;
plot(T2_linear,X2_linear(1,:),'b--');
plot(T2_linear,X2_linear(2,:),'r--');
plot(T2_linear,X2_linear(3,:),'y--');
plot(T2_linear,X2_linear(4,:),'c--');
plot(T2_linear,X2_linear(5,:),'k--');
plot(T2_linear,X2_linear(6,:),'g--');
hold off;
xlabel('Time [s]');
ylabel('Angle and Angular velocity Rad/Rad[s]');
h4 = legend('$\theta_0$','$\dot{\theta}_0$','$\theta_1$','$\dot{\theta_1}$','$\theta_2$','$\dot{\theta_2}$');
set(h4,'Interpreter', 'latex');
title('Linear states with initial condition ''far'' from equlibrium');
grid on;


%% Make a movie of the solution
%{
if strcmp(input('Do you want to make a movie of your solution? [y/n]\n','s'),'y')
    disp('Movie making started');
    outputVideo = VideoWriter('Disclink_animation.avi');
    outputVideo.FrameRate = length(t)/t_end;
    open(outputVideo)
    for i = 1:length(t)
        simulation_shot = draw_disclink_movie(X2(:,i));
        writeVideo(outputVideo,simulation_shot)
        fprintf('Movie making progress: %d%%\n',floor(i/length(t)*100));
    end
    close(outputVideo);
end
%}