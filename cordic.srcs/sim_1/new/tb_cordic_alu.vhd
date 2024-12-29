----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2024 00:38:27
-- Design Name: 
-- Module Name: tb_cordic_alu - Behavioral
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

entity tb_cordic_alu is
--  Port ( );
end tb_cordic_alu;

architecture Behavioral of tb_cordic_alu is

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

constant n: integer := 16;
signal arctan_value : std_logic_vector (n - 1 downto 0) := "0001100100100001";
signal iteration: std_logic_vector(3 downto 0) := "0000";
signal result_in : std_logic_vector (n - 1 downto 0) := "0000000000000000";
constant goal : std_logic_vector (n - 1 downto 0) := "0010000110000010";
signal x_in : std_logic_vector (n - 1 downto 0) := "0010000000000000";
signal y_in : std_logic_vector (n - 1 downto 0) := "0000000000000000";
signal s_clk: std_logic := '0';

signal result_out: STD_LOGIC_VECTOR(n - 1 downto 0);
signal goal_out: STD_LOGIC_VECTOR(n - 1 downto 0);
signal x_out: STD_LOGIC_VECTOR(n - 1 downto 0);
signal y_out: STD_LOGIC_VECTOR(n - 1 downto 0);

begin

clk_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
    s_clk <= not s_clk;
    wait for 40ns;
    x_in <= x_out;
    y_in <= y_out;
    result_in <= result_out;
    iteration <= "0001";
    arctan_value <= "0000111011010110";
    s_clk <= not s_clk;
    wait for 40ns;
end process;

alu: cordic_alu port map (s_clk, iteration, arctan_value, result_in, goal, x_in, y_in, result_out, x_out, y_out, goal_out);

end Behavioral;
