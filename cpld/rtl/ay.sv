import common::*;
module ay(
    input rst_n,
    input clk28,
    input en,

    cpu_bus bus,
    input ck35,

    output reg ay_clk,
    output reg ay_bc1,
    output reg ay_bdir,
    output d_out_active
);

//              bdir bc1 description
// bffd read  |   0   0  inactive
// bffd write |   1   0  write to psg
// fffd read  |   0   1  read from psg
// fffd write |   1   1  latch address

always @(posedge clk28 or negedge rst_n) begin
    if (!rst_n) begin
        ay_clk <= 0;
        ay_bc1 <= 0;
        ay_bdir <= 0;
    end
    else begin
        if (ck35)
            ay_clk <= ~ay_clk;
        ay_bc1  <= en && bus.a[15] == 1'b1 && bus.a[14] == 1'b1 && bus.a[1] == 0 && bus.ioreq;
        ay_bdir <= en && bus.a[15] == 1'b1 && bus.a[1] == 0 && bus.ioreq && bus.wr;
    end
end

assign d_out_active = !ay_bdir && ay_bc1;


endmodule
