/////////////////////////////////////////////////////
// RTL for UPF and Low-Power Design
// Author: team SOC 
// ECE-4/581 and can be used ECE-530
// Top level instantiate 4 sub-modules
// Top level has some logic elements
// Each module connects to other modules
////////////////////////////////////////////////////


module ece581_lp_top (
   	input logic [0:1] soc_in1,soc_in2,
   	input logic soc_reset,soc_oddeven_enable,soc_carry_in,
   	input logic upf_clk,
   	input logic en_A,en_B,en_C,en_D,
    	output logic soc_A_carry_out,soc_B_out,soc_C_out,soc_D_out,soc_equal,soc_B1_out,soc_D1_out,
    	output logic [0:1] soc_A_out,soc_A_sum_out
);

logic en_A,en_B,en_C,en_D;
logic soc_B2A,soc_C2A,soc_D2A,soc_A2B,soc_A2D,soc_C2B,soc_D2B,soc_B2C,soc_B2D,soc_D2C,soc_C2D;
logic [0:1]soc_A2C;

//Instantiate 4 sub-modules at the top level
modA A_inst (.soc_in1(soc_in1),.soc_in2(soc_in2),.soc_carry_in(soc_carry_in),.soc_B2A(soc_B2A),.soc_C2A(soc_C2A),.soc_D2A(soc_D2A),.upf_clk(upf_clk),.soc_A_carry_out(soc_A_carry_out),.soc_A2B(soc_A2B),.soc_A2C(soc_A2C),.soc_A2D(soc_A2D),.soc_A_out(soc_A_out),.soc_reset(soc_reset),.soc_A_sum_out(soc_A_sum_out), .en_A(en_A));

modB B_inst (.soc_in1(soc_in1), .soc_in2(soc_in2), .soc_reset(soc_reset), .upf_clk(upf_clk), .soc_A2B(soc_A2B), .soc_C2B(soc_C2B), .soc_D2B(soc_D2B), .soc_B2A(soc_B2A), .soc_B2C(soc_B2C), .soc_B2D(soc_B2D), .soc_B_out(soc_B_out), .soc_equal(soc_equal), .soc_B1_out(soc_B1_out), .en_B(en_B));

modC C_inst (.soc_in2(soc_in2), .upf_clk(upf_clk), .soc_A2C(soc_A2C), .soc_B2C(soc_B2C), .soc_D2C(soc_D2C), .soc_C2A(soc_C2A), .soc_C2B(soc_C2B), .soc_C2D(soc_C2D), .soc_C_out(soc_C_out), .soc_reset(soc_reset), .en_C(en_C));

modD D_inst (.soc_in1(soc_in1), .upf_clk(upf_clk), .soc_A_sum_out(soc_A_sum_out), .soc_A2D(soc_A2D), .soc_B2D(soc_B2D), .soc_C2D(soc_C2D), .soc_D2A(soc_D2A), .soc_D2B(soc_D2B), .soc_D2C(soc_D2C), .soc_D_out(soc_D_out), .soc_reset(soc_reset),.soc_oddeven_enable(soc_oddeven_enable), .soc_D1_out(soc_D1_out), .en_D(en_D));

endmodule

// Implement logic for each module of your choice
// Each module should sent out signal to othe 3 modules
// Each module should use the signals coming from other modules


//

module modA (
	input logic [0:1] soc_in1,soc_in2,
	input logic soc_carry_in,soc_B2A,soc_C2A,soc_D2A,
	input upf_clk,soc_reset, en_A,
	output logic soc_A_carry_out,soc_A2B,soc_A2D,
	output logic [0:1] soc_A_out,soc_A_sum_out,
	output logic [0:1] soc_A2C
);


always_ff @(posedge upf_clk or negedge soc_reset) 
begin
	if(!soc_reset)
	begin
		soc_A_sum_out = 0;
		soc_A_out = 0;	
	        soc_A2B = 1 ;
	        soc_A2C = 1 ;
	        soc_A2D = 1 ; 
	end
	else
	begin	
		{soc_A_carry_out,soc_A_sum_out} = soc_in1 + soc_in2+soc_carry_in;
		
		soc_A_out = soc_B2A && soc_C2A && soc_D2A;

		//sending signals to other modules
		//when this module is not powergated ther outputs carry 1, when it is powergated the outputs are clamped to 0
	        soc_A2B = soc_A_out ;
	        soc_A2C = soc_A_sum_out;
	        soc_A2D = soc_A_out ; 
	end  
