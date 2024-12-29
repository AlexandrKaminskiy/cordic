----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2024 01:16:40
-- Design Name: 
-- Module Name: tb_top_module - Behavioral
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

entity tb_top_module is
--  Port ( );
end tb_top_module;

architecture Behavioral of tb_top_module is

component top_module_cordic is
    generic (N : integer := 16);
    Port ( 
        clk : in std_logic;
        goal: out std_logic_vector(N - 1 downto 0);
        x_out: out std_logic_vector(N - 1 downto 0);
        y_out: out std_logic_vector(N - 1 downto 0)
    );
end component;

constant n: integer := 16;

signal s_clk: std_logic := '0';
signal goal: std_logic_vector(N - 1 downto 0);
signal x_out: std_logic_vector(N - 1 downto 0);
signal y_out: std_logic_vector(N - 1 downto 0);

begin

clk_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
end process;

sin_gen: top_module_cordic port map (
    s_clk,
    goal,
    x_out,
    y_out
);

end Behavioral;
