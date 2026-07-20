`include "defines.svh"

class apb_master_test;

virtual apb_m_interface drv_vif;
virtual apb_m_interface ip_mon_vif;
virtual apb_m_interface op_mon_vif;

apb_master_environment env;

function new(virtual apb_m_interface drv_vif,
	     virtual apb_m_interface ip_mon_vif,
	     virtual apb_m_interface op_mon_vif
);
	this.drv_vif = drv_vif;
	this.ip_mon_vif = ip_mon_vif;
	this.op_mon_vif = op_mon_vif;
endfunction

task run();
	env = new(drv_vif, ip_mon_vif, op_mon_vif);
	env.build();
	env.start();
endtask
endclass


class apb_master_write_test extends apb_master_test;

apb_m_write_transaction trans_write;

function new(
    virtual apb_m_interface drv_vif,
    virtual apb_m_interface ip_mon_vif,
    virtual apb_m_interface op_mon_vif
);
    super.new(drv_vif, ip_mon_vif, op_mon_vif);
endfunction

task run();
    env = new(drv_vif, ip_mon_vif, op_mon_vif);
    env.build();

    begin
        trans_write = new();
        env.gen.g_th = trans_write;
    end

    env.start();
endtask

endclass


class apb_master_read_test extends apb_master_test;

apb_m_read_transaction trans_read;

function new(
    virtual apb_m_interface drv_vif,
    virtual apb_m_interface ip_mon_vif,
    virtual apb_m_interface op_mon_vif
);
    super.new(drv_vif, ip_mon_vif, op_mon_vif);
endfunction

task run();
    env = new(drv_vif, ip_mon_vif, op_mon_vif);
    env.build();

    begin
        trans_read = new();
        env.gen.g_th = trans_read;
    end

    env.start();
endtask

endclass


class apb_master_b2b_write_test extends apb_master_test;

apb_m_b2b_write_transaction trans_b2b_write;

function new(
    virtual apb_m_interface drv_vif,
    virtual apb_m_interface ip_mon_vif,
    virtual apb_m_interface op_mon_vif
);
    super.new(drv_vif, ip_mon_vif, op_mon_vif);
endfunction

task run();
    env = new(drv_vif, ip_mon_vif, op_mon_vif);
    env.build();

    begin
        trans_b2b_write = new();
        env.gen.g_th = trans_b2b_write;
    end

    env.start();
endtask

endclass


class apb_master_b2b_read_test extends apb_master_test;

apb_m_b2b_read_transaction trans_b2b_read;

function new(
    virtual apb_m_interface drv_vif,
    virtual apb_m_interface ip_mon_vif,
    virtual apb_m_interface op_mon_vif
);
    super.new(drv_vif, ip_mon_vif, op_mon_vif);
endfunction

task run();
    env = new(drv_vif, ip_mon_vif, op_mon_vif);
    env.build();

    begin
        trans_b2b_read = new();
        env.gen.g_th = trans_b2b_read;
    end

    env.start();
endtask

endclass


class apb_master_regression_test extends apb_master_test;

    apb_m_transaction            trans;
    apb_m_write_transaction      trans_write;
    apb_m_read_transaction       trans_read;
    apb_m_b2b_write_transaction  trans_b2b_write;
    apb_m_b2b_read_transaction   trans_b2b_read;

    function new(
        virtual apb_m_interface drv_vif,
        virtual apb_m_interface ip_mon_vif,
        virtual apb_m_interface op_mon_vif
    );
        super.new(drv_vif, ip_mon_vif, op_mon_vif);
    endfunction

    task run();

        env = new(drv_vif, ip_mon_vif, op_mon_vif);
        env.build();

        // Random Test
        trans = new();
        env.gen.g_th = trans;
        env.start();

        // Write Test
        trans_write = new();
        env.gen.g_th = trans_write;
        env.start();

        // Read Test
        trans_read = new();
        env.gen.g_th = trans_read;
        env.start();

        // Back-to-Back Write Test
        trans_b2b_write = new();
        env.gen.g_th = trans_b2b_write;
        env.start();

        // Back-to-Back Read Test
        trans_b2b_read = new();
        env.gen.g_th = trans_b2b_read;
        env.start();

    endtask

endclass
