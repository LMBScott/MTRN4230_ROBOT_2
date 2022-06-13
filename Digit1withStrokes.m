% Author: Raghav Hariharan (z5162972)
% 3/06/2022
% For MTRN4230 2022
% This is an example program demonstrating how to use the RTDE library to
% draw the digit 1 with strokes mimicing a human. 

clear all;


% Setting up the connection to the UR5e
% TCP Host and Port settings
host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VM
% host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
port = 30003;

% Calling the constructor of rtde to setup tcp connction
rtde = rtde(host,port);

% Creating some home and start points
home = [-588.53, -133.30, 371.91, 2.2214, -2.2214, 0.00];
start = [-588.53, -133.30, 71.91, 2.2214, -2.2214, 0.00];

% The different points that the robot needs to move to inorder to trace the
% digit 1

% Note these are set to arbitrary values just for the sake of demonstration.
% You will need to change the actual points to match up with where they
% need to be drawn on the A4 paper.
point0 = [-588.53, -133.30, 60, 2.2214, -2.2214, 0.00];
point1 = [-598.53, -128.30, 60, 2.2214, -2.2214, 0.00];
point2 = [-567.53, -128.30, 60, 2.2214, -2.2214, 0.00];
point3 = [-567.53, -133.30, 60, 2.2214, -2.2214, 0.00];
point4 = [-567.53, -123.30, 60, 2.2214, -2.2214, 0.00];

% Here I have defined the arc's required by the movec
arc1 = [-593.53, -130.80, 65, 2.2214, -2.2214, 0.00];
arc2 = [-567.53, -130.80, 65, 2.2214, -2.2214, 0.00];

% Play around with these values for movec. 
a = 0.1;    % Tool Acceleration
v = 0.01;   % Tool Velocity
r = 0;      % Blend radius

poses = rtde.movel(home);
poses = rtde.movel(start);
poses = rtde.movel(point1);
poses = cat(1,poses,rtde.movel(point0));
poses = cat(1,poses,rtde.movec(arc1,point1,'pose',a,v,r));
poses = cat(1,poses,rtde.movel(point2));
poses = cat(1,poses,rtde.movec(arc2,point3,'pose',a,v,r)); 
poses = cat(1,poses,rtde.movel(point4));

rtde.movej(home);


% Plot the poses
rtde.drawPath(poses);


% Close the TCP connection
rtde.close();
