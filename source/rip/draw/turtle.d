module rip.draw.turtle;

private
{
	import std.math;
	import std.random;

	import rip.concepts;
	import rip.draw.primitives : drawDDALine;
}

// состояние черепахи
class TurtleState
{
	private
	{
		float x;
		float y;
		float angle;
	}

	this(T, U, V)(T x, U y, V angle)
		if (allArithmetic!(T, U, V))
	{
		this.x = cast(float) x;
		this.y = cast(float) y;
		this.angle = cast(float) angle;
	}

	mixin(addTypedGetter!("x", "getX"));
	
	mixin(addTypedGetter!("y", "getY"));

	mixin(addTypedGetter!("angle", "getAngle"));

	void setX(T)(T x)
		if (allArithmetic!T)
	{
		this.x = cast(float) x;
	}

	void setY(T)(T y)
		if (allArithmetic!T)
	{
		this.y = cast(float) y;
	}
	
	void setAngle(T)(T angle)
		if (allArithmetic!T)
	{
		this.angle = cast(float) angle;
	}
}


// И теперь в наших руках появляется мощное оружие - исполнитель "черепаха"... 
class Turtle
{
	private
	{
		Surface surface;
		RGBColor color;

		TurtleState[] stateStack;
		TurtleState state;

		float stepIncrement;
		float angleIncrement;
	}

	this(T, U)(Surface surface, RGBColor color, TurtleState state, T stepIncrement, U angleIncrement)
		if (allArithmetic!(T, U))
	{
		this.surface = surface;
		this.color = color;
		this.state = state;
		this.stepIncrement = cast(float) stepIncrement;
		this.angleIncrement = cast(float) angleIncrement;
	}

	// шаг вперед с отрисовкой следа
	TurtleState drawStep()
	{
		float newX, newY;

		newX = state.getX!float + cos(state.getAngle!float) * stepIncrement;
		newY = state.getY!float - sin(state.getAngle!float) * stepIncrement;

		surface.drawDDALine(color, 
			state.getX!float, 
			state.getY!float,
			newX,
			newY
			);

		state.setX(newX);
		state.setY(newY);

		return state;
	}

	// шаг вперед без отрисовки следа
	TurtleState moveStep()
	{
		float newX, newY;
		
		newX = state.getX!float + cos(state.getAngle!float) * stepIncrement;
		newY = state.getY!float - sin(state.getAngle!float) * stepIncrement;

		state.setX(newX);
		state.setY(newY);
		
		return state;
	}

	// поворот влево
	TurtleState rotateLeft()
	{
		float newAngle;

		newAngle = state.getAngle!float + angleIncrement;

		state.setAngle(newAngle);

		return state;
	}

	// поворот вправо
	TurtleState rotateRight()
	{
		float newAngle;
		
		newAngle = state.getAngle!float - angleIncrement;
		
		state.setAngle(newAngle);
		
		return state;
	}

	// поворот на случайный угол
	TurtleState rotateRandom()
	{
		float newAngle;

		auto rndGenerator = new Random(unpredictableSeed);
		newAngle = uniform(-2 * PI, 2 * PI, rndGenerator);
		
		state.setAngle(newAngle);
		
		return state;
	}

	// сохранить состояние черепахи
	TurtleState saveState()
	{
		stateStack ~= state;

		return state;
	}
	
	// восстановить состояние черепахи
	TurtleState restoreState()
	{
		state = stateStack[$-1];
		stateStack = stateStack[0 .. $-1];

		return state;
	}

	// выполнить команду с помощью черепахи
	TurtleState execute(string s)
	{
		TurtleState currentState;
		for (int i = 0; i < s.length; i++)
		{
			switch(s[i])
			{
				case 'F':
					currentState = drawStep();
					break;
				case 'f':
					currentState = moveStep();
					break;
				case '+':
					currentState = rotateRight();
					break;
				case '-':
					currentState = rotateLeft();
					break;
				case '?':
					currentState = rotateRandom();
					break;
				case '[':
					currentState = saveState();
					break;
				case ']':
					currentState = restoreState();
					break;
				default:
					break;
			}
		}

		return currentState;
	}
}
