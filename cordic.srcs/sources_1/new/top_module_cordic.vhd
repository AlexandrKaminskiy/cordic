----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2024 13:56:39
-- Design Name: 
-- Module Name: top_module_cordic - Behavioral
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

entity top_module_cordic is
    generic (N : integer := 16);
    Port ( 
        clk : in std_logic;
        goal: out std_logic_vector(N - 1 downto 0);
        x_out: out std_logic_vector(N - 1 downto 0);
        y_out: out std_logic_vector(N - 1 downto 0)
    );
end top_module_cordic;

architecture Behavioral of top_module_cordic is

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

constant pidiv2: std_logic_vector(n - 1 downto 0) := x"3243";
constant pi: std_logic_vector(n - 1 downto 0) := x"6486";
constant minuspi: std_logic_vector(n - 1 downto 0) := x"9B79";
constant minuspidiv2: std_logic_vector(n - 1 downto 0) := x"cdbd";
constant quantum_step: std_logic_vector(n - 1 downto 0) := x"000e";
signal current_angle: std_logic_vector(n - 1 downto 0) := "0000000000000000";

signal x_in : std_logic_vector (n - 1 downto 0) := "0010000000000000";
signal y_in : std_logic_vector (n - 1 downto 0) := "0000000000000000";
signal result_out : std_logic_vector(N - 1 downto 0) := "0000000000000000";

signal clockwise: std_logic := '0';
begin

VALUES_GEN: process (CLK)
variable current_angle_var: std_logic_vector(N - 1 downto 0) := "0000000000000000";
begin
    if (rising_edge(CLK)) then
        if (clockwise = '0') then
            current_angle_var := std_logic_vector(signed(current_angle) + signed(quantum_step));
            if ((signed(current_angle_var) >= 0) and (signed(current_angle_var) - signed(pidiv2) > 0)) then
                clockwise <= '1';
            else 
                clockwise <= '0';
            end if;
        else
            current_angle_var := std_logic_vector(signed(current_angle) - signed(quantum_step));
            if ((signed(current_angle_var) < 0) and (signed(minuspidiv2) - signed(current_angle_var) > 0)) then
                clockwise <= '0';
            else 
                clockwise <= '1';
            end if;
        end if;
    
        current_angle <= current_angle_var;
        
    end if;
end process;

CORDIC: alu_sequence port map (clk, current_angle, x_in, y_in, goal, x_out, y_out);

end Behavioral;
