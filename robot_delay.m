% Create subscribers for the trajectory and gripper status topics
traj_sub = rossubscriber('/pos_joint_traj_controller/follow_joint_trajectory/status', 'actionlib_msgs/GoalStatusArray');
grip_sub = rossubscriber('/gripper_controller/follow_joint_trajectory/status', 'actionlib_msgs/GoalStatusArray');

% Function to wait for "SUCCEEDED" status
function waitForSucceeded(sub, controller_name)
    disp(['Waiting for ', controller_name, ' execution to complete...']);
    while true
        % Receive a message
        msg = receive(sub);
        
        % Debug: Display received message
        % disp(['Received message from ', controller_name, ' status topic:']);
        %disp(msg);
        
        % Check if StatusList is not empty
        if ~isempty(msg.StatusList)
            % Check the status of each goal in the received message
            for i = 1:length(msg.StatusList)
                status = msg.StatusList(i).Status;
                % Debug: Display each status
                % disp(['Goal status: ', num2str(status)]);
                
                % 3 corresponds to SUCCEEDED
                if status == 3
                    disp([controller_name, ' execution succeeded.']);
                    return; % Exit the loop and stop waiting
                end
            end
        end
    end
end

% Wait for the status to become "SUCCEEDED" for the trajectory controller
waitForSucceeded(traj_sub, 'Trajectory');

% Wait for the status to become "SUCCEEDED" for the gripper controller
%waitForSucceeded(grip_sub, 'Gripper');

% Adding a delay for the arm to stabilize before moving on
pause(15);

disp('Completed');
