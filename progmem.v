module progmem (input reg [7:0] PC,
                output wire [7:0] instruction);
//Initialise the program memory
reg [255:0] MEM [15:0];

initial
begin
    $readmemb("prog.txt", MEM);
end

assign instruction = MEM[PC];
endmodule
