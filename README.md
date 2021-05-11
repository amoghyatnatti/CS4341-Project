# CS4341 Verilog Project

## Overview
We are building an Arithmetic Logic Circuit (ALU) with 11 operations. The basic operations include RESET, PRESET, and NO-OP. The logical operations include 16-bit NOT, OR, AND, and XOR. The mathematical operations include 16-bit addition, subtraction, multiplication, and division. However, for the circuit diagram or the ALU, we are not taking overflow into consideration. We use a 16 by 32 multiplexor (MUX) to decide what operation we want to do. This means that our operations are working in parallel. Our input is 16 bits for all operations, but our output will always be 32 bits to account for the multiplication operation’s output. For each operation, we have a corresponding opcode that we can input into the MUX. For operations where we have two inputs, we have a 16-bit input, and we use the lower 16-bits of the accumulator for the other input. For operations where we only have one input (i.e. NOT operation), we only use the lower bits of the accumulator. We store our 32-bit output from the MUX into the accumulator register by sending it to 32 1-bit, positive-edge trigger D Flip-Flops working synchronously. The ALU outputs the contents of the accumulator. The unused multiplexor channels in the ALU will be set to ground (0). All of the modules are written in behavioral-style.

## Installation Guidelines
Step 1: Go to http://bleyer.org/icarus/ and download verilog.

Step 2: Type Path into your computer and click on "Edit the system environment variables"

Step 3: Click on Advanced tab

Step 4: Click on Environment Variables

Step 5: Under User Variables for $NAME click on Path and click edit

Step 6: Click new and add C:\iverilog\bin and hit enter

Step 7: Click new again and add C:\iverilog\gtkwave\bin and hit enter

Step 8: Go to VS Code and get this repository (click on the github symbol on the left tab and copy and paste the repository link into the search bar)

Step 9: On VS Code up at the top hit Terminal

Step 10: To compile type iverilog filename.vl (enter) vvp a.out (enter)

You should see the output
