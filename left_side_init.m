%% Setting Init Config
% maintain the elbow away from the table for right side objects
initialIKGuess(3).JointPosition = 0.3; 
initialIKGuess(1).JointPosition = 1.5;
initialIKGuess(4).JointPosition = -0.5;
trajGoal = packTrajGoal(initialIKGuess,trajGoal);
sendGoal(trajAct,trajGoal); 

run robot_delay.m
