module rip.draw.lsystem;

private
{
	import std.math;
	import std.string;

	import rip.concepts;
	import rip.draw.turtle;
}

// Правила переписывания
alias RewritingRules = string[string];

// параметры L-системы
class LSystemParameters
{
	private
	{
		float x;
		float y;
		float stepIncrement;
		float angleIncrement;
		ulong numberOfGeneration;
	}

	this(S, T, U, V, W)(S x, T y, U stepIncrement, V angleIncrement, W numberOfGeneration)
		if (allArithmetic!(S, T, U, V, W))
	{
		this.x = cast(float) x;
		this.y = cast(float) y;
		this.stepIncrement = cast(float) stepIncrement;
		this.angleIncrement = cast(float) angleIncrement;
		this.numberOfGeneration = cast(uint) abs(numberOfGeneration);
	}

	
	mixin(addTypedGetter!("x", "getX"));
	mixin(addTypedGetter!("y", "getY"));
	mixin(addTypedGetter!("stepIncrement", "getStep"));
	mixin(addTypedGetter!("angleIncrement", "getAngle"));
	mixin(addTypedGetter!("numberOfGeneration", "getGeneration"));

	

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

	void setStep(T)(T angle)
		if (allArithmetic!T)
	{
		this.stepIncrement = cast(float) stepIncrement;
	}

	void setAngle(T)(T angle)
		if (allArithmetic!T)
	{
		this.angleIncrement = cast(float) angleIncrement;
	}

	void setGeneration(T)(T angle)
		if (allArithmetic!T)
	{
		this.numberOfGeneration = cast(uint) numberOfGeneration;
	}
}

class LSystem
{
	private
	{
		Surface surface;
		RGBColor color;

		LSystemParameters parameters;
		RewritingRules rules;
		string axiom;

		// процедура переписывания строки
		string rewrite(string sourceTerm, string termForRewrite, string newTerm)
		{
			auto acc = "";
			auto search = 0;

			for (uint i = 0; i < sourceTerm.length; i++)
			{
				auto index = indexOf(sourceTerm[search .. search + termForRewrite.length], termForRewrite);

				if (index != -1)
				{
					search += termForRewrite.length;
					acc ~= newTerm;
				}
				else
				{
					search++;
					acc ~= sourceTerm[search-1];
				}
			}
			
			return acc;
		}
	}

	this(Surface surface, RGBColor color, LSystemParameters parameters, 
		string axiom, RewritingRules rules)
	{
		this.surface = surface;
		this.color = color;
		this.parameters = parameters;
		this.axiom = axiom;
		this.rules = rules;
	}

	LSystemParameters execute()
	{
		// новое состояние черепахи
		auto turtleState = new TurtleState(
			parameters.getX!float, 
			parameters.getY!float, 
			parameters.getAngle!float
			);
		// новая черепаха
		auto turtle = new Turtle(surface, color, turtleState, 
			parameters.getStep!float, 
			parameters.getAngle!float
			);

		// команды L-системы
		auto lSystemCmd = axiom;

		// запуск процедуры переписывания
		for (ulong i = 1; i < parameters.getGeneration!ulong; i++)
		{
			foreach (rule; rules.keys)
			{
				lSystemCmd = rewrite(lSystemCmd.idup, rule, rules[rule]);
			}
		}

		turtle.execute(lSystemCmd);

		return parameters;
	}
}

