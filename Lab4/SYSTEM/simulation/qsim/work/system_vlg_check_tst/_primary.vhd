library verilog;
use verilog.vl_types.all;
entity system_vlg_check_tst is
    port(
        data_from_procr : in     vl_logic_vector(31 downto 0);
        data_to_procr   : in     vl_logic_vector(31 downto 0);
        ifetch_out      : in     vl_logic;
        mem_addr_out    : in     vl_logic_vector(31 downto 0);
        mem_read        : in     vl_logic;
        mem_write       : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end system_vlg_check_tst;
