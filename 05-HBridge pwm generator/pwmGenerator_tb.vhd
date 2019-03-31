LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY pwmGenerator_tb IS
	--no ports
END pwmGenerator_tb;

ARCHITECTURE Testbench OF pwmGenerator_tb IS

-- GLOBAL SIGNALS #######################################################
	CONSTANT sys_clk : INTEGER := 12_000_000;
	CONSTANT clk_period : TIME := 83 ns; --(1_000_000_000 / sys_clk) ns;
	CONSTANT pwm_res	: INTEGER := 8;
	CONSTANT prescaler 	: INTEGER := 2;
	CONSTANT pwm_period : INTEGER :=prescaler * (2**(pwm_res + 1)-4);
	CONSTANT pwm_freq : INTEGER := sys_clk / pwm_period;
	
	SIGNAL clk			: STD_LOGIC;
	SIGNAL reset		: STD_LOGIC := '0';
	SIGNAL enable		: STD_LOGIC := '0';
	SIGNAL speed		: STD_LOGIC_VECTOR(pwm_res - 1 DOWNTO 0);
	SIGNAL dir			: STD_LOGIC;
	SIGNAL dir1			: STD_LOGIC;
	SIGNAL dir2			: STD_LOGIC;
	SIGNAL pwm			: STD_LOGIC;

-- COMPONENTS DECLARATION ###############################################
	COMPONENT pwmGenerator IS 
		GENERIC(
			pwm_res		: INTEGER;
			prescaler 	: INTEGER
		);
		PORT (
			clk         : IN STD_LOGIC;
			reset       : IN STD_LOGIC;
			enable		: IN STD_LOGIC;
			speed    	: IN STD_LOGIC_VECTOR(pwm_res - 1 DOWNTO 0);
			dir			: IN STD_LOGIC;
		
			dir1		: OUT STD_LOGIC;
			dir2		: OUT STD_LOGIC;
			pwm			: OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN

-- PROCESSES of testbench ###############################################

clk_signal: 
PROCESS BEGIN
	clk <= '1';
	WAIT FOR clk_period/2;
	clk <= '0';
	WAIT FOR clk_period/2;
END PROCESS;

start_process:
PROCESS BEGIN
	reset <= '1';
	WAIT FOR clk_period;
	reset <= '0';
	WAIT FOR clk_period;
	enable <= '1';
	WAIT;
END PROCESS;

interactions_process:
PROCESS BEGIN
	speed <= "11111110";
	dir <= '1';
	
	
	WAIT;
END PROCESS;

-- COMPONENT INSTANTIATION AND PORT MAPS ################################
pwmMotor: pwmGenerator 
	GENERIC MAP(
		pwm_res => pwm_res,
		prescaler => prescaler
	)
	PORT MAP(
		clk => clk,
		reset => reset,
		enable => enable,
		speed => speed,
		dir => dir,
		dir1 => dir1,
		dir2 => dir2,
		pwm => pwm
	);
	
END Testbench;