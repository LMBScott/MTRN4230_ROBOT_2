function z5207471_ROBOT_2(paperPos, digits)
    clear all;

    DEFAULT_PAPER_POS = [-588.53, -133.30, 0];
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    CHAR_WIDTH = 19.5;    % Character width in millimeters
    CHAR_HEIGHT = 22;     % Character height in millimeters
    CHAR_TOP_PADDING = 3;
    CHAR_SIDE_PADDING = 5;
    PLANE_Z_OFFSET = 60;  % Z-offset of flange from work plane in millimeters
    PAPER_MARGIN = 30;
    Z_CLEARANCE = 10;     % Safe z-offset of TCP from work plane in millimeters

    if (~exist('paperPos', 'var'))
        paperPos = DEFAULT_PAPER_POS;
    end

    if (~exist('digits', 'var'))
        digits = '0123456789';
    end

    disp('Printing these digits: ' + digits);

    host = '127.0.0.1';
    port = 30003;
    ur5 = rtde(host, port);
    
    CHAR_WIDTH = 0.0195; % Character width in meters
    CHAR_HEIGHT = 0.032; % Character height in meters
    PLANE_Z_OFFSET = 60; % Z-offset of TCP from work plane in millimeters 

    rot = rotz(paperPos(3), 'deg');
    
    home = [ paperPos(1), paperPos(2), PLANE_Z_OFFSET + Z_CLEARANCE ];

    currPos = home;
    nextPos = [ currPos(1), currPos(2) + PAPER_MARGIN, PLANE_Z_OFFSET];
    charEdgePos = nextPos;

    poses = ur5.movel([ currPos, TOOL_DOWN_POSE ]);

    for i = 1 : strlength(digits)
        switch digits(i)
            case '0'
                % Move to top of zero
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_WIDTH / 2, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw RHS of zero
                currPos = nextPos;
                nextPos(1) = nextPos(1) - CHAR_HEIGHT;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH / 2 - CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw LHS of zero
                currPos = nextPos;
                nextPos(1) = nextPos(1) + CHAR_HEIGHT;
                arc = getYArcPoint(currPos, nextPos, CHAR_SIDE_PADDING - CHAR_WIDTH / 2);
                poses = moveC(ur5, poses, rot, arc, nextPos);
            case '1'
                % Move to bottom of angled line of one
                nextPos = [ charEdgePos(1) + CHAR_HEIGHT * 0.125 + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw angled line of one
                nextPos = [ nextPos(1) - CHAR_HEIGHT * 0.125, nextPos(2) + CHAR_WIDTH / 2 - CHAR_SIDE_PADDING, nextPos(3) ];
                poses = moveL(ur5, poses, rot, nextPos);
                % Draw vertical line of one
                nextPos(1) = nextPos(1) + CHAR_HEIGHT;
                poses = moveL(ur5, poses, rot, nextPos);
                % Move to left of horizontal line of one
                currPos = nextPos;
                nextPos(2) = nextPos(2) - CHAR_WIDTH / 2 + CHAR_SIDE_PADDING;
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw horizontal line of one
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
            case '2'
                % Move to edge of upper curve of two
                nextPos = [ charEdgePos(1) + CHAR_HEIGHT * 0.125 + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw upper curve of two
                arc = [ nextPos(1) - CHAR_HEIGHT * 0.125, nextPos(2) + CHAR_WIDTH * 0.75, nextPos(3) ];
                nextPos = [ nextPos(1) - CHAR_HEIGHT * 0.125, nextPos(2) + CHAR_WIDTH * 0.6, nextPos(3) ];
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw angled line of two
                nextPos(1) = charEdgePos + CHAR_HEIGHT + CHAR_TOP_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
                % Draw horizontal line of two
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
            case '3'
                % Move to edge of upper curve of three
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING + 3, charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw upper curve of three
                currPos = nextPos;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH - 2 * CHAR_SIDE_PADDING);
                nextPos(1) = nextPos(1) + CHAR_HEIGHT / 2;
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw lower curve of three
                currPos = nextPos;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH - 2 * CHAR_SIDE_PADDING);
                nextPos(1) = nextPos(1) + CHAR_HEIGHT / 2;
                poses = moveC(ur5, poses, rot, arc, nextPos);
            case '4'
                % Move to top of four
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_WIDTH * 0.75, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw angled line of four
                nextPos = [ charEdgePos(1) + CHAR_HEIGHT * 0.6, charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3) ];
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw horizontal line of four
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
                % Move to top of four
                currPos = nextPos;
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_WIDTH * 0.75, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw vertical line of four
                nextPos(1) = nextPos(1) + CHAR_HEIGHT;
                poses = moveL(ur5, poses, rot, nextPos);
            case '5'
                % Move to top of vertical line of five
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw vertical line of five
                nextPos = [ nextPos(1) + CHAR_HEIGHT / 2, nextPos(2), nextPos(3) ];
                poses = moveL(ur5, poses, rot, nextPos);
                % Draw curve of five
                currPos = nextPos;
                nextPos = [ nextPos(1) + CHAR_HEIGHT / 2, nextPos(2), nextPos(3) ];
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH - 2 * CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Move to top of vertical line of five
                currPos = nextPos;
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw horizontal line of five
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
            case '6'
                % Move to middle left of six
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING + CHAR_HEIGHT / 2, charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw inner curve of six
                currPos = nextPos;
                nextPos = [ nextPos(1) + CHAR_HEIGHT / 2, nextPos(2) + CHAR_WIDTH / 2, nextPos(3) ];
                arc = [ currPos(1) + 0.2 * CHAR_HEIGHT, currPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING, currPos(3) ];
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw outer curve of six
                currPos = nextPos;
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING + CHAR_WIDTH / 2, charEdgePos(3) ];
                arc = getYArcPoint(currPos, nextPos, CHAR_SIDE_PADDING - CHAR_WIDTH / 2);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw top trailing edge of six
                nextPos = [ nextPos(1), charEdgePos(2) + CHAR_WIDTH / 2 - CHAR_SIDE_PADDING, charEdgePos(3)];
                poses = moveL(ur5, poses, rot, nextPos);
            case '7'
                % Move to edge of horizontal line of seven
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw horizontal line of seven
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
                % Draw angled line of seven
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING + CHAR_HEIGHT, charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3)];
                poses = moveL(ur5, poses, rot, nextPos);
            case '8'
                % Move to top of eight
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_WIDTH / 2, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw upper right curve of eight
                currPos = nextPos;
                nextPos(1) = nextPos(1) - CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH / 2 - CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw lower right curve of eight
                currPos = nextPos;
                nextPos(1) = nextPos(1) - CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH / 2 - CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw lower left curve of eight
                currPos = nextPos;
                nextPos(1) = nextPos(1) + CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_SIDE_PADDING - CHAR_WIDTH / 2);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw upper left curve of eight
                currPos = nextPos;
                nextPos(1) = nextPos(1) + CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_SIDE_PADDING - CHAR_WIDTH / 2);
                poses = moveC(ur5, poses, rot, arc, nextPos);
            case '9'
            otherwise
                % Move to middle right of nine
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING + CHAR_HEIGHT / 2, charEdgePos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING, charEdgePos(3)];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw inner curve of nine
                currPos = nextPos;
                nextPos = [ nextPos(1) - CHAR_HEIGHT / 2, nextPos(2) - CHAR_WIDTH / 2, nextPos(3) ];
                arc = [ currPos(1) - 0.2 * CHAR_HEIGHT, currPos(2) - CHAR_WIDTH - 2 * CHAR_SIDE_PADDING, currPos(3) ];
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw outer curve of nine
                currPos = nextPos;
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING + CHAR_HEIGHT, charEdgePos(2) + CHAR_SIDE_PADDING + CHAR_WIDTH / 2, charEdgePos(3) ];
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH / 2 - CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw bottom trailing edge of nine
                nextPos = [ nextPos(1), charEdgePos(2) + CHAR_SIDE_PADDING, charEdgePos(3)];
                poses = moveL(ur5, poses, rot, nextPos);
        end

        currPos = nextPos;

        % Shift character edge position to edge of next character
        charEdgePos = charEdgePos + CHAR_WIDTH;
    end

    ur5.drawPath(poses);

    ur5.close();
