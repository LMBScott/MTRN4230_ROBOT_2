% Author: Raghav Hariharan
% 29/05/2022
% For MTRN4230 2022
clear all;
startup_rvc;

%% ----- EXAMPLE: Pose Transformation Example-----
% Setting up the connection to the UR5e
% TCP Host and Port settings
host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VM
% host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
port = 30003;

% Calling the constructor of rtde to setup tcp connction
rtde = rtde(host,port);


% Defining points

% Let the zero pose be the origin.
% This is the robot's base frame. 
% This is where the robot is mounted to the table.
zero = [0, 0, 0, 0, 0, 0];

% Let the home position of the robot be the following:
home = [-588.53, -133.30, 371.91, 2.2214, -2.2214, 0.00];

%% TRANSLATION ONLY
% The following specifies the translation of the paper frame. Specifically it
% indicates the bottom left hand corner. 
% For now, it has no rotation associated with it.
paper = [-600, -150, 60, 2.2214, -2.2214, 0.00];


% The following points indicate a square.

point1 = [0,0,0];
point2 = [100,0,0];
point3 = [100,100,0];
point4 = [0,100,0];

% How do we draw a square in the paper's frame of reference?
% We translate it up to the Paper's reference
poses = rtde.movej(home);

poses = cat(1,poses,rtde.movel([point1 + paper(1:3),paper(4:6)]));
poses = cat(1,poses,rtde.movel([point2 + paper(1:3),paper(4:6)]));
poses = cat(1,poses,rtde.movel([point3 + paper(1:3),paper(4:6)]));
poses = cat(1,poses,rtde.movel([point4 + paper(1:3),paper(4:6)]));
poses = cat(1,poses,rtde.movel([point1 + paper(1:3),paper(4:6)]));

poses = cat(1,poses,rtde.movel(home));

%% ROTATION + TRANSLATION
% What if the paper frame did have a rotation with it?
paper = [-600, -150, 60, 2.2214, -2.2214, 0.00];
angle = 30; % -30 degrees

% multiple the point by the rotation angle then translate it to the paper
% frame.
% point * rotz + translation
poses = cat(1,poses,rtde.movel([point1*rotz(angle,'deg') + paper(1:3),paper(4:6)]));
poses = cat(1,poses,rtde.movel([point2*rotz(angle,'deg') + paper(1:3),paper(4:6)]));
poses = cat(1,poses,rtde.movel([point3*rotz(angle,'deg') + paper(1:3),paper(4:6)]));
poses = cat(1,poses,rtde.movel([point4*rotz(angle,'deg') + paper(1:3),paper(4:6)]));
poses = cat(1,poses,rtde.movel([point1*rotz(angle,'deg') + paper(1:3),paper(4:6)]));

poses = cat(1,poses,rtde.movel(home));

%% PLOTTING
%First lets plot some coordiante axes using the RVC Toolbox
figure;
hold on;
T0 = SE2(0,0,0,'deg');
trplot2(T0, 'frame', 'origin', 'color', 'c');
T1 = SE2(-0.600,-0.15,0,'deg');
trplot2(T1, 'frame', 'paper', 'color', 'r');
T2 = SE2(-0.600,-0.15,30,'deg'); % Note here we used 30 not -30. As for some reason the rotation is flipped.
trplot2(T2, 'frame', 'paper rotated 30 deg', 'color', 'g');


% Now lets plot the trajectory of the robot
line(poses(:,1), poses(:,2),poses(:,3));
view(3);
title('TCP path')
xlabel('x-axis'); 
ylabel('y-axis');
zlabel('z-axis');


% Closing the TCP Connection
rtde.close();







