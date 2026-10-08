`timescale 1ns / 1ps

module ALU #(
    parameter WIDTH = 32
)(
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,

    input              A_invert,
    input              B_invert,
    input              CarryIn,

    input  [2:0]        Operation,

    output reg [WIDTH-1:0] Result,
    output reg             set,
    output reg             overflow,
    output                  Zero
);

    wire [WIDTH-1:0] A_in;
    wire [WIDTH-1:0] B_in;

    wire [WIDTH-1:0] add_out;

    assign A_in = A_invert ? ~A : A;
    assign B_in = B_invert ? ~B : B;

    assign add_out = A_in + B_in + CarryIn;

    always @(*) begin

        set = 1'b0;
        overflow = 1'b0;

        case (Operation)

            // AND
            3'b000: begin
                Result = A_in & B_in;
            end

            // OR
            3'b001: begin
                Result = A_in | B_in;
            end

            // XOR
            3'b010: begin
                Result = A_in ^ B_in;
            end

            // ADD / SUB
            3'b011: begin
                Result = add_out;

                overflow =
                    (~(A[WIDTH-1] ^ B[WIDTH-1])) &
                    (A[WIDTH-1] ^ Result[WIDTH-1]);
            end

            // Shift left logical
            3'b100: begin
                Result = A << B[4:0];
            end

            // Shift right logical
            3'b101: begin
                Result = A >> B[4:0];
            end

            // Set less than
            3'b110: begin
                overflow =
                    (~(A[WIDTH-1] ^ B[WIDTH-1])) &
                    (A[WIDTH-1] ^ Result[WIDTH-1]);

                set = add_out[WIDTH-1] ^ overflow;

                Result = {31'd0, set};
            end

            default: begin
                Result = 32'd0;
            end

        endcase
    end

    assign Zero = (Result == 32'd0);

endmodule