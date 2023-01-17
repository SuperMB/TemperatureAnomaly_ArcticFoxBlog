# Temperature Anomaly - Arctic Fox Blog Tutorial

<p align="center">
    <img src="https://icii.io/wp-content/uploads/2022/09/New-Arctic-Fox-Logo.Blue_.For-Animation.WithBehindForGaps-1.svg" alt="Arctic Fox Logo" style="width:300px;"/>
</p>
This repo provides the code that implements temperature anomaly detection. The code uses Arctic Fox to track previous temperture readings and reject temperature reading to far from the running average. This example provides a short introduction to Arctic Fox. 

<br>
<br>
<br>

## Tutorial Setup
This tutorial assumes you have installed Arctic Fox. Clone the git repo. Then, in a terminal, navigate to the Tutorial folder. Run the following command in the terminal: 

> arcticfox -import

This should import the Arctic Fox project, create the project structure, and open the imported Arctic Fox project. 

## Using the Tutorial
The tutorial contains a Verilog module, a Verilog test bench, and a few Arctic Fox automations. To go through the tutorial, follow the blog, and add automations where needed in the Verilog module and Verilog test bench. 

## Look at Solution
To look at the solution, follow the same process as importing the tutorial. In a terminal, navigate to the Solution folder. Again, run the following command: 

> arcticfox -import

The solution will open. Run Arctic Fox and see how we created the temperature anomaly circuit. 