[gripAct,gripGoal] = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory');
gripAct.FeedbackFcn = [];

[trajAct,trajGoal] = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory') ;
trajAct.FeedbackFcn = []; 
jointSub = rossubscriber("/joint_states");
jointStateMsg = jointSub.LatestMessage;

% Create a subscriber for the topic
traj_sub = rossubscriber('/pos_joint_traj_controller/follow_joint_trajectory/status', 'actionlib_msgs/GoalStatusArray');
grip_sub = rossubscriber('/gripper_controller/follow_joint_trajectory/status', 'actionlib_msgs/GoalStatusArray');

% For color and depth sensors
colorImageSub = rossubscriber('/camera/rgb/image_raw');
depthImageSub = rossubscriber('/camera/depth/image_raw');