----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2024 02:35:20
-- Design Name: 
-- Module Name: tb_alu_sequence - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_alu_sequence is
--  Port ( );
end tb_alu_sequence;

architecture Behavioral of tb_alu_sequence is


component alu_sequence is
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
end component;

constant n: integer := 16;

signal result_in : std_logic_vector (n - 1 downto 0) := "0000000000000000";
constant goal : std_logic_vector (n - 1 downto 0) := x"cdbd";
signal x_in : std_logic_vector (n - 1 downto 0) := "0010000000000000";
signal y_in : std_logic_vector (n - 1 downto 0) := "0000000000000000";
signal s_clk: std_logic := '0';

signal result_out: STD_LOGIC_VECTOR(n - 1 downto 0);
signal x_out: STD_LOGIC_VECTOR(n - 1 downto 0);
signal y_out: STD_LOGIC_VECTOR(n - 1 downto 0);

begin

clk_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
end process;

alu: alu_sequence port map (s_clk, goal, x_in, y_in, result_out, x_out, y_out);


end Behavioral;
