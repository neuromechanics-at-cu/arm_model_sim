# Arm Model Simulation using 8 Muscle Actuators

This  code will allow users to quickly and easily run a simulation of a two link arm with 8 muscle actuators to estimate energetic costs or inverse dynamics. A diagram of the biomechanical model is shown below.
<p align="center">
  <img width="40%" src="Images/Muscle_diagram.png">
</p>

# Main files
## Example.m
A short file that shows what inputs to specify with the model and how to call the model using the funciton single_sim.m. The inputs for the function are shown below.


## single_sim.m
The main function is single_sim.m. Call this function with the inputs specified and it will run the single arm reaching simulation.

### Inputs
1. Mass added at the hand in kg. (input.added_mass)
2. Subject mass in kg. (input.subj_mass)
3. Subject height in m. (input.subj_height)
4. Movment duration of the sim. (input.movedur)
5. Normalized force parameter in Pa. (input.normforce)
6. Starting position from shoulder in m. (start_pos)
7. Relative target position in m. (tar_rel_pos)

### Outputs
This function returns all the computed variable in one data structure.
1. shoulder - Shoulder torques
2. elbow - Elbow torques
3. theta - Shoulder and elbow angles
4. muscles - Muscle forces/stress
5. act - Muscle Activations
6. u - Neural Drive to those muscles
7. est - Estimated active state from u, used for checking.
8. tnew - New time array that goes with est.
9. energy - Energetics estimates
10. eff_mass - Effective mass array.
