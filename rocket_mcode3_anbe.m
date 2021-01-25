
clear;
clc

P_initial=1000000; 
d_rocket=0.1; 
d_nozzle=0.025; 
h_rocket=1.5; 
V_water=0.0005; 
W_rocket=0.200; 
V_total=0.001; 
P_atm=101325; 
k=1.4; 
rho_water=998.23; 
T_initial=293; 
rho_air=1.2; 
C_d=0.3; 
g=9.81; 
A_nozzle=pi*(d_nozzle/2)^2;
t=0.001;

%calculating volume flow rate
V_air=V_total-V_water;
V=[V_air];
P=[P_initial];
i=1;
while V(i)<V_total
    P(i)=P_initial*(V_air/V(i))^k;
    V(i+1)=V(i)+t*sqrt((2*(P(i)-P_atm))/rho_water)*A_nozzle;
    i=i+1;
end
V(length(V))=[];
t_thrust =t*(length(V));
%%

%calculating thrust
F_thrust=(sqrt(2*(P-P_atm)/rho_water)).^2*A_nozzle*rho_water;

%calculating mass
Mass=W_rocket + (rho_water*(V_total-V));

%calculating acceleration and veloci
Acc=F_thrust./Mass;
v_thrust=Acc*t_thrust;
H_thrust=0;
i=1;
while(i<=length(v_thrust))
    H_thrust(i+1)=H_thrust(i)+(v_thrust(i)*t);
    i=i+1;
end

T=length(H_thrust);
time_thrust=[0:0.001:t_thrust];

j=1;
t=0.1;
v_projectile=[v_thrust(end)];
H_projectile=[H_thrust(end)];

 while(v_projectile(j)>0)
    H_projectile(j+1)=H_projectile(j)+(v_projectile(j)*t)-(g*(t^2))/2;
    v_projectile(j+1)=v_projectile(j)-(g*t);
    j=j+1;
   
 end
 v_projectile(j)=0;
v_ground=sqrt(2*g*H_projectile(end));
while(v_projectile(j)<=v_ground)
    H_projectile(j+1)=H_projectile(j)-(v_projectile(j)*t)+(g*(t^2))/2;
    v_projectile(j+1)=v_projectile(j)+(g*t);
    j=j+1;
   
end

subplot(2,3,1);
plot(time_thrust(2:end),Acc);
xlabel('Time (s)');
ylabel('Thrust Accelaration (m/s^2)');
grid on;

subplot(2,3,2);
plot(time_thrust(2:end),v_thrust);
xlabel('Time (s)');
ylabel('Thrust velocity (m/s)');
grid on;


 subplot(2,3,3);
 plot(time_thrust,H_thrust);
 xlabel('Thrust Time (s)');
 ylabel('Thrust Height (m)');
 grid on;
 
 T=t*length(H_projectile);
 time=[t_thrust:0.1:T];
 
 subplot(2,3,4);
plot(time,v_projectile);
xlabel('Time (s)');
ylabel('Projectile Velocity (m/s)');
grid on;

T=t*length(H_projectile);
time=[t_thrust:0.1:T];
subplot(2,3,5);
plot(time,H_projectile);
xlabel('Time (s)');
ylabel('Projectile Height (m)');
grid on;

%% configure simulink by script 
% close all;%just for disabling your figures;

height_sim = timeseries(H_projectile,time);

mdl = 'rocketSim_externalValues';
load_system(mdl)
%configure simulink model
%I use a fixed step Solver because you have fixed time steps
%for your simulation. The timesteps itself should be set to auto.
%simulink will adapt to your external data timesteps
set_param(mdl,'StopTime','time(end)'...
    ,'SimulationMode','Normal'...
    ,'Solver','FixedStepAuto');

  sim(mdl);% execute the simulation




