module TemperatureAnomaly(
    /*[Clock 100 MHz]*/
    input clk,

    /*[Reset]*/
    input reset,

    input sda, //Incoming serial data line
    input scl, //Incoming serial clock

    output reg temperatureReady,  //Signal indicating the temperature value is valid
    output reg [/*[$TemperatureWidth]*/ - 1:0] temperature //Output temperature once its been accepted
);


//First, let's set a Value for the bit width of the temperature signal
/*[$TemperatureWidth 16]*/

//****************************************************
//***************  Receive Temperature  **************
//****************************************************
//First, we need to translate the incoming serial data into a parallel number
//We've already setup the automations for the section

//We will sample data on the rising edge of the serial clock,
//So let's get the rising edge of scl
//Here, we don't specify the source, but we instead rely on the
//notation of the rising prefix in the wire name
/*[RisingEdge]*/
wire risingScl;

//Now, let's shift the serial data into a parallel reg, the
//SerialShifter automation will store --width bits from the
//--data source everytime the --risingAccept signal rises
/*[SerialShifter --width $TemperatureWidth --risingAccept scl --data sda]*/
reg [/*[$TemperatureWidth]*/ - 1:0] receivedTemperature;

//We need to know when a full value has been received. Let's
//count the number of scl rises to know when we have received a
//total of $TemperatureWidth scl rises
/*[Counter --count $TemperatureWidth --event $scl.rising]*/
reg [15:0] sclCounter;

//Finally, $sclCounter.done does not descire what we are trying
//to discern, we are trying to discern when we've received a full
//temperature reading. Let's make a Value that copies $sclCounter.done
//and gives it a better name
/*[$temperatureReceived $sclCounter.done]*/



//****************************************************
//******************  Track Last n  ******************
//****************************************************
//1) Now, we need to keep the previous n accepted temperature values so we can
//   calculate the average. Lets create a Value for the number of temperatures to track.
//   Let's start by using 16 for the Value
/*[$TemperaturesToTrack 16]*/

//2) Next, lets create the registers to hold the last n temperatures
//   Let's use the following reg, temperatureHistory, except we need $TemperaturesToTrack
//   of them. We recommend using the Expand automation
/*[Expand --count $TemperaturesToTrack]*/ reg [15:0] temperatureHistory;

//3) Then, similar to the SerialShifter, we need to shift new temperatures values through
//   the regs we made. We recommend using the VariableShifter automation
/*[VariableShifter --dataBase temperatureHistory --incoming receivedTemperature --count $TemperaturesToTrack --risingAccept acceptTemperature]*/



//****************************************************
//**********  Calculate Average Temperature  *********
//****************************************************
//Now we need to calculate the average of the saved temperature readings.
//If n is a power of 2, we can easily do it by summing the temperatureHistory regs,
//and right shifting the sum

//4) Lets sum up all of the temperatureHistory regs. We recommend using the Sum
//   automation. Please note, the Sum automation is a non optimal way to add these
//   regs, due to the amount, but it's easy to use for this tutorial
/*[Sum --base temperatureHistory --count $TemperaturesToTrack]*/
wire [31:0] temperatureSum;

//Now, let's right shift the sum to divide it and get the average
parameter rightShiftsForAverageDividend = $clog2(/*[$TemperaturesToTrack]*/);
reg [15:0] averageTemperature;
/*[always averageTemperature]*/ begin
    /*[Reset]*/
        /*[<= 0]*/
    else
        /*[<= temperatureSum >> rightShiftsForAverageDividend]*/
end



//****************************************************
//************  Calculate Average Bounds  ************
//****************************************************
//Next, we need to determine the upper and lower bound of temperatures that the
//current average will accept. To do this, we will make the upper bound
//the average + 1/8th, and the lower bound the average - 1/8th

//To get 1/8 of the average, just right shift by 3
wire [15:0] eigthOfAverageTemperature;
assign eigthOfAverageTemperature = averageTemperature >> 3;

//5) Now, let's calcuate the upper bound in an always block to give a little
//   pipelining. Follow the example of the always block above, the block for
//   average temperature, to create an automation-ized always block for
//   the upperTemperatureBound reg.
reg [15:0] upperTemperatureBound;
//5a) Use an always automation
/*[always upperTemperatureBound]*/ begin
    //5b) A Reset automation
    /*[Reset]*/
        //5c) Non blocking automation to set upperTemperatureBound to 0
        /*[<= 0]*/
    else
        //5d) Another non blocking automation to set
        //    upperTemperatureBound to averageTemperature + eigthOfAverageTemperature
        /*[<= averageTemperature + eigthOfAverageTemperature]*/
end

//6) Now, do the same for the lowerTemperatureBounce. It should be the same
//   as the upperTemperatureBound, but you want to subtract eigthOfAverageTemperature.
//   Also, you will need to create the always automation/block without guidance here.
reg [15:0] lowerTemperatureBound;
/*[always lowerTemperatureBound]*/ begin
    /*[Reset]*/
        /*[<= 0]*/
    else
        /*[<= averageTemperature - eigthOfAverageTemperature]*/
end



//****************************************************
//*************  Determine When to Accept  ***********
//****************************************************
//7) Here, use a Counter automation to make temperatureReceived a counter.
//   You will want it to have no maximum, and the --event should be that
//   of when a new temperature reading is received. We will use the
//   counter to accept any temperature until the temperatureHistory is full.
/*[Counter --event $temperatureReceived --noMax]*/
reg[7:0] temperaturesReceived;

//Here is the logic that determine whether or not to accept a temperature value.
//When we get a new temperature reading, the signal pointed to by $temperatureReceived,
//we will accept the reading if the number of temperatures received is less than
//the number of temperatures we are tracking, or the temperature is within the
// lower and upper temperature bounds.
wire acceptTemperature;
assign acceptTemperature =
        /*[$temperatureReceived]*/
        &&
        (
            (temperaturesReceived < /*[$TemperaturesToTrack]*/ )
            ||
            (
                receivedTemperature > lowerTemperatureBound
                && receivedTemperature < upperTemperatureBound
            )
        )
        ;



//****************************************************
//*******************  Set Outputs  ******************
//****************************************************
//8) Finally, we want to set the outputs. Use non blocking automations to set the
//   outputs as stated in the next two always automations/blocks.
/*[always temperatureReady]*/ begin
    /*[Reset]*/
        //Set to 0
        /*[<= 0]*/
    else if(acceptTemperature)
        //Set to 1
        /*[<= 1]*/
    else
        //Set to 0
        /*[<= 0]*/
end

/*[always temperature]*/ begin
    /*[Reset]*/
        //Set to 0
        /*[<= 0]*/
    else if(acceptTemperature)
        //Set to receivedTemperature
        /*[<= receivedTemperature]*/
    else
        //Hold value
        /*[<=]*/
end
endmodule