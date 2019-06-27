module cache(read1,write1,writedata,readHit,r1e,w1e,clk,readout1);
input [15:0]write1;
input [15:0]writedata;
input r1e,w1e,clk;
input [15:0]read1;
output [15:0]readout1;
output readHit;
reg[15:0]readout1;
reg [262:0]cache[127:0];
reg [15:0]mem[65535:0];
reg [4:0]tag;
reg [6:0]index;
reg [15:0]mem_ind,mem_ind1;
reg [7:0]rem;
reg readHit;
integer t;
initial begin
  for(t=0;t<128;t=t+1) begin
    cache[t]<=0;
  end
  for(t=0;t<65535;t=t+1)begin
    mem[t]<=0;
  end
  mem[0]<=1500;
  mem[1]<=1020;
  mem[16]<=156;
  mem[128]<=32;
end
integer i;
integer j;
always @ (posedge clk) begin
    tag=read1[15:11];
    index=read1[10:4];
    rem=read1[3:0]<<4;
    mem_ind={read1[15:4],{4'b0000}};
    mem_ind1=mem_ind;
      if(r1e==1) begin                                     //valid bit
        if(read1[tag]==cache[index][262:258] && cache[index][257]==1) begin    //read hit
            readHit=1;
            readout1=cache[index][rem+15-:15];
        end
      else begin
            readHit=0;
            // $display("read miss");                //dirtybit
            if(cache[index][257]==0 || cache[index][256]==0) begin
              j=15;
              for(i=0;i<16;i=i+1) begin
                cache[index][j-:15]=mem[mem_ind];
              //  $display("%b",cache[index][j-:15]);
                mem_ind=mem_ind+1;
                j=j+16;
              end
              cache[index][257]=1;
              readout1=cache[index][rem+15-:15];
            end
            else begin
              if(cache[index][256]==1) begin   //dirtybit=1
                  j=15;
                  for(i=0;i<16;i=i+1) begin
                    mem[mem_ind1]=cache[index][j-:15];
                    mem_ind1=mem_ind1+1;
                    j=j+16;
                  end
                  j=15;
                  for(i=0;i<16;i=i+1) begin
                    cache[index][j-:15]=mem[mem_ind];
                    mem_ind=mem_ind+1;
                    j=j+16;
                  end
                  cache[index][257]=1;
                  readout1=cache[index][rem+15-:15];
              end
            end
      end
    end



    if(w1e==1) begin
        if(write1[tag]==cache[index][262:258] && cache[index][257]==1) begin
          cache[index][rem+15-:15]=writedata;
          cache[index][256]=1;
        end
      else begin
          if(cache[index][257]==0 || cache[index][256]==0) begin
            j=15;
            for(i=0;i<16;i=i+1) begin
              cache[index][j-:15]=mem[mem_ind];
              mem_ind=mem_ind+1;
              j=j+16;
            end
            cache[index][257]=1;
            cache[index][rem+15-:15]=writedata;
            cache[index][256]=1;
          end
          else begin
            if(cache[index][256]==1) begin
                j=15;
                for(i=0;i<16;i=i+1) begin
                  mem[mem_ind1]=cache[index][j-:15];
                  mem_ind1=mem_ind1+1;
                  j=j+16;
                end
                j=15;
                for(i=0;i<16;i=i+1) begin
                  cache[index][j-:15]=mem[mem_ind];
                  mem_ind=mem_ind+1;
                  j=j+16;
                end
                cache[index][257]=1;
                cache[index][rem+15-:15]=writedata;
                cache[index][256]=1;
            end
          end
      end
    end
end
endmodule
