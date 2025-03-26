% Initialize ROS and robot
rosIP = "192.168.1.12"; % Replace with your ROS IP address
rosshutdown;
rosinit(rosIP, 11311);

% Load robot configurations
run ros_connections.m;
run load_robot.m;

% Camera setup
colorImageSub = rossubscriber('/camera/color/image_raw'); % Replace with your camera topic
photoDir = 'robot_camera_photos'; % Directory to save photos
if ~exist(photoDir, 'dir')
    mkdir(photoDir);
end

% Define ranges for x, y, z coordinates and angles
xRange = linspace(-1, 1, 10);
yRange = linspace(-1, 1, 10);
zRange = linspace(0, 1, 5);
armAngles = linspace(-pi, pi, 8); % Roll, pitch, yaw for arm
cameraAngles = linspace(-pi/4, pi/4, 8); % Roll, pitch for camera

% Generate combinations of positions and orientations for arm and camera
[xGrid, yGrid, zGrid] = ndgrid(xRange, yRange, zRange);
positions = [xGrid(:), yGrid(:), zGrid(:)];
numPositions = size(positions, 1);

% Ensure at least 200 unique configurations for camera angles
numPhotosCamera = min(200, numPositions * length(cameraAngles)^2);

fprintf('Starting photo capture with camera angle changes for %d configurations...\n', numPhotosCamera);
photoCountCamera = 0;

for i = 1:numPositions
    for rollArm = armAngles
        for pitchArm = armAngles
            for yawArm = armAngles
                % Set gripper position and orientation (robot arm)
                gripperTranslation = positions(i, :);
                gripperRotationArm = [rollArm pitchArm yawArm];
                tformArm = eul2tform(gripperRotationArm); % Convert Euler angles to transformation matrix
                tformArm(1:3, 4) = gripperTranslation'; % Set translation

                % Solve inverse kinematics for the target position (robot arm)
                [configSolnArm, solnInfoArm] = ik('tool0', tformArm, ikWeights, initialIKGuess);

                if solnInfoArm.ExitFlag > 0 % Check if a valid solution is found
                    trajGoalArm = packTrajGoal(configSolnArm, trajGoal);
                    sendGoal(trajAct, trajGoalArm);
                    run robot_delay.m; % Allow time for the robot to move

                    % Iterate through camera angles independently
                    for rollCam = cameraAngles
                        for pitchCam = cameraAngles
                            % Adjust camera orientation relative to current arm position
                            gripperRotationCamera = [rollCam pitchCam yawArm]; % Camera angles (roll & pitch independent)
                            tformCamera = eul2tform(gripperRotationCamera); % Convert Euler angles to transformation matrix

                            try
                                % Capture photo from the camera
                                colorMsg = receive(colorImageSub, 10); % Timeout after 10 seconds
                                colorImageCamera = readImage(colorMsg);

                                % Save the photo with a unique name
                                photoNameCamera = sprintf('%s/photo_camera_%03d.png', photoDir, photoCountCamera + 1);
                                imwrite(colorImageCamera, photoNameCamera);

                                fprintf('Photo (camera) %d saved at position (%.2f, %.2f, %.2f) with arm orientation (%.2f, %.2f, %.2f) and camera orientation (%.2f, %.2f)\n', ...
                                        photoCountCamera + 1, gripperTranslation(1), gripperTranslation(2), gripperTranslation(3), ...
                                        rollArm, pitchArm, yawArm, rollCam, pitchCam);

                                photoCountCamera = photoCountCamera + 1;
                                if photoCountCamera >= numPhotosCamera
                                    break; % Stop if required number of photos is reached
                                end

                            catch ME
                                warning('Failed to capture or save photo: %s', ME.message);
                            end

                            if photoCountCamera >= numPhotosCamera
                                break; % Exit nested loops if enough photos are taken
                            end
                        end
                        if photoCountCamera >= numPhotosCamera
                            break;
                        end
                    end

                else
                    warning('No valid IK solution found for position (%.2f, %.2f, %.2f) and orientation (%.2f, %.2f, %.2f)', ...
                            gripperTranslation(1), gripperTranslation(2), gripperTranslation(3), rollArm, pitchArm, yawArm);
                end

                if photoCountCamera >= numPhotosCamera
                    break; % Exit nested loops if enough photos are taken
                end
            end
            if photoCountCamera >= numPhotosCamera
                break;
            end
        end
        if photoCountCamera >= numPhotosCamera
            break;
        end
    end

    if photoCountCamera >= numPhotosCamera
        break;
    end
end

fprintf('Photo capture with camera angle changes complete. Total photos taken: %d\n', photoCountCamera);

% Shutdown ROS connection after completion
rosshutdown;
