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
      x_result: in std_logic_vector(N - 1 downto 0);
      y_result: in std_logic_vector(N - 1 downto 0);
      x_in: in std_logic_vector(N - 1 downto 0);
      y_in: in std_logic_vector(N - 1 downto 0);
      x_out: out std_logic_vector(N - 1 downto 0);
      y_out: out std_logic_vector(N - 1 downto 0);
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
variable sign_bits : std_logic_vector(shift - 1 downto 0);-- = (others => acc_temp0(acc_temp0'high));
begin
    sign_bits := (others => a(a'high));
    result := sign_bits & a(a'length - 1 downto sign_bits'length);
    return result;
end function;

begin

SCALE: process(CLK, x_in, y_in, x_result, y_result, e_i)
variable x_shifted: std_logic_vector(N - 1 downto 0);
variable y_shifted: std_logic_vector(N - 1 downto 0);
begin
    if rising_edge(clk) then
        if (e_i = '1') then
            x_shifted := perform_shift(x_in, to_integer(unsigned(shift)));
            s_x_out <= std_logic_vector(signed(x_shifted) + signed(x_result));
            
            y_shifted := perform_shift(y_in, to_integer(unsigned(shift)));
            s_y_out <= std_logic_vector(signed(y_shifted) + signed(y_result));
        else
            s_x_out <= x_result;
            s_y_out <= y_result;
        end if;
        angle_result_out <= angle_result_in;

    end if;    
end process;

x_out <= s_x_out;
y_out <= s_y_out;
end Behavioral;
