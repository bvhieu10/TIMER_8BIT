module clock_select(
input pclk, presetn,
input [1:0] cks,
output reg clk_in
);

wire pclk_2, pclk_4, pclk_8, pclk_16;
reg q1, q2, q3, q4;
always @(cks or pclk_2 or pclk_4 or pclk_8 or pclk_16) begin
	case(cks)
	2'b00: clk_in <= pclk_2;
	2'b01: clk_in <= pclk_4;
	2'b10: clk_in <= pclk_8;
	2'b11: clk_in <= pclk_16;
	endcase
end

//PCLK_2
always @(posedge pclk or negedge presetn) begin
	if(!presetn) begin
	  q1 <= 1'b0;
	end
	else begin
	  q1 <= !q1;
	end
end

//PCLK_4
always @(posedge pclk_2 or negedge presetn) begin
	if(!presetn) begin
	  q2 <= 1'b0;
	end
	else begin
	  q2 <= !q2;
	end
end

//PCLK_8
always @(posedge pclk_4 or negedge presetn) begin
	if(!presetn) begin
	  q3 <= 1'b0;
	end
	else begin
	  q3 <= !q3;
	end
end

//PCLK_16
always @(posedge pclk_8 or negedge presetn) begin
	if(!presetn) begin
	  q4 <= 1'b0;
	end
	else begin
	  q4 <= !q4;
	end
end

assign pclk_2= ~q1;
assign pclk_4= ~q2;
assign pclk_8= ~q3;
assign pclk_16=~q4;
endmodule


