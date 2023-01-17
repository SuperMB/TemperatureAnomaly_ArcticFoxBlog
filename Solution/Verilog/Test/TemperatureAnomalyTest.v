module TemperatureAnomalyTest;


//9) Instantiate the TemperatureAnomaly module to test using the
//   TestModule automation.
/*[TestModule --module TemperatureAnomaly]*/


task SendSerialTemperature;


input [15:0] temperature;
    integer i;

    begin
        sda = 0;
        scl = 0;
        #200;

        for(i = 0; i < 16; i = i + 1) begin
            sda = temperature[i];
            #20;
            scl = 1;
            #30;
            scl = 0;
            #10;
        end

    end

endtask


initial begin
    #500;
    reset = 1;
    #2000;
    reset = 0;
    #3000;

    /*[SendTemperatures --count 50]*/

    #2000;
    $finish;
end
endmodule