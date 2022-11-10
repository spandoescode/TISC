module progmem (
    input reg [7:0] PC, output wire [7:0] instruction
);
    //Initialise the program memory
    reg [255:0] MEM [15:0];

<<<<<<< HEAD
initial
begin
    $readmemb("prog.txt", MEM);
end
=======
    initial
    begin
        $readmemh("prog.txt", MEM);
    end
>>>>>>> 1cfbf16f9f6e7682a786044394d870f55bb9c08c

    assign instruction = MEM[PC];
endmodule
