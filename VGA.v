// Title: VGA Monitor interface using Altera DE1 Board
// Aim: Write a Verilog code for displaying 3 squares on monitor with different colour. Size and position of the square should be controllable. Implement the design on DE1 board.
// Programmer name: Ashish Ashok Gopal, 1702005, FY MTech
// Department: Department of Electronics Engineering
// Mentor: Prof. Arati Phadke
// Department: Department of Electronics Engineering
// Date: 27/10/2017

// ***************Program starts here*************************

module VGAExpansionModule(clk,hsync,vsync,red,green,blue);
	// Colours to be displayed on 
	output reg [3:0] red;
	output reg [3:0] green;
	output reg [3:1] blue;
	
	// Horizontal and vertical sync for VGA
	output reg hsync,vsync;
	
	// Main clock input (24Mhz)
	input clk;

	// Internal registers
	reg clk1=1'b0;			// New clock
	reg [10:0] rgb;			
	reg [2000:0] counter;
	
	// Setting resolution of the screen
	reg hcount=640;
	reg vcount=480;
	
	// Setting counts from where it should start
	reg nexthcount=641;
	reg nextvcount=481;

	// New clock definition
	always @(posedge clk) 
		clk1 = ~clk1;
	
	always@(posedge clk1)
		begin
		//Maximum Horizontal count is limited to 799 for 640 x 480 display so
		//that it will fit the screen.
			if (hcount==799)
			begin
				hcount<=0;
				//Maximum Vertical count is limited to 524 for 640 x 480 display so
				//that it fit's the screen.
				if(vcount==524)
					vcount<=0;
				else
					vcount <= vcount + 1;
				end
			else
				hcount <= hcount + 1;
				
			if (nexthcount == 799)
				begin
					nexthcount <= 0;
					// Make sure we got the roll over covered
					if (nextvcount == 524)
						nextvcount <= 0;
					else
						nextvcount <= vcount + 1;
				end
			else
				nexthcount <= hcount + 1;
			
			//Check if the count is within the minimum and maximum value for proper generation of the vertical sync signal
			if (vcount >= 490 && vcount < 492)
				vsync <= 1'b0;
			else
				vsync <= 1'b1;
			
			//Check if the count is within the minimum and maximum value for proper generation of the horizontal sync signal
			if (hcount >= 656 && hcount < 752)
				hsync <= 1'b0;
			else
				hsync <= 1'b1;
			
			//If in display range then display the pixel.
			if (hcount < 640 && vcount < 480)
				begin
					red<= rgb [10:7];
					green<= rgb [6:3];
					blue<= rgb [2:0];
				end
		end
endmodule

module finaloutput(outputwidth,outputheight,clk,hcounter,vcounter,pixels);
	// Defining the width and the height of the displayed text
	output reg outputwidth = 250;
	output reg outputheight = 200;
	
	// This counter will tell whether the correct position on the screen is reached or not where the data is to be displayed.
	input [1023:0] hcounter;
	input [1023:0] vcounter;
	
	// Connect 50Mhz clock here.
	input clk;
	
	output reg [10:0] pixels;
	
	// Defining registers telling the exact position on display.
	reg [1023:0] x;
	reg [1023:0] y;

	always @(posedge clk)
		begin
		if(hcounter >= outputwidth && hcounter < 200 && vcounter >= outputheight && vcounter < 200)
			pixels <= 11'b11110000000;
		else if (hcounter >= (100 + outputwidth )&& hcounter < 300 && vcounter >= (100+outputheight) && vcounter <300)
			pixels <= 11'b01100000110;
		else if (hcounter >= (200 + outputwidth ) && (hcounter < 400)&& (vcounter >= (200+outputheight)) && (vcounter <400))
			pixels <= 11'b00000000111;
		else
			pixels<=11'b 00000000000;
		end
endmodule 

// ***************Program ends here*************************