end

function newPoses = moveL(ur5, poses, rotation, p)
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    newPoses = cat(1, poses, ur5.movel([ p * rotation, TOOL_DOWN_POSE ]));
end

function newPoses = moveJ(ur5, poses, rotation, p)
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    newPoses = cat(1, poses, ur5.movej([ p * rotation, TOOL_DOWN_POSE ]));
end

function newPoses = moveC(ur5, poses, rotation, p2, p3)
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    TOOL_ACC = 0.05; % Tool Acceleration
    TOOL_VEL = 0.01; % Tool Velocity
    BLEND_R = 0.01;     % Blend radius

    newPoses = cat(1, poses, ur5.movec([ p2 * rotation, TOOL_DOWN_POSE ], [ p3 * rotation, TOOL_DOWN_POSE ], 'pose', TOOL_ACC, TOOL_VEL, BLEND_R));
end

function p2 = getXArcPoint(p1, p3, offset)
    p2 = [(p3(1) + p1(1)) / 2 + offset, (p3(2) + p1(2)) / 2, p1(3)];
end

function p2 = getYArcPoint(p1, p3, offset)
    p2 = [(p3(1) + p1(1)) / 2, (p3(2) + p1(2)) / 2 + offset, p1(3)];
end

function p2 = getZArcPoint(p1, p3, offset)
    p2 = [(p3(1) + p1(1)) / 2, (p3(2) + p1(2)) / 2, p1(3) + offset];
end
