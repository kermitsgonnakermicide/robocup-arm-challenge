%%Bottle drop
%Bottles are dropped in the blue box
gripperTranslation = [0.46 -0.35 0.5]; 
gripperRotation = [pi/2 -pi 0]; 
tform = eul2tform(gripperRotation); 
tform(1:3,4) = gripperTranslation'; 
[configSoln, solnInfo] =ik('tool0',tform,ikWeights,initialIKGuess);
trajGoal = packTrajGoal(configSoln,trajGoal); 
sendGoal(trajAct,trajGoal); 

pause(5);

gripGoal=packGripGoal(open_grip_pos,gripGoal);
sendGoal(gripAct,gripGoal);