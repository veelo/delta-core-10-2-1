module delta.core.formlogic;

enum FormComponent;

struct FormAction
{
	string methodName;
}

struct FormEvent
{
	string eventName;
	string methodName;
}

mixin template formLogic()
{
    auto doit = {
        import std.traits: hasUDA, getUDAs;

		static foreach(member; __traits(allMembers, typeof(this)))
		{
			static if(__traits(compiles, typeof(__traits(getMember, typeof(this), member))) &&
			hasUDA!( __traits(getMember, typeof(this), member), FormComponent))
			{
				{
					auto component = FindComponent(member);
					if (component is null)
					{
						import std.stdio;
						writeln("Component not found: ", member);
						assert(false);
					}
					
					
					__traits(getMember, typeof(this), member) = cast(typeof(__traits(getMember, typeof(this), member))) component;
					
					static if(hasUDA!( __traits(getMember, typeof(this), member), FormEvent))
					{
						enum eventName = getUDAs!(__traits(getMember, typeof(this), member), FormEvent)[0].eventName;
						enum methodName = getUDAs!(__traits(getMember, typeof(this), member), FormEvent)[0].methodName;
						mixin(member~"."~eventName~" = &"~methodName~";");
					}
				}
				
			}
		}

		return true;
    }();
}