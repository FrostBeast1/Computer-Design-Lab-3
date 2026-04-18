module control_state_machine(clk_i, reset_i, g_i, z_i, Q_o)
    input wire clk_i, reset_i, z_i;
    output [1:0] reg Q_o;

    reg [1:0] state;
    reg [1:0] next_state;

    Q_o = state;

    // Next-state combinational logic.
    always @(Qstate, z_i) begin
        case(state)
            2'b00: next_state = 2'b01;
            2'b01: next_state = 2'b10;
            2'b10: begin
                next_state = z_i ? 2'b00 : 2'b01;
            end
            default: next_state = 2'b00
        endcase
    end

    // State register block
    always @(posedge clk_i, reset_i) begin
        if (reset_i) begin
            state <= 2'b000
        end
        else begin
            state <= next_state
        end
    end
endmodule