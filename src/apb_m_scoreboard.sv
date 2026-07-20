`include "defines.svh"

class apb_m_scoreboard;

int pass_cnt;
int fail_cnt;

apb_m_transaction ipm_th;
apb_m_transaction opm_th;

mailbox #(apb_m_transaction) ipm_mbx;
mailbox #(apb_m_transaction) opm_mbx;

function new(mailbox #(apb_m_transaction) ipm_mbx,
             mailbox #(apb_m_transaction) opm_mbx);
    this.ipm_mbx = ipm_mbx;
    this.opm_mbx = opm_mbx;
endfunction


task start();
    for(int i=0;i<`NT;i++) begin

        ipm_mbx.get(ipm_th);
        opm_mbx.get(opm_th);

        $display("\n[%t]---------------- SCOREBOARD : Transaction %0d ----------------", $time, i);

        //write
        if(ipm_th.write_read) begin

            if( (ipm_th.addr_in == opm_th.PADDR) &&
                (ipm_th.wdata_in == opm_th.PWDATA) &&
                (ipm_th.strb_in == opm_th.PSTRB) &&
                (opm_th.PWRITE == 1'b1)) begin

                $display("PASS : WRITE MATCH");

                $display("Expected : ADDR=%h DATA=%h STRB=%h",
                         ipm_th.addr_in,
                         ipm_th.wdata_in,
                         ipm_th.strb_in);

                $display("Actual   : ADDR=%h DATA=%h STRB=%h",
                         opm_th.PADDR,
                         opm_th.PWDATA,
                         opm_th.PSTRB);

                pass_cnt++;

            end
            else begin

                $display("FAIL : WRITE MISMATCH");

                $display("Expected : ADDR=%h DATA=%h STRB=%h",
                         ipm_th.addr_in,
                         ipm_th.wdata_in,
                         ipm_th.strb_in);

                $display("Actual   : ADDR=%h DATA=%h STRB=%h",
                         opm_th.PADDR,
                         opm_th.PWDATA,
                         opm_th.PSTRB);

                fail_cnt++;

            end

        end


        //read
        else begin

            if( (ipm_th.addr_in == opm_th.PADDR) &&
                (ipm_th.PRDATA == opm_th.rdata_out) &&
                (opm_th.PWRITE == 1'b0) ) begin

                $display("PASS : READ MATCH");

                $display("Expected : ADDR=%h RDATA=%h",
                         ipm_th.addr_in,
                         ipm_th.PRDATA);

                $display("Actual   : ADDR=%h RDATA=%h",
                         opm_th.PADDR,
                         opm_th.rdata_out);

                pass_cnt++;

            end
            else begin

                $display("FAIL : READ MISMATCH");

                $display("Expected : ADDR=%h RDATA=%h",
                         ipm_th.addr_in,
                         ipm_th.PRDATA);

                $display("Actual   : ADDR=%h RDATA=%h PWRITE=%0d",
                         opm_th.PADDR,
                         opm_th.rdata_out,
                         opm_th.PWRITE);

                fail_cnt++;

            end

        end


        //error
        if((ipm_th.PSLVERR && ipm_th.PENABLE && ipm_th.PREADY && ipm_th.PSEL) == (opm_th.error))begin
	//if((ipm_th.PSLVERR) == (opm_th.error))begin
            $display("PASS : ERROR MATCH exp=%0d act=%0d",
                     ipm_th.PSLVERR && ipm_th.PENABLE && ipm_th.PREADY && ipm_th.PSEL ,
                     opm_th.error);
	    pass_cnt++;
	end
        else begin

            $display("FAIL : ERROR MISMATCH exp=%0d act=%0d",
                     ipm_th.PSLVERR && ipm_th.PENABLE && ipm_th.PREADY && ipm_th.PSEL,
                     opm_th.error);
	    fail_cnt++;
	end
    end

endtask


task compare_report();

    $display("======================================================");
    $display("               SCOREBOARD SUMMARY");
    $display("======================================================");
    $display("PASS COUNT = %0d", pass_cnt);
    $display("FAIL COUNT = %0d", fail_cnt);
    $display("TOTAL      = %0d", pass_cnt+fail_cnt);
    $display("======================================================");

endtask

endclass
