library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sendhex is
  Port(
  -- System signals
  clk : in std_logic;
  reset : in std_logic;

  data0  : in signed(10 downto 0) ;
  data1  : in signed(10 downto 0) ;
  data2  : in signed(10 downto 0) ;
  data3  : in signed(10 downto 0) ;
  data4  : in signed(10 downto 0) ;
  data5  : in signed(10 downto 0) ;

  -- I/O
  tx : out std_logic
  );
end sendhex;


architecture Behavioural of sendhex is
  component uart
  port (
  clk   : in  std_logic;
  reset : in  std_logic;
  tx    : out std_logic;
  send  : in  std_logic;
  busy : out std_logic;
  nextByte  : in  std_logic_vector(7 downto 0)
  );
end component uart;
component ASCIIHex
port (
  hex   : in  std_logic_vector(3 downto 0);
  ascii : out std_logic_vector(7 downto 0)
);
end component ASCIIHex;


-- Interconnect signals
signal send  : std_logic;
signal nextByte  : std_logic_vector(7 downto 0);
signal busy : std_logic;

-- Constants for line feed and space
constant LF : std_logic_vector(7 downto 0) := x"0A";
constant SPACE : std_logic_vector(7 downto 0) := x"20";
constant PLUS : std_logic_vector(7 downto 0) := x"20";
constant MINUS : std_logic_vector(7 downto 0) := x"20";

-- FSM States
type state_t is (S_WAIT, S_SGN, S_BYTE1, S_BYTE2, S_BYTE3, S_LF);
signal state : state_t := S_WAIT;

-- Aux buffer to store data
signal aux : signed(10 downto 0);

signal waitforit : std_logic := 0;
signal hex   : std_logic_vector(3 downto 0);
signal ascii : std_logic_vector(7 downto 0);
signal count : unsigned(2 downto 0) := (others => '0');
signal ascii  : std_logic_vector(7 downto 0);

begin
  HexToAscii : ASCIIHex
  port map (
    hex   => hex,
    ascii => ascii
  );

  uartMod : uart
  port map (
  clk   => clk,
  reset => reset,
  tx    => tx,
  send  => send,
  busy => busy,
  nextByte  => nextByte
  );

  process (clk, reset) begin
    if reset = '1' then
      state <= S_WAIT;
    elsif clk'event and clk='1' then
      case state is

        -- Wait until UART is not busy
        when S_WAIT =>
        send <= '0';
        if busy='0' then
          state <= S_SGN;
          case count is
            when "000" => aux <= data0;
            when "001" => aux <= data1;
            when "010" => aux <= data2;
            when "011" => aux <= data3;
            when "100" => aux <= data4;
            when "101" => aux <= data5;
          end case;
        end if;

        when S_SGN =>
        if busy='0' then
          if waitforit = '0' then
            case aux(10) is
              when '0' => nextByte <= PLUS;
              when '1' => nextByte <= MINUS;
                               aux <= not (aux - 1);
              when others => nextByte <= x"00";
            end case;
            send <= '1';
            waitforit <= '1';
          else
            waitforit <= '0';
            state <= S_BYTE1;
            hex <= "00" & aux(9 downto 8);
          end if;
        else
          send <= '0';
        end if;

        when S_BYTE1 =>
        if busy='0' then
          if waitforit = '0' then
            send <= '1';
            waitforit <= '1';
            nextByte <= ascii;
          else
            waitforit <= '0';
            state <= S_BYTE2;
            hex <= aux(7 downto 4);
          end if;
        else
          send <= '0';
        end if;

        when S_BYTE2 =>
        if busy='0' then
          if waitforit = '0' then
            send <= '1';
            waitforit <= '1';
            nextByte <= ascii;
          else
            waitforit <= '0';
            state <= S_BYTE3;
            hex <= aux(3 downto 0);
          end if;
        else
          send <= '0';
        end if;

        when S_BYTE3 =>
        if busy='0' then
          if waitforit = '0' then
            send <= '1';
            waitforit <= '1';
            nextByte <= ascii;
          else
            waitforit <= '0';
            state <= S_LF;
          end if;
        else
          send <= '0';
        end if;

        -- Send a space or a line feed at end of line
        when S_LF =>
        if busy='0' then
          if count = 5 then
            nextByte <= LF;
          else
            nextByte <= SPACE;
          end if;
          send <= '1';
          state <= S_WAIT;
          if count = 5 then
            count <= 0;
          else
            count <= count + 1;
          end if;
        else
          send <= '0';
        end if;

      end case;

    end if;
  end process;

end Behavioural;
