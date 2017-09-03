module System.Actions;

import delta.core;
import System.Classes: TComponent, TBasicAction;

class TContainedActionList: TComponent
{
	this(int reference)
	{
		super(reference);
	}
}

class TContainedAction: TBasicAction
{
	mixin(GenStringProperty!("Category"));
	mixin(GenBoolProperty!("Enabled"));
	
	this(int reference)
	{
		super(reference);
	}
}