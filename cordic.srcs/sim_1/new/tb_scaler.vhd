----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2024 12:05:57
-- Design Name: 
-- Module Name: tb_scaler - Behavioral
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

entity tb_scaler is
--  Port ( );
end tb_scaler;

architecture Behavioral of tb_scaler is

component scailer is
    generic (N : integer := 16);
    Port ( 
        clk: in std_logic;
        e_i: in std_logic;
        shift: in std_logic_vector(3 downto 0);
        x_result_in: in std_logic_vector(N - 1 downto 0);
        y_result_in: in std_logic_vector(N - 1 downto 0);
        x_in: in std_logic_vector(N - 1 downto 0);
        y_in: in std_logic_vector(N - 1 downto 0);
        x_result_out: out std_logic_vector(N - 1 downto 0);
        y_result_out: out std_logic_vector(N - 1 downto 0);
        x_out: out std_logic_vector(N - 1 downto 0);
        y_out: out std_logic_vector(N - 1 downto 0);
        angle_result_in: in std_logic_vector(N - 1 downto 0);
        angle_result_out: out std_logic_vector(N - 1 downto 0)
    );
end component;
constant n: integer := 16;
constant E: std_logic_vector(0 to n-1) := "0001001101100111";

signal x_in : std_logic_vector (n - 1 downto 0) := x"fffa";
signal y_in : std_logic_vector (n - 1 downto 0) := x"cb4d";
signal s_clk: std_logic := '0';

signal x_out: STD_LOGIC_VECTOR(n - 1 downto 0);
signal y_out: STD_LOGIC_VECTOR(n - 1 downto 0);
signal s_angle_result_in: STD_LOGIC_VECTOR(n - 1 downto 0) := "0000000000000000";
signal s_angle_result_out: STD_LOGIC_VECTOR(n - 1 downto 0) := "0000000000000000";
signal result_in_x : std_logic_vector (n - 1 downto 0) := x"fffd";
signal result_in_y : std_logic_vector (n - 1 downto 0) := x"e5a6";

signal i : integer := 0;
begin
clk_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
end process;

scale: scailer port map (
    s_clk, 
    E(6),
    std_logic_vector(to_unsigned(1, 4)),
    result_in_x, 
    result_in_y,
    x_in, 
    y_in, 
    x_out,
    y_out,
    x_out,
    y_out,
    s_angle_result_in,
    s_angle_result_out
);
    
end Behavioral;
