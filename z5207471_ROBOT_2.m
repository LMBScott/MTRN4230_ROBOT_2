function z5207471_ROBOT_2(paperPos, digits)
    clear all;

    DEFAULT_PAPER_POS = [-588.53, -133.30, 0];
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    CHAR_WIDTH = 19.5;  % Character width in millimeters
    CHAR_HEIGHT = 22;  % Character height in millimeters
    CHAR_TOP_PADDING = 3;
    PLANE_Z_OFFSET = 60;    % Z-offset of flange from work plane in millimeters
    PAPER_MARGIN = 30;
    Z_CLEARANCE = 10; % Safe z-offset of TCP from work plane in millimeters

    if (~exist('paperPos', 'var'))
        paperPos = DEFAULT_PAPER_POS;
    end

    if (~exist('digits', 'var'))
        digits = '0123456789';
    end

    host = '127.0.0.1';
    port = 30003;
    ur5 = rtde(host, port);
    
    %transl(1,2); % Pure translation homogeneous transform
    %trot2(30, 'deg'); % Pure rotation homogeneous transform
    %T1 = se2(1, 2, 30, 'deg'); % Homogeneous transform
    %trplot2(T1, 'frame', '1', 'color', 'b'); % Plot homogeneous transform
    
    CHAR_WIDTH = 0.0195; % Character width in meters
    CHAR_HEIGHT = 0.032; % Character height in meters
    PLANE_Z_OFFSET = 60;   % Z-offset of TCP from work plane in millimeters 

    rot = rotz(paperPos(3), 'deg');
    
    home = [ paperPos(1), paperPos(2), PLANE_Z_OFFSET + Z_CLEARANCE ];

    currPos = home;
    nextPos = [ currPos(1), currPos(2) + PAPER_MARGIN, currPos(3)];

    poses = ur5.movel([ currPos, TOOL_DOWN_POSE ]);

    for i = 1 : strlength(digits)
        switch digits(i)
            case '0'
                nextPos = [ nextPos(1) + 3, nextPos(2) + CHAR_WIDTH / 2, nextPos(3)] * rot;
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE) * rot;
                poses = moveC(ur5, poses, arc, nextPos);
                currPos = nextPos;
                nextPos(1) = nextPos(1) - CHAR_HEIGHT;
                arc = getYArcPoint(currPos, nextPos, 7) * rot;
                poses = moveC(ur5, poses, arc, nextPos);
                currPos = nextPos;
                nextPos(1) = nextPos(1) + CHAR_HEIGHT;
                arc = getYArcPoint(currPos, nextPos, -7) * rot;
                poses = moveC(ur5, poses, arc, nextPos);
                currPos = nextPos;
                nextPos(2) = nextPos(2) + CHAR_WIDTH / 2;
            case '1'
                
            case '2'
                
            case '3'
                
            case '4'
                
            case '5'
                
            case '6'
                
            case '7'
                
            case '8'
                
            case '9'
            otherwise
                
        end
    end

    ur5.drawPath(poses);

    ur5.close();
end

function newPoses = moveL(ur5, poses, p)
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    newPoses = cat(1, poses, ur5.movel([ p, TOOL_DOWN_POSE ]));
end

function newPoses = moveJ(ur5, poses, p)
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    newPoses = cat(1, poses, ur5.movej([ p, TOOL_DOWN_POSE ]));
end

function newPoses = moveC(ur5, poses, p2, p3)
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    TOOL_ACC = 0.05;    % Tool Acceleration
    TOOL_VEL = 0.01;   % Tool Velocity
    BLEND_R = 0;      % Blend radius

    newPoses = cat(1, poses, ur5.movec([ p2, TOOL_DOWN_POSE ], [ p3, TOOL_DOWN_POSE ], 'pose', TOOL_ACC, TOOL_VEL, BLEND_R));
end

function p2 = getXArcPoint(p1, p3, width)
    p2 = [(p3(1) + p1(1)) / 2 + width, (p3(2) + p1(2)) / 2, p1(3)];
end

function p2 = getYArcPoint(p1, p3, height)
    p2 = [(p3(1) + p1(1)) / 2, (p3(2) + p1(2)) / 2 + height, p1(3)];
end

function p2 = getZArcPoint(p1, p3, depth)
    p2 = [(p3(1) + p1(1)) / 2, (p3(2) + p1(2)) / 2, p1(3) + depth];
end
