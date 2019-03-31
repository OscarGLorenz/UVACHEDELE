LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY HBridge IS
	GENERIC (
		pwm_res 	: INTEGER := 8;
		prescaler	: INTEGER := 2
	);
	PORT (
		clk         : IN STD_LOGIC;
		reset       : IN STD_LOGIC;
		enable		: IN STD_LOGIC;
		speedA    	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		speedB		: IN STD_LOGIC_VECTOR(7 downto 0);
		
		AIN1		: OUT STD_LOGIC;
		AIN2		: OUT STD_LOGIC;
		BIN1		: OUT STD_LOGIC;
		BIN2		: OUT STD_LOGIC;
		PWMA		: OUT STD_LOGIC;
		PWMB		: OUT STD_LOGIC
	);
END HBridge;

ARCHITECTURE Structural OF HBridge IS
-- GLOBAL SIGNALS #######################################################
	SIGNAL dirA		: STD_LOGIC;
	SIGNAL dirB		: STD_LOGIC;

	COMPONENT pwmGenerator IS 
		GENERIC(
			pwm_res		: INTEGER;
			prescaler 	: INTEGER
		);
		PORT(
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

-- Direction configuration, outsource as I/O if robot has retraction or pivoting enabled
dirA <= '0';				-- Invert if motor direction is wrong
dirB <= '0';				-- Invert if motor direction is wrong

pwmMotorA: pwmGenerator 
	GENERIC MAP(
		pwm_res => pwm_res,
		prescaler => prescaler
	)
	PORT MAP(
		clk => clk,
		reset => reset,
		enable => enable,
		speed => speedA,
		dir => dirA,
		dir1 => AIN1,
		dir2 => AIN2,
		pwm => PWMA
	);

pwmMotorB: pwmGenerator 
	GENERIC MAP(
		pwm_res => pwm_res,
		prescaler => prescaler
	)
	PORT MAP(
		clk => clk,
		reset => reset,
		enable => enable,
		speed => speedB,
		dir => dirB,
		dir1 => BIN1,
		dir2 => BIN2,
		pwm => PWMB
	);
		
END Structural;