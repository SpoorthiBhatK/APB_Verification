`include "defines.svh"

class apb_m_driver;

apb_m_transaction d_th;
mailbox #(apb_m_transaction) gd_mbx;
virtual apb_m_interface.DRV vif;

function new(mailbox #(apb_m_transaction) gd_mbx,
             virtual apb_m_interface.DRV vif);
    this.gd_mbx = gd_mbx;
    this.vif    = vif;
endfunction

task start();

    repeat(3) @(vif.driver_cb);

    for(int i = 0; i < `NT; i++) begin

        repeat(1) @(vif.driver_cb);

        if(vif.driver_cb.PRESETn == 0) begin
            vif.driver_cb.PRDATA     <= 0;
            vif.driver_cb.PREADY     <= 0;
            vif.driver_cb.PSLVERR    <= 0;

            @(vif.driver_cb);

            vif.driver_cb.transfer   <= 0;
            vif.driver_cb.write_read <= 0;
            vif.driver_cb.addr_in    <= 0;
            vif.driver_cb.wdata_in   <= 0;
            vif.driver_cb.strb_in    <= 0;

            $display("\n\n\n[%t]---------------Driver Reset------------NT: %d------",
                     $time, i);

            $display("PRDATA: %h, PREADY: %d, PSLVERR: %d, transfer: %d, write_read: %d, addr_in: %h, wdata_in: %h, strb_in: %d",
                     vif.driver_cb.PRDATA,
                     vif.driver_cb.PREADY,
                     vif.driver_cb.PSLVERR,
                     vif.driver_cb.transfer,
                     vif.driver_cb.write_read,
                     vif.driver_cb.addr_in,
                     vif.driver_cb.wdata_in,
                     vif.driver_cb.strb_in);

            //@(vif.driver_cb);
            //continue;
        end

        d_th = new();
        gd_mbx.get(d_th);

        $display("No reset happening- Get from mailbox");

        fork

        begin
            @(vif.driver_cb);

            vif.driver_cb.transfer   <= d_th.transfer;
            vif.driver_cb.write_read <= d_th.write_read;
            vif.driver_cb.addr_in    <= d_th.addr_in;
            vif.driver_cb.wdata_in   <= d_th.wdata_in;
            vif.driver_cb.strb_in    <= d_th.strb_in;

            @(vif.driver_cb);
            vif.driver_cb.transfer <= 1'b0;

            if(d_th.transfer) begin

                while(!(vif.driver_cb.PSEL && vif.driver_cb.PENABLE))
                    @(vif.driver_cb);

                d_th.PSEL     <= vif.driver_cb.PSEL;
                d_th.PENABLE  <= vif.driver_cb.PENABLE;

                vif.driver_cb.PREADY  <= 1;
                vif.driver_cb.PRDATA  <= d_th.PRDATA;
                vif.driver_cb.PSLVERR <= d_th.PSLVERR;

                @(vif.driver_cb);

                $display("\n\n\n[%t]---------------Driver driving data---------NT: %d------",
                         $time, i);

                $display("PRDATA: %h, PREADY: %d, PSLVERR: %d, transfer: %d, write_read: %d, addr_in: %h, wdata_in: %h, strb_in: %d",
                         d_th.PRDATA,
                         d_th.PREADY,
                         d_th.PSLVERR,
                         d_th.transfer,
                         d_th.write_read,
                         d_th.addr_in,
                         d_th.wdata_in,
                         d_th.strb_in);

                @(vif.driver_cb);

                vif.driver_cb.PREADY <= 0;

            end
        end

        begin
            wait(!(vif.driver_cb.PRESETn));
        end

        join_any
        disable fork;

        if(vif.driver_cb.PRESETn == 0) begin

            vif.driver_cb.PRDATA     <= 0;
            vif.driver_cb.PREADY     <= 0;
            vif.driver_cb.PSLVERR    <= 0;
            //@(vif.driver_cb);
            vif.driver_cb.transfer   <= 0;
            vif.driver_cb.write_read <= 0;
            vif.driver_cb.addr_in    <= 0;
            vif.driver_cb.wdata_in   <= 0;
            vif.driver_cb.strb_in    <= 0;
            //repeat(1)@(vif.driver_cb);

            $display("\n\n\n[%t]---------------Driver Reset inside fork join------------NT: %d------",
                     $time, i);

            $display("PRDATA: %h, PREADY: %d, PSLVERR: %d, transfer: %d, write_read: %d, addr_in: %h, wdata_in: %h, strb_in: %d",
                     d_th.PRDATA,
                     d_th.PREADY,
                     d_th.PSLVERR,
                     d_th.transfer,
                     d_th.write_read,
                     d_th.addr_in,
                     d_th.wdata_in,
                     d_th.strb_in);

            //continue;
        end

    end

endtask

endclass



