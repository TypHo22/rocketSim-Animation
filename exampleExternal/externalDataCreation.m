%% externalDataExample
% This example shows how to read data from an external resource for the
% waterrocket project.
%% Andreas Bernatzky 25.01.2020

%% creation of example
% t = transpose(0:1:99);
% xTPos = rand(100,1);
% yTPos = rand(100,1);
% zTPos = linspace(0,50,100)';
% xRPos = rand(100,1);
% yRPos = rand(100,1);
% zRPos = rand(100,1);
% toCSV = table(t,...
%     xTPos,yTPos,zTPos,... 
%     xRPos,yRPos,zRPos);
% writetable(toCSV,"externalDataExample.csv");

%% readin

measurement = readtable('externalDataExample.csv');