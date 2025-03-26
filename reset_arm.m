%%Load robot info
UR5e = loadrobot('universalUR5e');
initialIKGuess = homeConfiguration(UR5e);
% Adjust body transformations from previous URDF version
tform=UR5e.Bodies{3}.Joint.JointToParentTransform;
UR5e.Bodies{3}.Joint.setFixedTransform(tform*eul2tform([pi/2,0,0]));
tform=UR5e.Bodies{4}.Joint.JointToParentTransform;
UR5e.Bodies{4}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));
tform=UR5e.Bodies{7}.Joint.JointToParentTransform;
UR5e.Bodies{7}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));

ik = inverseKinematics("RigidBodyTree",UR5e); % Create Inverse kinematics solver
ikWeights = [0.25 0.25 0.25 0.1 0.1 .1]; % configuration weights for IK solver [Translation Orientation] see documentation

initialIKGuess(3).JointPosition = 0; 
initialIKGuess(1).JointPosition = 0;
initialIKGuess(4).JointPosition = 0;
trajGoal = packTrajGoal(initialIKGuess,trajGoal);
sendGoal(trajAct,trajGoal); 

gripGoal=packGripGoal(open_grip_pos,gripGoal);
sendGoal(gripAct,gripGoal);