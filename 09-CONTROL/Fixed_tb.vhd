library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fixtb is
end fixtb;

architecture B of fixtb is
  component fixed
  port (
    number     : in  signed(10 downto 0);
    multiplier : in  std_logic_vector(7 downto 0);
    outrut     : out signed(10 downto 0)
  );
  end component fixed;

  signal number     : signed(10 downto 0);
  signal multiplier : std_logic_vector(7 downto 0);
  signal outrut     : signed(10 downto 0);



begin
  FixedEntity : fixed
  port map (
    number     => number,
    multiplier => multiplier,
    outrut     => outrut
  );

  number <= ( not ("000" & x"80")) + 1;


  multiplier <= "11000000";

  process begin
    wait for 1 ns;
    wait;
  end process;


end B;
