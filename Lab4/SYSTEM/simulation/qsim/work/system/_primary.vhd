library verilog;
use verilog.vl_types.all;
entity system is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        ifetch_out      : out    vl_logic;
        mem_addr_out    : out    vl_logic_vector(31 downto 0);
        data_from_procr : out    vl_logic_vector(31 downto 0);
        data_to_procr   : out    vl_logic_vector(31 downto 0);
        mem_read        : out    vl_logic;
        mem_write       : out    vl_logic
    );
end system;
