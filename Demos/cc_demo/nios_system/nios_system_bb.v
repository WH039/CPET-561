
module nios_system (
	clk_clk,
	reset_reset_n,
	custom_ip_ext_data,
	custom_ip_invalid,
	custom_ip_ext_addr);	

	input		clk_clk;
	input		reset_reset_n;
	output	[31:0]	custom_ip_ext_data;
	input		custom_ip_invalid;
	input	[2:0]	custom_ip_ext_addr;
endmodule
