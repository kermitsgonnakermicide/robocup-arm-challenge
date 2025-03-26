%%Postioning for yellow region
gripperTranslation = [0 0.2 0.6];
gripperRotation = [(3*pi/4) -pi 0]; 

tform = eul2tform(gripperRotation); tform(1:3,4) = gripperTranslation';
[configSoln, solnInfo] =ik('tool0',tform,ikWeights,initialIKGuess);
trajGoal = packTrajGoal(configSoln,trajGoal); sendGoal(trajAct,trajGoal); 

%run robot_delay.m