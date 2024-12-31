----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2024 02:07:10
-- Design Name: 
-- Module Name: cordic_alu - Behavioral
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

entity cordic_alu is
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
end cordic_alu;

architecture Behavioral of cordic_alu is


signal s_x_out: std_logic_vector(N - 1 downto 0);
signal s_y_out: std_logic_vector(N - 1 downto 0);
signal s_result: std_logic_vector(N - 1 downto 0);

function shift(
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

PERFORM_STEP: process (CLK)
    variable x_shifted: std_logic_vector(N - 1 downto 0);
    variable y_shifted: std_logic_vector(N - 1 downto 0);
begin
    if (rising_edge(CLK)) then
        x_shifted := shift(x_in, to_integer(unsigned(iteration)));
        y_shifted := shift(y_in, to_integer(unsigned(iteration)));
        
        if (signed(result_in) - signed(goal) < 0) then
            s_x_out <= std_logic_vector(signed(x_in) - signed(y_shifted));
            s_y_out <= std_logic_vector(signed(y_in) + signed(x_shifted));
            s_result <= std_logic_vector(signed(result_in) + signed(arctan_value));
        else
            s_x_out <= std_logic_vector(signed(x_in) + signed(y_shifted));
            s_y_out <= std_logic_vector(signed(y_in) - signed(x_shifted));
            s_result <= std_logic_vector(signed(result_in) - signed(arctan_value));
        end if;
        goal_out <= goal;
    end if;
    
end process;

x_out <= s_x_out;
y_out <= s_y_out;
result_out <= s_result;

end Behavioral;
