%%Postioning the camera 
gripperTranslation = [0 0.3 0.4];
gripperRotation = [pi -pi 0]; 

tform = eul2tform(gripperRotation); tform(1:3,4) = gripperTranslation';
[configSoln, solnInfo] =ik('tool0',tform,ikWeights,initialIKGuess);
trajGoal = packTrajGoal(configSoln,trajGoal); sendGoal(trajAct,trajGoal); 

run robot_delay.m