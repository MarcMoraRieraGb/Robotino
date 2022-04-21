# Robotino

There are 2 programs, the main progrma "RobotinoControl" and a function "CalcVariable". The main objective of this project is make the robotino detect a red line that is on the floor and correct his trajectory to put himself above it. When he arrive in a intersection he sill always turn left or right, depens on which one you want. 

For acomplish that all is focused as if the robotino is a state machine with 4 states:

1- He sees the line and not an intersection and he corrects his trajectory and follows the line. \n
2- He sees a intersection, so we use odometry to put the robot above it.
3- With odometry we make a 90 degree turn to the right or to the left.
4- Whenever you detect and obstacle you stop.
