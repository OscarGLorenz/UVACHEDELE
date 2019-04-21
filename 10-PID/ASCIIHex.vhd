library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ASCIIHex is
  Port(
    hex : in std_logic_vector(3 downto 0);
    ascii : out std_logic_vector(7 downto 0)
  );
end ASCIIHex;

architecture Behavioral of ASCIIHex is
  begin
    with hex select ascii <=
      x"30" when x"0",
      x"31" when x"1",
      x"32" when x"2",
      x"33" when x"3",
      x"34" when x"4",
      x"35" when x"5",
      x"36" when x"6",
      x"37" when x"7",
      x"38" when x"8",
      x"39" when x"9",
      x"41" when x"A",
      x"42" when x"B",
      x"43" when x"C",
      x"44" when x"D",
      x"45" when x"E",
      x"46" when x"F",
      x"00" when others;
end Behavioral;
