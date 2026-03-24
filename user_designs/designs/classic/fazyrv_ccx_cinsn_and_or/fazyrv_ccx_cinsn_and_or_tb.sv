// SPDX-FileCopyrightText: © 2026 Meinhard Kissich
// SPDX-License-Identifier: Apache-2.0

module fazyrv_ccx_cinsn_and_or_tb;

localparam CLK_PERIOD = 10;
localparam CHUNKSIZE  = 4;

logic                 clk;
logic [CHUNKSIZE-1:0] ccx_rs_a;
logic [CHUNKSIZE-1:0] ccx_rs_b;
logic [CHUNKSIZE-1:0] ccx_res;
logic                 ccx_req;
logic                 ccx_resp;
logic                 ccx_sel;

fazyrv_ccx_cinsn_and_or #(
  .CHUNKSIZE ( CHUNKSIZE )
) i_fazyrv_ccx_cinsn_and_or (
  .clk_i      ( clk       ),
  .ccx_rs_a_i ( ccx_rs_a  ),
  .ccx_rs_b_i ( ccx_rs_b  ),
  .ccx_res_o  ( ccx_res   ),
  .ccx_req_i  ( ccx_req   ),
  .ccx_resp_o ( ccx_resp  ),
  .ccx_sel_i  ( ccx_sel   )
);

initial clk = 0;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
  $dumpfile("fazyrv_ccx_cinsn_and_or_tb.vcd");
  $dumpvars(0, fazyrv_ccx_cinsn_and_or_tb);
end

initial begin
  @(posedge clk); #1
  ccx_sel   = 'b1;
  ccx_req   = 'b0;
  ccx_rs_a  = 'd1;
  ccx_rs_b  = 'd2;
  @(posedge clk); #1
  ccx_req  = 'b1;
  ccx_rs_a = 'd2;
  ccx_rs_b = 'd4;
  @(posedge clk); #1
  ccx_req  = 'b0;
  ccx_rs_a = 'd0;
  ccx_rs_b = 'd0;
  repeat(10) @(posedge clk);
  $finish;
end


endmodule