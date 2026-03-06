// SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1 ns / 1 ps
`default_nettype none

module heichips25_top_tb;

    initial begin
        `ifdef DUMP_WAVEFORMS
            $dumpfile("heichips25_top_tb.fst");
            $dumpvars(0, heichips25_top_tb);
        `endif
    end

    // Pads
    wire          fpga_clk_PAD;
    wire          fpga_rst_n_PAD;
    
    wire          fpga_sclk_PAD;
    wire          fpga_cs_n_PAD;
    wire          fpga_mosi_PAD;
    wire          fpga_miso_PAD;
    
    wire          fpga_mode_PAD;
    wire          fpga_config_busy_PAD;
    wire          fpga_config_configured_PAD;
    wire [3:0]    fpga_config_slot_PAD;
    wire          fpga_config_trigger_PAD;
    
    wire [31:0]   fpga_io_PAD;

    // User I/Os
    wire         user_usb_dn_PAD;
    wire         user_usb_dp_PAD;
    wire         user_usb_dp_up_PAD;
    
    wire         user_tmds_b_PAD;
    wire         user_tmds_g_PAD;
    wire         user_tmds_r_PAD;
    wire         user_tmds_clk_PAD;
    
    wire         internal_analog_pin0_PAD;
    wire         internal_analog_pin1_PAD;
    wire         internal_analog_adc_PAD;
    
    wire         pudding_i_in_PAD;
    wire         pudding_i_out_PAD;
    
    `ifdef BITSTREAM_FLASH
    
    // SPI Flash - Bitstream
    spiflash_powered i_spiflash_powered (
	    .csb (fpga_cs_n_PAD),
	    .clk (fpga_sclk_PAD),
	    .io0 (fpga_mosi_PAD), // MOSI
	    .io1 (fpga_miso_PAD), // MISO
	    .io2 (  ),
	    .io3 (  )
    );
    
    // Pull down z to 0
    //assign (pull1, pull0) fpga_miso_PAD = 1'b0;
    
    `else

    assign fpga_cs_n_PAD = 1'b1;
    assign fpga_sclk_PAD = 1'b0;
    assign fpga_mosi_PAD = 1'b0;

    `endif

    // heichips25_top instance
    heichips25_top heichips25_top (
        .fpga_clk_PAD,
        .fpga_rst_n_PAD,

        .fpga_sclk_PAD,
        .fpga_cs_n_PAD,
        .fpga_mosi_PAD,
        .fpga_miso_PAD,

        .fpga_mode_PAD,
        .fpga_config_busy_PAD,
        .fpga_config_configured_PAD,
        .fpga_config_slot_PAD,
        .fpga_config_trigger_PAD,

        .fpga_io_PAD,
        
        // User I/Os
        .user_usb_dn_PAD,
        .user_usb_dp_PAD,
        .user_usb_dp_up_PAD,
            
        .user_tmds_b_PAD,
        .user_tmds_g_PAD,
        .user_tmds_r_PAD,
        .user_tmds_clk_PAD,
            
        .internal_analog_pin0_PAD,
        .internal_analog_pin1_PAD,
        .internal_analog_adc_PAD,
            
        .pudding_i_in_PAD,
        .pudding_i_out_PAD
    );

endmodule

module clk_buf(input A, output X);
assign X = A;
endmodule

module break_comb_loop(input A, output X);
assign #0.1 X = A;
endmodule

module bondpad_70x70 (input pad);
endmodule
