// Title: Test bench for VGA Monitor interface using Altera DE1 Board
// Programmer name: Ashish Ashok Gopal, 1702005, FY MTech
// Department: Department of Electronics Engineering
// Mentor: Prof. Arati Phadke
// Department: Department of Electronics Engineering
// Date: 27/10/2017

// ***************Test Bench starts here*************************
module VGAExpansionModule_TB;
	reg clk;
	wire [3:0] red;
	wire [3:0] green;
	wire [3:1] blue;
	wire hsync,vsync;
	
	VGAExpansionModule u1(clk,hsync,vsync,red,green,blue);
	
	always #1 clk= ~clk;
	
	initial begin
		#10;
	end	
endmodule 

// ****************Test Bench ends here**************************
