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

%Variables
open_grip_pos = 0.01;
bottle_grip = 0.517;
can_grip = 0.25;
pouch_grip = 0.61;
green_bin_location = [-0.46 -0.3 0.5];
blue_bin_location = [0.46 -0.35 0.5];
drop_gripper_orient = [pi/2 -pi 0];