end
endmodule



module modB (soc_in1,soc_in2,soc_reset,upf_clk,soc_A2B,soc_C2B,soc_D2B,soc_B2A,soc_B2C,soc_B2D,soc_B_out,soc_equal,soc_B1_out,en_B);
    input logic [1:0] soc_in1,soc_in2;
    input logic soc_A2B,soc_C2B,en_B;
    input logic upf_clk,soc_reset;
    input logic soc_D2B;
    output logic soc_B2A,soc_B2C,soc_B2D;
    output logic soc_B_out, soc_B1_out, soc_equal;
logic soc_sum;
    always @(posedge upf_clk or negedge soc_reset) begin
	if(!soc_reset)
	  soc_B_out=0;
	else 
	begin
		soc_B_out = (soc_in1>soc_in2)?1'b1:1'b0; 
		soc_B1_out = soc_A2B && soc_C2B && soc_D2B;

		// sending signals to other modules
		soc_B2A = soc_B_out;
		soc_B2C = soc_B_out;
		soc_B2D = soc_B_out;
 
	 	// comparing the signals from other blocks
		soc_sum = soc_D2B^soc_C2B;        
		if (soc_sum == soc_D2B) //compares soc_D2B i.e., soc_sum to soc_B_out module soc_sum
			soc_equal = 1; // this means both are equal
		else soc_equal = 0; // this means both the sums are not equal
	end	
    end         
endmodule

module modC (
	input logic [0:1] soc_in2,soc_A2C,
	input logic upf_clk, soc_B2C, soc_D2C,soc_reset,en_C, 
	output logic soc_C2A,soc_C2B,soc_C2D, soc_C_out
);


	logic C;
	logic [0:1] count;
 

      	always @(posedge upf_clk or negedge soc_reset) 
	begin
       		if(soc_reset == 0) 
		begin
			C=0; 
			count =0;
		end
       		else 
		begin     
		soc_C_out = soc_A2C && soc_B2C && soc_D2C;
        		if(soc_in2[0]==1) //this checks if the input1 is odd or even
				C=1;       		        
			else  
				C=0;
			
			if(soc_B2C & soc_D2C)
			begin
				for (int i=0;i<soc_A2C;i++)
				begin
					count = count+1'b1;
				end
			end
			soc_C2A = C;
			soc_C2B = C;
			soc_C2D = C;
		end
  		
	end

endmodule


module modD (soc_in1,upf_clk,soc_A_sum_out,soc_A2D,soc_B2D,soc_C2D,soc_D2A,soc_D2B,soc_D2C,soc_D_out,soc_reset,soc_oddeven_enable,soc_D1_out,en_D);
    	input logic [0:1] soc_in1;
	input logic [0:1] soc_A_sum_out;
    	input logic upf_clk,soc_reset,soc_oddeven_enable,en_D;
    	input logic soc_A2D,soc_B2D,soc_C2D;
    	output logic soc_D2A,soc_D2B,soc_D2C;
    	output logic soc_D_out,soc_D1_out;

	logic D;
      	always @(posedge upf_clk or negedge soc_reset) 
	begin
       		if(!soc_reset) 
			D=0; 
       		else 
		begin    

		soc_D1_out = soc_A2D && soc_B2D && soc_C2D;
        		if (!soc_oddeven_enable)
			begin
				if(soc_in1[0]==1) //this checks if the input1 is odd or even
					D=1;       		        
				else  
					D=0;
				if(soc_A_sum_out[0]==1) //this checks if the sum is odd or even
					soc_D_out=1;       		        
				else  
					soc_D_out=0;
  				soc_D2B = soc_D_out;	
			end
			else
			begin
				soc_D_out = soc_D_out;
				D = D;
			end
			soc_D2A = D;
			soc_D2B = D;
			soc_D2C = D;
	
		end
	end
endmodule
