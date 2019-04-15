library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fixed is
  port (
  number      : in signed(10 downto 0);
  multiplier  : in std_logic_vector(7 downto 0);
  outrut      : out signed(10 downto 0)
  );
end fixed;

architecture ALU of fixed is
  signal mask0      : signed(10 downto 0);
  signal mask1      : signed(10 downto 0);
  signal mask2      : signed(10 downto 0);
  signal mask3      : signed(10 downto 0);
  signal mask4      : signed(10 downto 0);
  signal mask5      : signed(10 downto 0);
  signal mask6      : signed(10 downto 0);
  signal mask7      : signed(10 downto 0);

  signal comp     :  signed(10 downto 0) := (others => '0');

  begin
    comp <= not (number - 1) ;

    mask0 <= (others => '1') when multiplier(0) = '1' else (others => '0');
    mask1 <= (others => '1') when multiplier(1) = '1' else (others => '0');
    mask2 <= (others => '1') when multiplier(2) = '1' else (others => '0');
    mask3 <= (others => '1') when multiplier(3) = '1' else (others => '0');
    mask4 <= (others => '1') when multiplier(4) = '1' else (others => '0');
    mask5 <= (others => '1') when multiplier(5) = '1' else (others => '0');
    mask6 <= (others => '1') when multiplier(6) = '1' else (others => '0');
    mask7 <= (others => '1') when multiplier(7) = '1' else (others => '0');

outrut <=
    (mask7 and ("0" & number(9 downto 0))) +
    (mask6 and ("00" & number(9 downto 1))) +
    (mask5 and ("000" & number(9 downto 2))) +
    (mask4 and ("0000" & number(9 downto 3))) +
    (mask3 and ("00000" & number(9 downto 4))) +
    (mask2 and ("000000" & number(9 downto 5))) +
    (mask1 and ("0000000" & number(9 downto 6))) +
    (mask0 and ("00000000" & number(9 downto 7)))
when number(10) = '0' else
      (not (
      (mask7 and ("0" & comp(9 downto 0))) +
      (mask6 and ("00" & comp(9 downto 1))) +
      (mask5 and ("000" & comp(9 downto 2))) +
      (mask4 and ("0000" & comp(9 downto 3))) +
      (mask3 and ("00000" & comp(9 downto 4))) +
      (mask2 and ("000000" & comp(9 downto 5))) +
      (mask1 and ("0000000" & comp(9 downto 6))) +
      (mask0 and ("00000000" & comp(9 downto 7))))) +1;




    end ALU;
