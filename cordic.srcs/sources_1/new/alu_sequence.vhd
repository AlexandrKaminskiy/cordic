----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2024 01:26:45
-- Design Name: 
-- Module Name: alu_sequence - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu_sequence is
  generic (N : integer := 16; 
           ITERATION_QUANTITY : integer := 12);
  Port ( 
    clk : in std_logic;
    goal: in std_logic_vector(N - 1 downto 0);
    x_in: in std_logic_vector(N - 1 downto 0);
    y_in: in std_logic_vector(N - 1 downto 0);
    result_out : out std_logic_vector(N - 1 downto 0);
    x_out: out std_logic_vector(N - 1 downto 0);
    y_out: out std_logic_vector(N - 1 downto 0)
  );
end alu_sequence;

architecture Behavioral of alu_sequence is

type tp_holder is array (0 to ITERATION_QUANTITY - 1) of std_logic_vector (N - 1 downto 0);
type tp_out_holder is array (0 to ITERATION_QUANTITY) of std_logic_vector (N - 1 downto 0);
type tp_out_holder_scaled is array (0 to ITERATION_QUANTITY * 2) of std_logic_vector (N - 1 downto 0);

constant ROM : tp_holder := 
(
    "0001100100100001", "0000111011010110", "0000011111010110", "0000001111111010", "0000000111111111", "0000000011111111", "0000000001111111", "0000000000111111", "0000000000011111", "0000000000001111", "0000000000000111", "0000000000000011"
);

component cordic_alu is
  generic (N : integer := 16);
  Port ( 
    clk : in std_logic;
    iteration: in std_logic_vector(3 downto 0);
    arctan_value: in std_logic_vector(N - 1 downto 0);
    result_in : in std_logic_vector(N - 1 downto 0);
    goal: in std_logic_vector(N - 1 downto 0);
    x_in: in std_logic_vector(N - 1 downto 0);
    y_in: in std_logic_vector(N - 1 downto 0);
    result_out : out std_logic_vector(N - 1 downto 0);
    x_out: out std_logic_vector(N - 1 downto 0);
    y_out: out std_logic_vector(N - 1 downto 0);
    goal_out : out std_logic_vector(N - 1 downto 0)
  );
end component;

component scailer is
    generic (N : integer := 16);
    Port ( 
      clk: in std_logic;
      e_i: in std_logic;
      shift: in std_logic_vector(3 downto 0);
      x_result: in std_logic_vector(N - 1 downto 0);
      y_result: in std_logic_vector(N - 1 downto 0);
      x_in: in std_logic_vector(N - 1 downto 0);
      y_in: in std_logic_vector(N - 1 downto 0);
      x_out: out std_logic_vector(N - 1 downto 0);
      y_out: out std_logic_vector(N - 1 downto 0);
      angle_result_in: in std_logic_vector(N - 1 downto 0);
      angle_result_out: out std_logic_vector(N - 1 downto 0)
    );
end component;

constant E: std_logic_vector(0 to N - 1) := "0001001101100111";

signal s_iteration: std_logic_vector(3 downto 0) := "0000";
signal x_holder : tp_out_holder_scaled := 
(
    x_in, "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000"
);
signal y_holder : tp_out_holder_scaled := 
(
    y_in, "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000"
);

signal result_holder : tp_out_holder_scaled := 
(
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000"
);

signal goal_holder : tp_out_holder := 
(
    goal, "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000"
);

signal result_in : std_logic_vector (n - 1 downto 0) := "0000000000000000";
signal s_test : std_logic := '0';
begin

test: process(clk) 
begin
    if (rising_edge(clk)) then
        goal_holder(0) <= goal;
        s_test <= not s_test;
    end if;
end process;

alu0: cordic_alu port map (
    clk, 
    std_logic_vector(to_unsigned(0, 4)), 
    ROM(0), 
    result_holder(0), 
    goal, 
    x_in, 
    y_in, 
    result_holder(1), 
    x_holder(1), 
    y_holder(1),
    goal_holder(1)
);
SEQ: FOR I IN 1 TO ITERATION_QUANTITY - 1 GENERATE
    alu: cordic_alu port map (
        clk, 
        std_logic_vector(to_unsigned(I, 4)), 
        ROM(I), 
        result_holder(I), 
        goal_holder(I), 
        x_holder(I), 
        y_holder(I), 
        result_holder(I + 1), 
        x_holder(I + 1), 
        y_holder(I + 1),
        goal_holder(I + 1)
    );

END GENERATE;

scale0: scailer port map (
        clk => clk, 
        e_i => E(2),
        shift => std_logic_vector(to_unsigned(0, 4)),
        x_result => result_in,
        y_result => result_in,
        x_in => x_holder(ITERATION_QUANTITY), 
        y_in => y_holder(ITERATION_QUANTITY), 
        x_out => x_holder(ITERATION_QUANTITY + 1), 
        y_out => y_holder(ITERATION_QUANTITY + 1),
        angle_result_in => result_holder(ITERATION_QUANTITY), 
        angle_result_out => result_holder(ITERATION_QUANTITY + 1)
    );

SCALING: FOR I IN 1 TO ITERATION_QUANTITY - 1 GENERATE
    scale: scailer port map (
        clk => clk, 
        e_i => E(I + 2),
        shift => std_logic_vector(to_unsigned(I, 4)),
        x_result => x_holder(ITERATION_QUANTITY + I),
        y_result => y_holder(ITERATION_QUANTITY + I),
        x_in => x_holder(ITERATION_QUANTITY), 
        y_in => y_holder(ITERATION_QUANTITY), 
        x_out => x_holder(ITERATION_QUANTITY + I + 1), 
        y_out => y_holder(ITERATION_QUANTITY + I + 1),
        angle_result_in => result_holder(ITERATION_QUANTITY + I), 
        angle_result_out => result_holder(ITERATION_QUANTITY + I + 1)
    );

END GENERATE;

--todo add registers for storing itermediate values of x[] and y[]
--todo fix rtl in scailer and alu (shift in function)
x_out <= x_holder(x_holder'length - 1);
y_out <= y_holder(y_holder'length - 1);
result_out <= result_holder(result_holder'length - 1);
end Behavioral;
