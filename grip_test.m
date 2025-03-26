[gripAct,gripGoal] = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory');
gripAct.FeedbackFcn = [];
gripGoal=packGripGoal(pouch_grip ,gripGoal);
%gripGoal=packGripGoal(bottle_grip ,gripGoal);
gripGoal=packGripGoal(can_grip ,gripGoal);
gripGoal=packGripGoal(open_grip_pos,gripGoal);
sendGoal(gripAct,gripGoal);