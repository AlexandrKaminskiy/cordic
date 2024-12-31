----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2024 11:37:02
-- Design Name: 
-- Module Name: scailer - Behavioral
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

entity scailer is
    generic (N : integer := 16);
    Port ( 
      clk: in std_logic;
      e_i: in std_logic;
      shift: in std_logic_vector(3 downto 0);
      x_result_in: in std_logic_vector(N - 1 downto 0); -- from scale
      y_result_in: in std_logic_vector(N - 1 downto 0); -- from scale
      x_in: in std_logic_vector(N - 1 downto 0); -- from alu
      y_in: in std_logic_vector(N - 1 downto 0); -- from alu
      x_result_out: out std_logic_vector(N - 1 downto 0); -- after scale
      y_result_out: out std_logic_vector(N - 1 downto 0); -- after scale
      x_out: out std_logic_vector(N - 1 downto 0); -- from alu
      y_out: out std_logic_vector(N - 1 downto 0); -- from alu
      angle_result_in: in std_logic_vector(N - 1 downto 0);
      angle_result_out: out std_logic_vector(N - 1 downto 0)
    );
end scailer;

architecture Behavioral of scailer is

signal s_x_out: std_logic_vector(N - 1 downto 0);
signal s_y_out: std_logic_vector(N - 1 downto 0);

function perform_shift(
    a: std_logic_vector(N - 1 downto 0);
    shift: integer
) return std_logic_vector is
variable result: std_logic_vector(N - 1 downto 0);
variable sign_bits : std_logic_vector(N - 1 downto 0);-- = (others => acc_temp0(acc_temp0'high));
begin
    for i in 0 to N - 1 loop
        if i < shift then
            result(N - i - 1) := a(a'high);  -- Заполняем знаковыми битами
        else
            result(N - i - 1) := a(N - i - 1 + shift);
        end if;
    end loop;
    return result;
end function;

begin

SCALE: process(CLK, x_in, y_in, x_result_in, y_result_in, e_i)
variable x_shifted: std_logic_vector(N - 1 downto 0);
variable y_shifted: std_logic_vector(N - 1 downto 0);
begin
    if rising_edge(clk) then
        if (e_i = '1') then
            x_shifted := perform_shift(x_in, to_integer(unsigned(shift)));
            s_x_out <= std_logic_vector(signed(x_shifted) + signed(x_result_in));
            
            y_shifted := perform_shift(y_in, to_integer(unsigned(shift)));
            s_y_out <= std_logic_vector(signed(y_shifted) + signed(y_result_in));
        else
            s_x_out <= x_result_in;
            s_y_out <= y_result_in;
        end if;
        angle_result_out <= angle_result_in;
        x_out <= x_in;
        y_out <= y_in;
    end if;    
end process;

x_result_out <= s_x_out;
y_result_out <= s_y_out;
end Behavioral;
