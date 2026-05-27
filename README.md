# fpga-danger-detection-robot
This project was worked on an FPGA board (Cyclone IV EP4CE6E22C8L).
The project's main idea is based on a robot that detects and checks any spot where a bomb could have been planted. I used a finite state machine (FSM) in which I configured 7 states for the movement of my robot (up, down, left, right) and the checking process (which consists of a simple check, clear for no bomb, and danger for one). I successfully made this using an 8x8 LED matrix which holds the robot's position and the spot that needs to be examined for a bomb, 3 buttons as combinations for all 7 types of states, and a 7-segment display for showing on the left what state the robot is in and a bomb counter on the right which counts how many bombs have been found.
The project was done in Quartus Prime Version 20.1.0 using Verilog.

States where 1 represents a button press:
010 (1) - move up
101 (2) - move down
100 (3) - move left
001 (4) - move right
011 (r) - reset
111 (F) - field check
110 (d or c) - get information about the field

Pictures from the project:

[Picture of the board]

<img width="3024" height="4032" alt="fpga" src="https://github.com/user-attachments/assets/190c026d-7871-44fe-8502-9e76266e793f" />

[Starting position]

<img width="3024" height="4032" alt="s1" src="https://github.com/user-attachments/assets/9c25c746-e56d-41ec-a3d3-980c29aeff0d" />

[Move up]

<img width="3024" height="4032" alt="s2" src="https://github.com/user-attachments/assets/68f8b826-1a5a-4595-958c-c62903060987" />

[After pressing it always goes back to the initial state]

<img width="3024" height="4032" alt="s3" src="https://github.com/user-attachments/assets/62a703ce-516c-454d-9ae1-76a694e2db72" />

[Move right]

<img width="3024" height="4032" alt="s4" src="https://github.com/user-attachments/assets/654c7d22-cd87-4d9b-a870-3743ca59cba1" />

[After many presses, get to the spesific field to check]

<img width="3024" height="4032" alt="s6" src="https://github.com/user-attachments/assets/e8618f06-0268-441e-97b3-a1f3a6960c1b" />

[Check the field]

<img width="3024" height="4032" alt="s7" src="https://github.com/user-attachments/assets/c2e2d172-e65c-4a43-9371-e15a90e94f36" />

[Bomb found, another random spot has been selected]

<img width="3024" height="4032" alt="s8" src="https://github.com/user-attachments/assets/60b9bf74-73f9-4519-9086-14e108dad42d" />

[Move right and down]

<img width="3024" height="4032" alt="s9" src="https://github.com/user-attachments/assets/9f2520b6-d474-4dec-8ebb-5613df9b4906" />

[Check next field]

<img width="3024" height="4032" alt="F1" src="https://github.com/user-attachments/assets/b39fc065-cd19-46f5-b27f-232661d56a4b" />

[Another bomb found]

<img width="3024" height="4032" alt="d2" src="https://github.com/user-attachments/assets/fd14b5b7-5b1b-48c7-b20c-2e8e52d5048a" />

[After checking the next field, we can try to check it again]

<img width="3024" height="4032" alt="F3checkEmtpyField" src="https://github.com/user-attachments/assets/fee1d91b-60ca-4b28-ad31-f2453f10a3e6" />

[And get that the field is clear]

<img width="3024" height="4032" alt="c3gotclearfield" src="https://github.com/user-attachments/assets/7dbd4bfa-1bdc-4d49-b43d-feb159da16f1" />

[At any time we can reset the whole setup]

<img width="3024" height="4032" alt="r0resetpresedafter2bombs" src="https://github.com/user-attachments/assets/0a348d11-1315-4a08-97d5-496b41f6c753" />

[And start from a new position]

<img width="3024" height="4032" alt="00afterresetpresessed" src="https://github.com/user-attachments/assets/fc33f374-fbb0-4915-9bcd-73eec4cf34ca" />
