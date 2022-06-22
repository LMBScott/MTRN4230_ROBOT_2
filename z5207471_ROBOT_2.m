% MTRN4230 ROBOT-2 Assessment
% Author: Lachlan Scott, z5207471

function z5207471_ROBOT_2(paperPose, digits)
    arguments
        paperPose (1,3) double = [-588.53, -133.30, 0]
        digits (1,:) char = '0123456789'
    end

    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    CHAR_WIDTH = 19.5;    % Character width in millimeters
    CHAR_HEIGHT = 22;     % Character height in millimeters
    CHAR_TOP_PADDING = 3;
    CHAR_SIDE_PADDING = 5;
    PLANE_Z_OFFSET = 60;  % Z-offset of flange from work plane in millimeters
    PAPER_MARGIN = 30;
    Z_CLEARANCE = 10;     % Safe z-offset of TCP from work plane in millimeters

    disp("Paper position: " + paperPose(1) + ", " + paperPose(2) + ", Rotation: " + paperPose(3));

    disp("Writing these digits: " + digits);

    host = '127.0.0.1';
    port = 30003;
    ur5 = rtde(host, port);

    rot = rotz(paperPose(3), 'deg');
    invRot = rotz(-paperPose(3), 'deg');
    
    homePos = [ paperPose(1), paperPose(2), PLANE_Z_OFFSET + Z_CLEARANCE ];

    poses = moveL(ur5, [], rot, homePos);

    currPos = homePos;
    nextPos = [];
    charEdgePos = [ currPos(1), currPos(2) + PAPER_MARGIN, PLANE_Z_OFFSET];

    for i = 1 : strlength(digits)
        disp("Now writing: " + digits(i));
        disp("Character edge at: " + charEdgePos(1) + ", " + charEdgePos(2) + ", " + charEdgePos(3));
        switch digits(i)
            case '0'
                % Move to top of zero
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_WIDTH / 2, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw RHS of zero
                currPos = nextPos;
                nextPos(1) = nextPos(1) + CHAR_HEIGHT;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH / 2 - CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw LHS of zero
                currPos = nextPos;
                nextPos(1) = nextPos(1) - CHAR_HEIGHT;
                arc = getYArcPoint(currPos, nextPos, CHAR_SIDE_PADDING - CHAR_WIDTH / 2);
                poses = moveC(ur5, poses, rot, arc, nextPos);
            case '1'
                % Move to bottom of angled line of one
                nextPos = [ charEdgePos(1) + CHAR_HEIGHT * 0.125 + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET];
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
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw upper curve of two
                arc = [ charEdgePos(1) + CHAR_TOP_PADDING + 0.1 * CHAR_HEIGHT, charEdgePos(2) + 0.5 * CHAR_WIDTH, nextPos(3) ];
                nextPos = [ charEdgePos(1) + 0.45 * CHAR_HEIGHT, charEdgePos(2) + 0.75 * CHAR_WIDTH, nextPos(3) ];
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw angled line of two
                nextPos = [ charEdgePos(1) + CHAR_HEIGHT + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET ];
                poses = moveL(ur5, poses, rot, nextPos);
                % Draw horizontal line of two
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
            case '3'
                % Move to edge of upper curve of three
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw upper curve of three
                currPos = nextPos;
                nextPos(1) = nextPos(1) + CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH - 2 * CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw lower curve of three
                currPos = nextPos;
                nextPos(1) = nextPos(1) + CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH - 2 * CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
            case '4'
                % Move to top of four
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_WIDTH * 0.75, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw angled line of four
                nextPos = [ charEdgePos(1) + CHAR_HEIGHT * 0.6, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET ];
                poses = moveL(ur5, poses, rot, nextPos);
                % Draw horizontal line of four
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
                % Move to top of four
                currPos = nextPos;
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_WIDTH * 0.75, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw vertical line of four
                nextPos(1) = nextPos(1) + CHAR_HEIGHT;
                poses = moveL(ur5, poses, rot, nextPos);
            case '5'
                % Move to top of vertical line of five
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET];
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
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw horizontal line of five
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
            case '6'
                % Move to middle left of six
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING + 0.75 * CHAR_HEIGHT, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw inner curve of six
                currPos = nextPos;
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                arc = getXArcPoint(currPos, nextPos, -CHAR_HEIGHT / 4);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw bottom curve of six
                currPos = nextPos;
                nextPos(2) = nextPos(2) - CHAR_WIDTH + 2 * CHAR_SIDE_PADDING;
                arc = getXArcPoint(currPos, nextPos, CHAR_HEIGHT / 4);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw outer curve of six
                currPos = nextPos;
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_WIDTH - CHAR_SIDE_PADDING, PLANE_Z_OFFSET ];
                arc = [ nextPos(1) + CHAR_HEIGHT / 4, nextPos(2) - CHAR_WIDTH / 3, PLANE_Z_OFFSET ];
                poses = moveC(ur5, poses, rot, arc, nextPos);
            case '7'
                % Move to edge of horizontal line of seven
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw horizontal line of seven
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                poses = moveL(ur5, poses, rot, nextPos);
                % Draw angled line of seven
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING + CHAR_HEIGHT, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET];
                poses = moveL(ur5, poses, rot, nextPos);
            case '8'
                % Move to top of eight
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING, charEdgePos(2) + CHAR_WIDTH / 2, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw upper right curve of eight
                currPos = nextPos;
                nextPos(1) = nextPos(1) + CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH / 2 - CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw lower right curve of eight
                currPos = nextPos;
                nextPos(1) = nextPos(1) + CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_WIDTH / 2 - CHAR_SIDE_PADDING);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw lower left curve of eight
                currPos = nextPos;
                nextPos(1) = nextPos(1) - CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_SIDE_PADDING - CHAR_WIDTH / 2);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw upper left curve of eight
                currPos = nextPos;
                nextPos(1) = nextPos(1) - CHAR_HEIGHT / 2;
                arc = getYArcPoint(currPos, nextPos, CHAR_SIDE_PADDING - CHAR_WIDTH / 2);
                poses = moveC(ur5, poses, rot, arc, nextPos);
            case '9'
                % Move to middle right of nine
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING + 0.25 * CHAR_HEIGHT, charEdgePos(2) + CHAR_WIDTH - CHAR_SIDE_PADDING, PLANE_Z_OFFSET];
                arc = getZArcPoint(currPos, nextPos, Z_CLEARANCE);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw inner curve of nine
                currPos = nextPos;
                nextPos(2) = nextPos(2) - CHAR_WIDTH + 2 * CHAR_SIDE_PADDING;
                arc = getXArcPoint(currPos, nextPos, CHAR_HEIGHT / 4);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw top curve of nine
                currPos = nextPos;
                nextPos(2) = nextPos(2) + CHAR_WIDTH - 2 * CHAR_SIDE_PADDING;
                arc = getXArcPoint(currPos, nextPos, -CHAR_HEIGHT / 4);
                poses = moveC(ur5, poses, rot, arc, nextPos);
                % Draw outer curve of nine
                currPos = nextPos;
                nextPos = [ charEdgePos(1) + CHAR_TOP_PADDING + CHAR_HEIGHT, charEdgePos(2) + CHAR_SIDE_PADDING, PLANE_Z_OFFSET ];
                arc = [ nextPos(1) - CHAR_HEIGHT / 4, nextPos(2) + CHAR_WIDTH / 3, PLANE_Z_OFFSET ];
                poses = moveC(ur5, poses, rot, arc, nextPos);
        end

        currPos = nextPos;

        % Shift character edge position to edge of next character
        charEdgePos(2) = charEdgePos(2) + CHAR_WIDTH;
    end

    ur5.drawPath(poses);

    ur5.close();
end

function newPoses = moveL(ur5, poses, rotation, p)
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    disp("Linear move: " + p(1) + ", " + p(2) + ", " + p(3));
    newPoses = cat(1, poses, ur5.movel([ p * rotation, TOOL_DOWN_POSE ]));
end

function newPoses = moveJ(ur5, poses, rotation, p)
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    disp("Joint move: " + p(1) + ", " + p(2) + ", " + p(3));
    newPoses = cat(1, poses, ur5.movej([ p * rotation, TOOL_DOWN_POSE ]));
end

function newPoses = moveC(ur5, poses, rotation, p2, p3)
    TOOL_DOWN_POSE = [2.2214, -2.2214, 0.00];
    TOOL_ACC = 0.08; % Tool Acceleration
    TOOL_VEL = 0.08; % Tool Velocity
    BLEND_R = 0.001; % Blend radius
    disp("Circular move: point 2: " + p2(1) + ", " + p2(2) + ", " + p2(3) + " point 3: " + p3(1) + ", " + p3(2) + ", " + p3(3));

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
