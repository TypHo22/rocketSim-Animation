clear all;
close all;
meas = readtable('externalDataExample.csv');

%creating timeseries data
xTPos_sim = timeseries(meas.xTPos,meas.t);
yTPos_sim = timeseries(meas.yTPos,meas.t);
zTPos_sim = timeseries(meas.zTPos,meas.t);
xRPos_sim = timeseries(meas.xRPos,meas.t);
yRPos_sim = timeseries(meas.yRPos,meas.t);
zRPos_sim = timeseries(meas.zRPos,meas.t);
% height_sim = timeseries(H_projectile,time);
% 
mdl = 'rocketSim_externalValues';
load_system(mdl)
%configure simulink model
%I use a fixed step Solver because you have fixed time steps
%for your simulation. The timesteps itself should be set to auto.
%simulink will adapt to your external data timesteps
set_param(mdl,'StopTime','meas.t(end)'...
    ,'SimulationMode','Normal'...
    ,'Solver','FixedStepAuto');

  sim(mdl);% execute the simulation