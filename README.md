# Arm Model Simulation using 8 Muscle Actuators

This  code will allow users to quickly and easily run a simulation of a two link arm with 8 muscle actuators to estimate energetic costs or inverse dynamics. A diagram of the biomechanical model is shown below.
<p align="center">
  <img width="40%" src="Images/Muscle_diagram.png">
</p>

# Main files

The main function is single_sim.m. Call this function with the inputs specified and it will run the single arm reaching simulation.

### Inputs
1. Mass added at the hand in kg. (input.added_mass)
2. Subject mass in kg. (input.subj_mass)
3. Subject height in m. (input.subj_height)
4. Movment duration of the sim. (input.movedur)
5. Normalized force parameter in Pa. (input.normforce)
6. NEED TO ADD START AND TARGET INPUT (future update).
