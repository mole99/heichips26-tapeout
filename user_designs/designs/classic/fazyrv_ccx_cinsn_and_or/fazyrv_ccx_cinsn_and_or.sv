// SPDX-FileCopyrightText: © 2026 Meinhard Kissich
// SPDX-License-Identifier: Apache-2.0

// This user design demonstrates how to implement custom FazyRV CCX
// instructions in the FPGA fabric. The interface allows returning
// the result chunks, or delaying them by an arbitrary number of cycles.
// The latter is required when, e.g., the entire operand is required
// to compute the result.
//
// Combinational:
// =============
// clk_i        : ┌─┐_┌─┐_┌─┐_┌─┐_┆┌─┐_┌─┐_┌─┐_
// ccx_req_i    : ________┌───┐___┆____________
// ccx_resp_o   : ________________┆____┌───┐___
// ccx_rs{a|b}_i: xxxxxxxx<c0><c1>┆<c6><c7>xxxx
// ccx_res_o    : xxxxxxxx<r0><r1>┆<r6><r7>xxxx
//
//
// Delayed:
// ========
// clk_i        : ┌─┐_┌─┐_┌─┐_┌─┐_┌─┐_┌─┐_┌─┐_┆┌─┐_┌─┐_┆┌─┐_┌─┐_┌─┐_
// ccx_req_i    : ________┌───┐_______________┆________┆____________
// ccx_resp_o   : ____________________________┆________┆____┌───┐___
// ccx_rs{a|b}_i: xxxxxxxx<c0><c1><..><c7>xxxx┆xxxxxxxx┆xxxxxxxxxxxx
// ccx_res_o    : xxxxxxxxxxxxxxxxxxxxxxxxxxxx┆xxxx<r0>┆<r2><r3>xxxx
//

`default_nettype none

module fazyrv_ccx_cinsn_and_or #(parameter CHUNKSIZE=4) (
  input  logic                 clk_i,
  input  logic [CHUNKSIZE-1:0] ccx_rs_a_i,
  input  logic [CHUNKSIZE-1:0] ccx_rs_b_i,
  output logic [CHUNKSIZE-1:0] ccx_res_o,
  input  logic                 ccx_req_i,
  output logic                 ccx_resp_o,
  input  logic                 ccx_sel_i
);

// TODO: FPGA interface
// TODO: QSPI passthrough

localparam RES_DLY = 1;

logic [CHUNKSIZE-1:0]                  shift_res_r [0:RES_DLY-1];
logic [(RES_DLY-1 + 32/CHUNKSIZE-1):0] shift_req_r;

always_ff @(posedge clk_i) begin
  if (ccx_sel_i)  shift_res_r[0] <= ccx_rs_a_i & ccx_rs_b_i;
  else            shift_res_r[0] <= ccx_rs_a_i | ccx_rs_b_i;

  shift_req_r[0] <= ccx_req_i;
end

genvar i;

generate for (i = 1; i < RES_DLY; i++) begin
  always_ff @(posedge clk_i) shift_res_r[i] <= shift_res_r[i-1];
end endgenerate

generate for (i = 1; i < RES_DLY + 32/CHUNKSIZE-1; i++) begin
  always_ff @(posedge clk_i) shift_req_r[i] <= shift_req_r[i-1];
end endgenerate

assign ccx_res_o  = shift_res_r[RES_DLY-1];
assign ccx_resp_o = shift_req_r[RES_DLY-1 + 32/CHUNKSIZE-1];

endmodule
